AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Pac-Man"
ENT.Category = "Pac-Man"
ENT.Author = "SMOK"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local gridHeight = {}
local gridFull = {}
local grid = {}
local walls = {
    
    "#####################",
    "#*........#........*#",
    "#.##.####.#.####.##.#",
    "#.##.####.#.####.##.#",
    "#...................#",
    "#.##.#.#######.#.##.#",
    "#....#....#....#....#",
    "####.####.#.####.####",
    "#  #.#.........#.#  #",
    "####.#.###-###.#.####",
    ",   ...#     #...    ",
    "####.#.#######.#.####",
    "####.#.........#.####",
    "#......##.#.##......#",
    "#.##.####.#.####.##.#",
    "#..#.............#..#",
    "##.#.#.#######.#.#.##",
    "#....#....#....#....#",
    "#.#######.#.#######.#",
    "#*.................*#",
    "#####################"
    
}

if CLIENT then
    surface.CreateFont( "PacManDefault", {
        font = "Arial", 
        extended = false,
        size = 200,
        weight = 1000,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )
end



function ENT:Initialize()

    if SERVER then

        self.grid = false
        self.gameSpeed = 2
        self.tick = 1
        self.gameStateStarted = false
        self.walls = false
        self.gameStartTime = CurTime()
        self.gameState = ""
        self.lives = 1
        self.lifeProps = {}
        self.gameOver = false  
        self.gamePaused = true
        self.resetTimer = 0

        self.pMoveDirection = nil
        self.pNextMoveDirection = nil
        self.pacman = nil
        self.pacmanPhys = nil
        self.pacmanOriginGridPos = {34 , 5}
        self.pacmanGridPos = {34 , 5}


        self.ghostsPanic = false 
        self.ghostsPanicTimer = nil
        self.ghosts = {
            [1] = {
                ghost = nil,
                ghostOriginPos = {50 , 42},
                ghostGridPos = {50 , 42},
                ghostScatterPoint = {95,5},
                ghostTimer = CurTime(),
                ghostState = "home",
                ghostTargetBall = nil,
                ghostColor = Color(255,0,0),
                ghostHitBox = {},
                insideDoor = false,
                ghostHomeDelay = 0,
                ghostHomeTimer = 0
            },
            [2] = {
                ghost = nil,
                ghostOriginPos = {50 , 46},
                ghostGridPos = {50 , 46},
                ghostScatterPoint = {95,95},
                ghostTimer = CurTime(),
                ghostState = "home",
                ghostTargetBall = nil,
                ghostColor = Color(0,255,0),
                ghostHitBox = {},
                insideDoor = false,
                ghostHomeDelay = 5,
                ghostHomeTimer = 0                
            },
            [3] = {
                ghost = nil,
                ghostOriginPos = {50 , 50},
                ghostGridPos = {50 , 50},
                ghostScatterPoint = {5,5},
                ghostTimer = CurTime(),
                ghostState = "home",
                ghostTargetBall = nil,
                ghostColor = Color(92,92,255),
                ghostHitBox = {},
                insideDoor = false,
                ghostHomeDelay = 10,
                ghostHomeTimer = 0
            },
            [4] = {
                ghost = nil,
                ghostOriginPos = {50 , 58},
                ghostGridPos = {50 , 58},
                ghostScatterPoint = {5,95},
                ghostTimer = CurTime(),
                ghostState = "home",
                ghostTargetBall = nil,
                ghostColor = Color(255,136,0),
                ghostHitBox = {},
                insideDoor = false,
                ghostHomeDelay = 15,
                ghostHomeTimer = 0
            }
        }

        -- self.ghost1 = nil 
        -- self.ghost1GridPos = {50 , 50}
        -- self.ghost1ScatterPoint = {95,5}
        -- self.ghost1Timer = 0
        -- self.ghost1State = "scatter"
        -- self.ghost1TargetBall = nil

        -- self.ghost2 = nil 
        -- self.ghost2GridPos = {54 , 50}
        -- self.ghost2ScatterPoint = {95,95}
        -- self.ghost2Timer = 0
        

        self.pacmanScore = 0 

        self:SetModel("models/hunter/plates/plate3x3.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetAngles(Angle(90,90,90))

        local phys = self:GetPhysicsObject()
        
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(0)
            --phys:EnableDrag(false)
            phys:EnableGravity(false)
            phys:EnableMotion(false)
            
        end

        util.AddNetworkString("pacmanScore")
        util.AddNetworkString("pacmanGameOver")

    end

    if CLIENT then
        
        self.cl_pacmanScore = 0
        self.cl_gameOver = false
        self.cl_displace = 0
        self.cl_sampleTime = 0
        self.cl_displaceTime = 0

    end

    hook.Add("PlayerBindPress", "PacManUnbindInputs", UnbindInputs)
    hook.Add("PlayerButtonDown", "PacManKeyPress", function(ply, key)
        self:keyPress(ply, key)
    end)

    hook.Add("Tick","PacManMove",function()
        self:MovePacMan()
        self:GhostThink()
    end)

end

function ENT:Think()

    local mins = self:OBBMins()
    local maxs = self:OBBMaxs()

    local positions = {

        leftBottom = Vector(maxs.x, mins.y, maxs.z),
        leftUp = Vector(mins.x, mins.y, maxs.z),
        rightDown = Vector(mins.x, maxs.y, mins.z),
        rightUp = Vector(maxs.x, maxs.y, mins.z + 20),

    }


    if not self.grid then

        for i = 0, 100 do 
            grid[i] = {}
            for j = 0, 100 do 
                grid[i][j] = {pos = positions.leftBottom + Vector(positions.leftUp.x*2, 0, 0) * i * 0.01 + Vector(0, positions.rightDown.y*2, 0) * j * 0.01  , wall = false }
            end
        end

        self.grid = true

    end

    if SERVER then

        function MarkGridInfo(x, y, data, name)
            if name == "dot" or name == "energizer" then
                grid[y][x][name] = true
                grid[y][x].obj = data
            else
                for i = y - 4, y + 4 do
                    for j = x - 4, x + 4 do
                        if grid[i] and grid[i][j] then
                            local dataName = name
                            grid[i][j][name] = true
                            grid[i][j].obj = data
                        end
                    end
                end
            end
        end

        for i, v in pairs(self.lifeProps) do 

            v:SetPos(self:GetPos() + self:GetRight()*80 + self:GetRight()*i*10 - self:GetForward()*40)
            v:SetAngles(self:GetAngles())

        end

        if not self.walls then

            for y = #walls, 1, -1 do
                
                for x = 0, #walls[y] do

                    local char = walls[y]:sub(x,x)
                    local yFlipped = #walls - y
                    if char == "#" then
                        local wall = ents.Create("prop_physics")
                        print(yFlipped, x )
                        wall:SetModel("models/hunter/plates/plate.mdl")
                        wall:SetPos(self:LocalToWorld(grid[(yFlipped)*5][(x-1)*5].pos) + self:GetUp()*-6)
                        wall:SetAngles(self:GetAngles())
                        wall:SetModelScale(2.5)
                        MarkGridInfo((x-1) * 5, (yFlipped) * 5, wall, "wall")
                    end

                    if char == "-" then
                        local door = ents.Create("prop_physics")
                        print(yFlipped, x )
                        door:SetModel("models/hunter/plates/plate025x025.mdl")
                        door:SetPos(self:LocalToWorld(grid[(yFlipped)*5][(x-1)*5].pos))
                        door:SetAngles(self:GetAngles() + Angle(90,0,0))
                        door:SetModelScale(0.5)
                        MarkGridInfo((x-1) * 5, (yFlipped) * 5, door, "door")
                        self.doorGridPos = {(yFlipped) * 5, (x-1) * 5}
                    end

                    if char == "." then
                        local dot = ents.Create("prop_physics")
                        dot:SetModel("models/hunter/misc/sphere025x025.mdl")
                        dot:SetMaterial("models/pacman/PacManMaterial")
                        dot:SetPos(self:LocalToWorld(grid[(yFlipped)*5][(x-1)*5].pos))
                        dot:SetAngles(self:GetAngles())
                        dot:SetModelScale(0.1)
                        MarkGridInfo((x-1) * 5, (yFlipped) * 5, dot, "dot")
                    end

                    if char == "*" then
                        local enrg = ents.Create("prop_physics")
                        enrg:SetModel("models/hunter/misc/sphere025x025.mdl")
                        enrg:SetMaterial("models/pacman/PacManMaterial")
                        enrg:SetPos(self:LocalToWorld(grid[(yFlipped)*5][(x-1)*5].pos))
                        enrg:SetAngles(self:GetAngles())
                        enrg:SetModelScale(0.3)
                        MarkGridInfo((x-1) * 5, (yFlipped) * 5, enrg, "energizer")
                    end

                end

            end
            self.walls = true

        end

        -- if self.pacman and self.pacman:IsSequenceFinished() self.pacman:seq then
        --     self.pacman:SetSequence(2)
        -- end

    end

    if SERVER and not self.gameStateStarted then

        local pacman = ents.Create("pacman_ent")
        pacman:SetModel("models/smok/pacman/pacman.mdl")
        pacman:SetColor(Color(255,255,0))
        pacman:Spawn()
        pacman:SetPos(self:LocalToWorld(grid[self.pacmanOriginGridPos[1]][self.pacmanOriginGridPos[2]].pos))
        pacman:SetModelScale(3.5)
        pacman:DrawShadow(false )
        pacman:SetAngles(self:GetAngles())
        self.pacman = pacman
        local pacmanPhys = pacman:GetPhysicsObject()

        for i, v in pairs(self.ghosts) do 

            local ghost = ents.Create("prop_physics")
            ghost:SetModel("models/smok/pacman/pacman_ghost.mdl")
            ghost:SetPos(self:LocalToWorld(grid[self.ghosts[i].ghostGridPos[1]][self.ghosts[i].ghostGridPos[2]].pos))
            ghost:SetModelScale(3)
            ghost:SetAngles(self:GetAngles())
            ghost:SetMaterial("models/pacman/PacManMaterial")
            ghost:SetColor(self.ghosts[i].ghostColor)
            self.ghosts[i].ghost = ghost

            local ghostTargetBall = ents.Create("prop_physics")
            ghostTargetBall:SetModel("models/hunter/plates/plate.mdl")
            ghostTargetBall:SetMaterial("models/pacman/PacManMaterial")
            ghostTargetBall:SetColor(self.ghosts[i].ghostColor)
            self.ghosts[i].ghostTargetBall = ghostTargetBall

        end

        for i = 1, self.lives do 
            local pacmanLives = ents.Create("prop_physics")
            pacmanLives:SetModel("models/smok/pacman/pacman.mdl")
            pacmanLives:SetColor(Color(255,255,0))
            pacmanLives:SetPos(self:GetPos() + self:GetRight()*80 + self:GetRight()*i*10 - self:GetForward()*40)
            pacmanLives:SetModelScale(3.5)
            pacmanLives:DrawShadow(false )
            pacmanLives:SetAngles(self:GetAngles())
            table.insert(self.lifeProps, pacmanLives)
        end


        -- local ghost1 = ents.Create("prop_physics")
        -- ghost1:SetModel("models/smok/pacman/pacman_ghost.mdl")
        -- ghost1:SetPos(self:LocalToWorld(grid[self.ghosts[1].ghostGridPos[1]][self.ghosts[1].ghostGridPos[2]].pos))
        -- ghost1:SetModelScale(3)
        -- ghost1:SetAngles(self:GetAngles())

        -- ghost1:SetMaterial("models/pacman/PacManMaterial")
        -- ghost1:SetColor(Color(255,0,0))
        -- --self.ghost1 = ghost1
        -- self.ghosts[1].ghost = ghost1

        -- local ghost1TargetBall = ents.Create("prop_physics")
        -- ghost1TargetBall:SetModel("models/hunter/plates/plate.mdl")
        -- ghost1TargetBall:SetMaterial("models/pacman/PacManMaterial")
        -- ghost1TargetBall:SetColor(Color(255,0,0))
        -- --self.ghost1TargetBall = ghost1TargetBall
        -- self.ghosts[1].ghostTargetBall = ghost1TargetBall

        -- local ghost2 = ents.Create("prop_physics")
        -- ghost2:SetModel("models/smok/pacman/pacman_ghost.mdl")
        -- ghost2:SetPos(self:LocalToWorld(grid[self.ghosts[2].ghostGridPos[1]][self.ghosts[2].ghostGridPos[2]].pos))
        -- ghost2:SetModelScale(3)
        -- ghost2:SetAngles(self:GetAngles())

        -- ghost2:SetMaterial("models/pacman/PacManMaterial")
        -- ghost2:SetColor(Color(5,255,5))
        -- self.ghosts[2].ghost = ghost2

        -- local ghost2TargetBall = ents.Create("prop_physics")
        -- ghost2TargetBall:SetModel("models/hunter/plates/plate.mdl")
        -- ghost2TargetBall:SetMaterial("models/pacman/PacManMaterial")
        -- ghost2TargetBall:SetColor(Color(0,255,0))
        -- self.ghosts[2].ghostTargetBall = ghost2TargetBall

         self.gameStateStarted = true
    end

    if CLIENT then

        if self.cl_displace > 0.5 and CurTime() - self.cl_displaceTime < 5 then
            self.cl_displace = self.cl_displace - (self.cl_displace*2^(-(CurTime() - self.cl_displaceTime)))/12 -- i dont know math, sorry
            self.cl_sampleTime = CurTime() + 0.015
            
        elseif self.cl_displace < 0.5 or CurTime() - self.cl_displaceTime > 5 then
            self.cl_displace = 0
        end

        hook.Add("PostDrawOpaqueRenderables", "drawPacManText", function()

            net.Receive("pacmanScore", function()
                local netScore = net.ReadInt(14)
                print("THIS IS RECIVED SCORE", netScore)
                self.cl_pacmanScore = netScore
                -- self.cl_displace = self.cl_displace + 20
                -- self.cl_displaceTime = CurTime()
            end)

            net.Receive("pacmanGameOver", function()
                local status = net.ReadBool()
                self.cl_gameOver = status
                self.cl_displace = self.cl_displace + 20
                self.cl_displaceTime = CurTime()
            end)

            surface.SetFont( "PacManDefault" )
            local textWidth, textHeight = surface.GetTextSize("text")

            local pos = self:GetPos()
            pos = pos + self:GetRight() * 100
            local textAng = self:GetAngles()
            textAng:RotateAroundAxis(self:GetAngles():Up(),90)

            cam.Start3D2D(pos, textAng, 0.04)  
                        
                draw.SimpleTextOutlined("SCORE", "PacManDefault", -textWidth ,-textHeight  , color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,20,color_black)
                draw.SimpleTextOutlined("LIVES", "PacManDefault", -textWidth ,-textHeight *8 , color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,20,color_black)  

            cam.End3D2D() 

            cam.Start3D2D(pos + self:GetForward()*2, textAng, 0.1)  
                        
                draw.SimpleTextOutlined(self.cl_pacmanScore, "PacManDefault", 0 ,0  , color_white, TEXT_ALIGN_CENTER,TEXT_ALIGN_LEFT,6,color_black) 

            cam.End3D2D() 

            local gameOverText = "GAME OVER"
            local gameOverText2 = "Press the arrow keys to restart"

            local gameOverWidth, gameOverHeight = surface.GetTextSize(gameOverText)
            local gameOverWidth2, gameOverHeight2 = surface.GetTextSize(gameOverText2)


            if self.cl_gameOver then

                local GOpos = self:GetPos()
                --GOpos = GOpos + self:GetForward() * 30
                GOpos = GOpos + self:GetUp() * 15
                cam.Start3D2D(GOpos , textAng , 0.04)  
                
                    draw.DrawText(gameOverText, "PacManDefault", -gameOverWidth * 0.5, -gameOverHeight * 0.5, Color(224,0,0), TEXT_ALIGN_LEFT) 
                    draw.DrawText(gameOverText2, "PacManDefault", 0, 80, Color(224,0,0), TEXT_ALIGN_CENTER)

                cam.End3D2D() 
            end

        end)

    end
    

end

function ENT:ResetPositions()

    --maybe will be used later

end


function ENT:TouchGhost(ghostID)

    if not self.ghostsPanic then
        if self.lives > 0 then

            self.lives = self.lives - 1 
            self.lifeProps[1]:Remove()
            table.remove(self.lifeProps, 1)
            --self:ResetPositions()

            self.tick = -100

            for i, v in pairs(self.ghosts) do
                v.ghostGridPos = v.ghostOriginPos
                v.ghostTimer = CurTime()
                v.ghostState = "home"
            end

            self.pacmanGridPos[1] = self.pacmanOriginGridPos[1]
            self.pacmanGridPos[2] = self.pacmanOriginGridPos[2]

        else
            self.gameOver = true
            net.Start("pacmanGameOver")
                net.WriteBool(true)
            net.Broadcast()
        end
    else

        self.tick = -50
        self.ghosts[ghostID].ghostGridPos = self.ghosts[ghostID].ghostOriginPos
        self.ghosts[ghostID].ghostTimer = CurTime()
        self.ghosts[ghostID].ghostState = "home"

    end


end

function ENT:MoveGhost(ghost, target)

    if SERVER then

        print("MOVE REQUEST FROM GHOST".. ghost)
        
        
        local ghostTarget = grid[target[1]][target[2]]
        local ghostGridPos = self.ghosts[ghost].ghostGridPos

        PrintTable(ghostGridPos)

        local directions = {}
        local chosenDirection = nil 


        if ghostGridPos[1] + 1 == 101 then
            table.insert(directions, {0, ghostGridPos[2], "up"})
        else

            if not grid[ghostGridPos[1] + 1][ghostGridPos[2]].wall and ((self.ghosts[ghost].ghostState ~= "home" and not grid[ghostGridPos[1] + 1][ghostGridPos[2]].door) or self.ghosts[ghost].ghostState == "home") then

                if ghostGridPos[3] == nil or (ghostGridPos[3] and ghostGridPos[3] ~= "down") then
                    
                    table.insert(directions, {ghostGridPos[1] + 1, ghostGridPos[2], "up"})

                end
                
            end

        end

        if ghostGridPos[1] - 1 == -1 then
            table.insert(directions, {100, ghostGridPos[2], "down"})
        else

            if not grid[ghostGridPos[1] - 1 ][ghostGridPos[2]].wall and ((self.ghosts[ghost].ghostState ~= "home" and not grid[ghostGridPos[1] - 1][ghostGridPos[2]].door) or self.ghosts[ghost].ghostState == "home") then

                if ghostGridPos[3] == nil or (ghostGridPos[3] and ghostGridPos[3] ~= "up") then

                    table.insert(directions, {ghostGridPos[1] - 1, ghostGridPos[2], "down"})
                    
                end
                
            end

        end

        if ghostGridPos[2] + 1 == 101 then
            table.insert(directions, {ghostGridPos[1], 0, "right"})
        else

            if not grid[ghostGridPos[1]][ghostGridPos[2] + 1].wall then

                if ghostGridPos[3] == nil or (ghostGridPos[3] and ghostGridPos[3] ~= "left") then

                    table.insert(directions, {ghostGridPos[1], ghostGridPos[2] + 1, "right"})
                    
                end
                
            end

        end

        if ghostGridPos[2] - 1 == -1 then
            table.insert(directions, {ghostGridPos[1], 100, "left"})
        else
        
            if not grid[ghostGridPos[1]][ghostGridPos[2] - 1].wall then

                if ghostGridPos[3] == nil or (ghostGridPos[3] and ghostGridPos[3] ~= "right") then
                    
                    table.insert(directions, {ghostGridPos[1], ghostGridPos[2] - 1, "left"})

                end
                
            end

        end


        if #directions > 1 then

            if not self.ghostsPanic then
                
                local shortestDistance = (grid[directions[1][1]][directions[1][2]].pos - ghostTarget.pos):Length2DSqr()
                chosenDirection = directions[1]

                for i = 2, #directions do 

                    if (grid[directions[i][1]][directions[i][2]].pos - ghostTarget.pos):LengthSqr() < shortestDistance then
                        shortestDistance = (grid[directions[i][1]][directions[i][2]].pos - ghostTarget.pos):LengthSqr()
                        chosenDirection = directions[i]
                    end
                end
            else

                chosenDirection = directions[math.random(#directions)]

            end
        -- else

            -- if ghostGridPos[3] and directions[1][3] ~= ghostGridPos[3] then
            --     chosenDirection = directions[2]
            -- else
            --     chosenDirection = directions[1]
            -- end

        end

        if #directions == 1 then
            chosenDirection = directions[1]
        end

        if #directions < 1 then
            ghostGridPos[3] = nil
            chosenDirection = self:MoveGhost(ghost, target)
        end

        print("THIS IS THE CHOSEN DIRECTION:")
        PrintTable(chosenDirection)

        return chosenDirection

        -- if target[1] > ghostGridPos[1] then
        --     ghostMoveDirection = "up"
        -- end

        -- if target[1] < ghostGridPos[1] then
        --     ghostMoveDirection = "down"
        -- end

        -- if target[2] > ghostGridPos[2] then
        --     ghostMoveDirection = "right"
        -- end

        -- if target[2] < ghostGridPos[2] then
        --     ghostMoveDirection = "left"
        -- end

        
        -- if ghostMoveDirection == "up" then
        --     if ghostGridPos[1] < 100 and not grid[ghostGridPos[1] + 1][ghostGridPos[2]].wall then
        --         ghostGridPos[1] = ghostGridPos[1] + 1
        --     end
        -- end
        -- if ghostMoveDirection == "left" then
        --     if ghostGridPos[2] > 0 and not grid[ghostGridPos[1]][ghostGridPos[2] - 1].wall then
        --         ghostGridPos[2] = ghostGridPos[2] - 1
        --     end
        -- end
        -- if ghostMoveDirection == "down" then
        --     if ghostGridPos[1] > 0 and not grid[ghostGridPos[1] - 1][ghostGridPos[2]].wall then
        --         ghostGridPos[1] = ghostGridPos[1] - 1
        --     end
        -- end
        -- if ghostMoveDirection == "right" then
        --     if ghostGridPos[2] < 100 and not grid[ghostGridPos[1]][ghostGridPos[2] + 1].wall then
        --         ghostGridPos[2] = ghostGridPos[2] + 1
        --     end
        -- end

        -- print("THIS IS NEW POS")
        -- PrintTable(ghostGridPos)

        -- return ghostGridPos

        
    end

end

function ENT:GhostTargetSelect(ghostID, chaseTarget)

    local ghost = self.ghosts[ghostID]
    local ghostTimer = ghost.ghostTimer
    local ghostHomeDelay = ghost.ghostHomeDelay
    local ghostState = ghost.ghostState
    local scatterTarget = ghost.ghostScatterPoint
    if CurTime() - ghostTimer > 30 and ghostState ~= "scatter" then
        self.ghosts[ghostID].ghostState = "scatter"
        self.ghosts[ghostID].ghostTimer = CurTime()
        self.ghosts[ghostID].ghostGridPos[3] = nil
        
    else
        ghostTarget = chaseTarget
    end

    if ghostState == "scatter" then
        ghostTarget = scatterTarget
        if CurTime() - ghostTimer > 10 then
            self.ghosts[ghostID].ghostTimer = CurTime()
            self.ghosts[ghostID].ghostState = "chase"
            self.ghosts[ghostID].ghostGridPos[3] = nil
        end
    end

    if ghostState == "chase" then
        ghostTarget = chaseTarget
    end

    if ghostState == "panic" then
        ghostTarget = chaseTarget
    end

    if ghostState == "home" then
        if CurTime() - ghostTimer > ghostHomeDelay then
            ghostTarget = {58,50}
        else
            ghostTarget = {45,50}
        end
        
    end

    return ghostTarget
end

function ENT:GhostThink()

    if self.gameStateStarted and not self.gameOver and not self.gamePaused and self.tick >= 6 then

        if SERVER then

            for ghost = 1 , #self.ghosts do 

                if self.ghosts[ghost].ghostGridPos then

                    self.ghosts[ghost].ghostHitBox = {}

                    for i = -2, 2 do 

                        for j = -2, 2 do 

                            table.insert(self.ghosts[ghost].ghostHitBox, {self.ghosts[ghost].ghostGridPos[1] + i , self.ghosts[ghost].ghostGridPos[2] + j})

                        end

                    end

                end

            end

            for ghost = 1, #self.ghosts do 

                if grid[self.ghosts[ghost].ghostGridPos[1]][self.ghosts[ghost].ghostGridPos[2]].door then
                    self.ghosts[ghost].insideDoor = true
                end

                if self.ghosts[ghost].insideDoor == true and not grid[self.ghosts[ghost].ghostGridPos[1]][self.ghosts[ghost].ghostGridPos[2]].door then
                    self.ghosts[ghost].insideDoor = false
                    --self.tick = -100
                    self.ghosts[ghost].ghostState = "scatter"
                    self.ghosts[ghost].ghostTimer = CurTime()
                end

                for i, v in pairs(self.ghosts[ghost].ghostHitBox) do 

                    if v[1] == self.pacmanGridPos[1] and v[2] == self.pacmanGridPos[2] then
                        
                        print("COLIDED=====================================================================")
                        self:TouchGhost(ghost)

                        return
        
                    end
        
                end

            end

            if self.ghostsPanic then

                for i, v in pairs(self.ghosts) do 
                    v.ghost:SetColor(Color(0,0,255))
                end

                if CurTime() - self.ghostsPanicTimer > 10 then
                    self.ghostsPanic = false 
                    for i, v in pairs(self.ghosts) do 
                        v.ghost:SetColor(v.ghostColor)
                    end
                end

            end

            -- ============= GHOST 1 =========================
            local ghost1target = self:GhostTargetSelect(1, self.pacmanGridPos)

            print("THIS IS GHOST 1 TARGET")
            PrintTable(ghost1target)
            self.ghosts[1].ghostGridPos = self:MoveGhost(1, ghost1target)
            
            if self.ghosts[1].ghostGridPos then
                print("THIS IS FINAL" )
                PrintTable(self.ghosts[1].ghostGridPos)

                self.ghosts[1].ghost:SetPos(self:LocalToWorld(grid[self.ghosts[1].ghostGridPos[1]][self.ghosts[1].ghostGridPos[2]].pos))
                self.ghosts[1].ghostTargetBall:SetPos(self:LocalToWorld(grid[ghost1target[1]][ghost1target[2]].pos))
            end
            -- ============= GHOST 1 ========================= 
            
            -- ============= GHOST 2 =========================
            local ghost2ChaseTarget = {}

            if self.pMoveDirection == "up" then
                if grid[self.pacmanGridPos[1] + 16] then
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1] + 16 
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2]
                else
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1]
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == "down" then
                if grid[self.pacmanGridPos[1] - 16] then
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1] - 16 
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2]
                else
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1]
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == "right" then
                if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] + 16] then
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1] 
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2] + 16
                else
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1]
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == "left" then
                if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] - 16] then
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1] 
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2] - 16
                else
                    ghost2ChaseTarget[1] = self.pacmanGridPos[1]
                    ghost2ChaseTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == nil then
                ghost2ChaseTarget[1] = self.pacmanGridPos[1] 
                ghost2ChaseTarget[2] = self.pacmanGridPos[2] + 8
            end
        
            local ghost2Target = self:GhostTargetSelect(2 , ghost2ChaseTarget)
            self.ghosts[2].ghostGridPos = self:MoveGhost(2, ghost2Target)
            
            if self.ghosts[2].ghostGridPos then
                print("THIS IS FINAL 2" )
                PrintTable(self.ghosts[2].ghostGridPos)

                self.ghosts[2].ghost:SetPos(self:LocalToWorld(grid[self.ghosts[2].ghostGridPos[1]][self.ghosts[2].ghostGridPos[2]].pos))
                self.ghosts[2].ghostTargetBall:SetPos(self:LocalToWorld(grid[ghost2Target[1]][ghost2Target[2]].pos))
            end

            -- ============= GHOST 2 =========================

            -- ============= GHOST 3 =========================

            local ghost3ForwardTarget = {}

            if self.pMoveDirection == "up" then
                if grid[self.pacmanGridPos[1] + 8] then
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1] + 8 
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2]
                else
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1]
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == "down" then
                if grid[self.pacmanGridPos[1] - 8] then
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1] - 8 
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2]
                else
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1]
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == "right" then
                if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] + 8] then
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1] 
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2] + 8
                else
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1]
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == "left" then
                if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] - 8] then
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1] 
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2] - 8
                else
                    ghost3ForwardTarget[1] = self.pacmanGridPos[1]
                    ghost3ForwardTarget[2] = self.pacmanGridPos[2]
                end
            end
            if self.pMoveDirection == nil then
                ghost3ForwardTarget[1] = self.pacmanGridPos[1] 
                ghost3ForwardTarget[2] = self.pacmanGridPos[2] + 8
            end

            local ghost3DistanceOfPoints = {}

            ghost3DistanceOfPoints[1] = math.abs(self.ghosts[1].ghostGridPos[1] - ghost3ForwardTarget[1])
            ghost3DistanceOfPoints[2] = math.abs(self.ghosts[1].ghostGridPos[2] - ghost3ForwardTarget[2])

            local ghost3ChaseTarget = {}
            
            if self.ghosts[1].ghostGridPos[1] > ghost3ForwardTarget[1] then
                ghost3ChaseTarget[1] = ghost3ForwardTarget[1] - ghost3DistanceOfPoints[1]
            else
                ghost3ChaseTarget[1] = ghost3ForwardTarget[1] + ghost3DistanceOfPoints[1]
            end

            if self.ghosts[1].ghostGridPos[2] > ghost3ForwardTarget[2] then
                ghost3ChaseTarget[2] = ghost3ForwardTarget[2] - ghost3DistanceOfPoints[2]
            else
                ghost3ChaseTarget[2] = ghost3ForwardTarget[2] + ghost3DistanceOfPoints[2]
            end


            local ghost3Target = self:GhostTargetSelect(3 , ghost3ChaseTarget)
            if not grid[ghost3Target[1]] then
                ghost3Target = ghost1target
                goto skip
            end
            if not grid[ghost3Target[1]][ghost3Target[2]] then
                ghost3Target = ghost1target
                
            end

            ::skip::            

            self.ghosts[3].ghostGridPos = self:MoveGhost(3, ghost3Target)
            
            if self.ghosts[3].ghostGridPos then
                print("THIS IS FINAL 3" )
                PrintTable(self.ghosts[3].ghostGridPos)

                self.ghosts[3].ghost:SetPos(self:LocalToWorld(grid[self.ghosts[3].ghostGridPos[1]][self.ghosts[3].ghostGridPos[2]].pos))
                self.ghosts[3].ghostTargetBall:SetPos(self:LocalToWorld(grid[ghost3Target[1]][ghost3Target[2]].pos))
            end

            -- ============= GHOST 3 =========================

            -- ============= GHOST 4 =========================

            local ghost4ChaseTarget

            if math.abs(self.ghosts[4].ghostGridPos[1] - self.pacmanGridPos[1]) > 20 and math.abs(self.ghosts[4].ghostGridPos[2] - self.pacmanGridPos[2]) > 20 then
                print("GHOST 4 FOLLOW PACMAN!!!!")
                ghost4ChaseTarget = self.pacmanGridPos
            else
                ghost4ChaseTarget = self.ghosts[4].ghostScatterPoint
            end

            local ghost4Target = self:GhostTargetSelect(4 , ghost4ChaseTarget)

            self.ghosts[4].ghostGridPos = self:MoveGhost(4, ghost4Target)
            
            if self.ghosts[4].ghostGridPos then
                print("THIS IS FINAL 4" )
                PrintTable(self.ghosts[4].ghostGridPos)

                self.ghosts[4].ghost:SetPos(self:LocalToWorld(grid[self.ghosts[4].ghostGridPos[1]][self.ghosts[4].ghostGridPos[2]].pos))
                self.ghosts[4].ghostTargetBall:SetPos(self:LocalToWorld(grid[ghost4Target[1]][ghost4Target[2]].pos))
            end

        end

    end

end


function ENT:MovePacMan()

    if SERVER then

        if self.gameStateStarted and not self.gameOver  and not self.gamePaused and self.tick >= 6 then

            if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].dot then
                self.pacman:ResetSequence(1)
                self.pacman:SetPlaybackRate(3)

                if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].obj:IsValid() then
                    grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].obj:Remove()
                end
                grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].dot = false 

                self.pacmanScore = self.pacmanScore + 10 
                net.Start("pacmanScore")
                    net.WriteInt(self.pacmanScore, 14)
                net.Broadcast()
            elseif self.pacman:IsSequenceFinished() then
                self.pacman:ResetSequence(2)
            end


            if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].energizer then
                if grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].obj:IsValid() then
                    grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].obj:Remove()
                end
                grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].energizer = false 
                self.ghostsPanic = true
                self.ghostsPanicTimer = CurTime()
                self.pacmanScore = self.pacmanScore + 50 
                net.Start("pacmanScore")
                    net.WriteInt(self.pacmanScore, 14)
                net.Broadcast()
            end

            if self.pMoveDirection then

                self.pacman:SetPos(self:LocalToWorld(grid[self.pacmanGridPos[1]][self.pacmanGridPos[2]].pos))

            end

            if self.pNextMoveDirection ==  "up" then
                if self.pacmanGridPos[1] + 1 == 101 then
                    self.pacmanGridPos[1] = 0
                end
                if not grid[self.pacmanGridPos[1] + 1][self.pacmanGridPos[2]].wall then
                    self.pMoveDirection = "up"
                end

            end
            if self.pNextMoveDirection == "left" then
                if self.pacmanGridPos[2] - 1 == -1 then
                    self.pacmanGridPos[2] = 100
                end
                if not grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] - 1].wall then
                    self.pMoveDirection = "left"
                end
            end
            if self.pNextMoveDirection == "down" then
                if self.pacmanGridPos[1] - 1 == -1 then
                    self.pacmanGridPos[1] = 100
                end
                if not grid[self.pacmanGridPos[1] - 1][self.pacmanGridPos[2]].wall then
                    self.pMoveDirection = "down"
                end
            end
            if self.pNextMoveDirection == "right" then
                if self.pacmanGridPos[2] + 1 == 101 then
                    self.pacmanGridPos[2] = 0
                end
                if not grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] + 1].wall then
                    self.pMoveDirection = "right"
                end
            end

            local ang = self:GetAngles()

            if self.pMoveDirection == "up" then
                --self.pacmanPhys:SetVelocity(-self:GetForward()*10)
                if not grid[self.pacmanGridPos[1] + 1][self.pacmanGridPos[2]].wall then
                    self.pacmanGridPos[1] = self.pacmanGridPos[1] + 1
                    
                    ang:RotateAroundAxis(self:GetAngles():Up(),90)
                    self.pacman:SetAngles(ang)
                    --self.pacman:angles RotateAroundAxis(Vector(0,0,1),90)
                end
                --self.pacman:SetPos(self:LocalToWorld(gridHeight[self.pacmanY]))
            end
            if self.pMoveDirection == "left" then
                --self.pacman:SetPos(self.pacman:GetPos() + self:GetRight()/3)
                if not grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] - 1].wall then
                    self.pacmanGridPos[2] = self.pacmanGridPos[2] - 1

                    ang:RotateAroundAxis(self:GetAngles():Up(),180)
                    self.pacman:SetAngles(ang)
                end
            end
            if self.pMoveDirection == "down" then
                -- if self.pacmanY > 0 then
                --     self.pacmanY = self.pacmanY - 1
                -- end
                if not grid[self.pacmanGridPos[1] - 1][self.pacmanGridPos[2]].wall then
                    self.pacmanGridPos[1] = self.pacmanGridPos[1] - 1

                    ang:RotateAroundAxis(self:GetAngles():Up(),270)
                    self.pacman:SetAngles(ang)
                end
            end
            if self.pMoveDirection == "right" then
                --self.pacman:SetPos(self.pacman:GetPos() - self:GetRight()/3)
                if not grid[self.pacmanGridPos[1]][self.pacmanGridPos[2] + 1].wall then
                    self.pacmanGridPos[2] = self.pacmanGridPos[2] + 1

                    ang:RotateAroundAxis(self:GetAngles():Up(),360)
                    self.pacman:SetAngles(ang)
                end
            end

            self.tick = 1

            return

        end

        self.tick = self.tick + 1

    end

end

function ENT:RestartGame()

    if self.gameOver then

        self.gameStateStarted = false

        grid = {}
        self.grid = false

        self.lives = 1
        

        self.pMoveDirection = nil
        self.pNextMoveDirection = nil

        self.pacmanGridPos[1] = self.pacmanOriginGridPos[1]
        self.pacmanGridPos[2] = self.pacmanOriginGridPos[2]

        net.Start("pacmanGameOver")
            net.WriteBool(false)
        net.Broadcast()
        
        for i, v in pairs(self.ghosts) do
            v.ghostGridPos = v.ghostOriginPos
            v.ghostTimer = CurTime()
            v.ghostState = "home"
        end

        for i = 1, self.lives do 
            local pacmanLives = ents.Create("prop_physics")
            pacmanLives:SetModel("models/smok/pacman/pacman.mdl")
            pacmanLives:SetColor(Color(255,255,0))
            pacmanLives:SetPos(self:GetPos() + self:GetRight()*80 + self:GetRight()*i*10 - self:GetForward()*40)
            pacmanLives:SetModelScale(3.5)
            pacmanLives:DrawShadow(false )
            pacmanLives:SetAngles(self:GetAngles())
            table.insert(self.lifeProps, pacmanLives)
        end

        --self.gamePaused = false 
        self.gameOver = false 

    end

end


function ENT:keyPress(ply, key)

    print(key)
    if key == 88 then
        self:RestartGame()
        self.pNextMoveDirection = "up"
        self.gamePaused = false
        
    end

    if key == 89 then
        self:RestartGame()
        self.pNextMoveDirection = "left"
        self.gamePaused = false
        
    end

    if key == 90 then
        self:RestartGame()
        self.pNextMoveDirection = "down"
        self.gamePaused = false
        
    end

    if key == 91 then
        self:RestartGame()
        self.pNextMoveDirection = "right"
        self.gamePaused = false
        
    end

end

function UnbindInputs(ply, bind)
    if bind == "+left" or bind == "+right" then
        return true 
    end
end

function ENT:OnRemove() 

    hook.Remove("PlayerBindPress", "PacManUnbindInputs")
    hook.Remove("PlayerButtonDown", "PacManKeyPress")
    hook.Remove("Tick", "PacManMove")
    hook.Remove("PostDrawOpaqueRenderables", "drawPacManText")

end