AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Tetris"
ENT.Category = "Tetris"
ENT.Author = "SMOK"
ENT.Spawnable = true
ENT.AdminSpawnable = true

local pieceTypes = {
    [1] = {
        color = Color(255,255,51),
        num = 4,
        spawnPos = {
            205,
            206,
            195,
            196
        },
        rotations = {
            [1] = {
                [1] = 10,
                [2] = 11,
                [3] = 0,
                [4] = 1
            },
            [2] = {
                [1] = 10,
                [2] = 11,
                [3] = 0,
                [4] = 1
            },
            [3] = {
                [1] = 10,
                [2] = 11,
                [3] = 0,
                [4] = 1
            },
            [4] = {
                [1] = 10,
                [2] = 11,
                [3] = 0,
                [4] = 1
            }
        }
    },
    [2] = {
        color = Color(55,245,255),
        num = 4,
        spawnPos = {
            205,
            195,
            185,
            175
        },
        rotations = {
            [1] = {
                [1] = 2,
                [2] = 1,
                [3] = 0,
                [4] = - 1
            },
            [2] = {
                [1] = 20,
                [2] = 10,
                [3] = 0,
                [4] = - 10
            },
            [3] = {
                [1] = 2,
                [2] = 1,
                [3] = 0,
                [4] = - 1
            },
            [4] = {
                [1] = 20,
                [2] = 10,
                [3] = 0,
                [4] = - 10
            }
        }
    },
    [3] = {
        color = Color(185,63,255),
        num = 4,
        spawnPos = {
            205,
            194,
            195,
            196
        },
        rotations = {
            [1] = {
                [1] = 1,
                [2] = 10,
                [3] = 0,
                [4] = -10
            },
            [2] = {
                [1] = -10,
                [2] = 1,
                [3] = 0,
                [4] = -1
            },
            [3] = {
                [1] = -1,
                [2] = -10,
                [3] = 0,
                [4] = 10
            },
            [4] = {
                [1] = 10,
                [2] = -1,
                [3] = 0,
                [4] = 1
            }
        }
    },
    [4] = {
        color = Color(66,69,255),
        num = 4,
        spawnPos = {
            184,
            185,
            195,
            205
        },
        rotations = {
            [1] = {
                [1] = 9,
                [2] = -1,
                [3] = 0,
                [4] = 1
            },
            [2] = {
                [1] = 11,
                [2] = 10,
                [3] = 0,
                [4] = -10
            },
            [3] = {
                [1] = -9,
                [2] = 1,
                [3] = 0,
                [4] = -1
            },
            [4] = {
                [1] = -11,
                [2] = -10,
                [3] = 0,
                [4] = 10
            }
        }
    },
    [5] = {
        color = Color(255,178,69),
        num = 4,
        spawnPos = {
            186,
            185,
            195,
            205
        },
        rotations = {
            [1] = {
                [1] = -11,
                [2] = -1,
                [3] = 0,
                [4] = 1
            },
            [2] = {
                [1] = 9,
                [2] = 10,
                [3] = 0,
                [4] = -10
            },
            [3] = {
                [1] = 11,
                [2] = 1,
                [3] = 0,
                [4] = -1
            },
            [4] = {
                [1] = -9,
                [2] = -10,
                [3] = 0,
                [4] = 10
            }
        }
    },
    [6] = {
        color = Color(255,64,64),
        num = 4,
        spawnPos = {
            204,
            205,
            195,
            196
        },
        rotations = {
            [1] = {
                [1] = 11,
                [2] = 1,
                [3] = 0,
                [4] = -10
            },
            [2] = {
                [1] = 9,
                [2] = 10,
                [3] = 0,
                [4] = 1
            },
            [3] = {
                [1] = 11,
                [2] = 1,
                [3] = 0,
                [4] = -10
            },
            [4] = {
                [1] = 9,
                [2] = 10,
                [3] = 0,
                [4] = 1
            }
        }
    },
    [7] = {
        color = Color(82,255,63),
        num = 4,
        spawnPos = {
            206,
            205,
            195,
            194
        },
        rotations = {
            [1] = {
                [1] = 1,
                [2] = -9,
                [3] = 0,
                [4] = 10
            },
            [2] = {
                [1] = 11,
                [2] = 10,
                [3] = 0,
                [4] = -1
            },
            [3] = {
                [1] = 1,
                [2] = -9,
                [3] = 0,
                [4] = 10
            },
            [4] = {
                [1] = 11,
                [2] = 10,
                [3] = 0,
                [4] = -1
            }
        }
    }

}

local white = Color(255,255,255)

CreateConVar("tetris_music_enable", 0, FCVAR_ARCHIVE)
CreateConVar("tetris_game_speed", 2, FCVAR_ARCHIVE, "test", 1, 8)

if CLIENT then

    -- this is not needed for some reason ??

    -- hook.Add( "AddToolMenuCategories", "CustomCategory", function()
    --     spawnmenu.AddToolCategory( "Utilities", "tetris", "##Tetris" )
    -- end )

    hook.Add( "PopulateToolMenu", "CustomMenuSettings", function()
        spawnmenu.AddToolMenuOption( "Utilities", "Tetris", "Custom_Menu", "Tetris Options", "", "", function( panel )
            panel:CheckBox("Music", "tetris_music_enable")
            panel:NumSlider( "Game Speed", "tetris_game_speed", 1, 8 )
        end )
    end )

end

function ENT:Initialize()

    if SERVER then

        self.bordersSpawned = false
        self.grid = false

        self.activePiece = false
        self.dwonButton = false

        self.nextPiece = nil 
        self.pieceTimer = 0
        self.speed = 1
        self.pause = false 

        self.linesRemoved = 0
        self.startLine = 0

        self.score = 0
        self.gameOver = false 

        self:SetModel("models/hunter/blocks/cube05x5x025.mdl")
        self:SetColor(Color(0,161,255))
        self:SetSolid(SOLID_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
       
        
        local phys = self:GetPhysicsObject()
        
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(1)
            phys:EnableDrag(false)
            phys:EnableGravity(false)
            phys:EnableMotion(false)
            
        end

        

        


        util.AddNetworkString("TetrisScore")
        util.AddNetworkString("GameOver")
        
    end

    hook.Add("PlayerBindPress", "UnbindInputs", UnbindInputs)


    hook.Add("PlayerButtonDown", "MovePiece", function(ply, key)
        self:MovePiece(ply, key)
    end)
    hook.Add("PlayerButtonUp", "SlowPiece", function(ply, key)
        self:SlowPiece(ply, key)
    end)


    if CLIENT then

        self.cl_tetrisScore = 0 
        self.cl_displace = 80
        self.cl_displaceTime = CurTime()
        self.cl_sampleTime = 0
        self.cl_slowThink = 0
        self.cl_color = Color(255,255,255,255)

        local soundChannel = CreateSound(self, "tetris/music1.mp3")
        --soundChannel:PlayEx(1, 100)
        --soundChannel:SetSoundLevel(0)
        
        
        self.cl_SoundChannel = soundChannel
        self.cl_soundTimer = 0
       --[[  self.cl_SoundChannel = nil

        local g_station = nil
        sound.PlayURL ( "X", "3d", function( station , errNum, errStr)
            if ( IsValid( station ) ) then

                station:SetPos( LocalPlayer():GetPos() )
            
                station:Play()

                -- Keep a reference to the audio object, so it doesn't get garbage collected which will stop the sound
                self.cl_SoundChannel = station
            
            else

                LocalPlayer():ChatPrint( "Invalid URL!" )
                LocalPlayer():ChatPrint( errNum )
                LocalPlayer():ChatPrint( errStr )

            end
        end ) ]]

--[[         local soundChannel = nil

        

        sound.PlayFile("tetris/music1.wav","3d",function( station, errCode, errStr )
            
            station:EnableLooping(true)
            station:Play()
        
        end)

        local function PlayLoopingMusic()
            -- Play the music using sound.PlayURL
            
           
        end

        if not IsValid(soundChannel) or not soundChannel:IsPlaying() then
            PlayLoopingMusic()
        end ]]

        surface.CreateFont( "TheDefaultSettings", {
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

        surface.CreateFont( "smallerDefault", {
            font = "Arial", 
            extended = false,
            size = 60,
            weight = 500,
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

end



function ENT:Think()


    local ang = self:GetAngles()
    ang.pitch = 0
    ang.roll = 0
    self:SetAngles(ang)


    local mins = self:OBBMins()
    local maxs = self:OBBMaxs()

    local blockSpwan = self:GetPos() + Vector(0,0,127.3) -- dumb

    local positions = {
        leftDown = Vector(maxs.x, mins.y, mins.z + 20),
        leftUp = Vector(mins.x, mins.y, mins.z + 20),
        rightDown = Vector(mins.x, maxs.y, mins.z + 20),
        rightUp = Vector(maxs.x, maxs.y, mins.z + 20),

    }

    local gridLimits = {
        leftMidDown = (positions.leftUp + positions.leftDown)/2 + (positions.rightUp + positions.rightDown)/2 * 0.1,
        rightMidDown = (positions.rightUp + positions.rightDown)/2,
        leftMidUp = (positions.leftUp + positions.leftDown)/2 + Vector(0,0,127.3),
        rightMidUp = (positions.rightUp + positions.rightDown)/2 + Vector(0,0,127.3)
    }

    


    if not self.grid then 

        gridPosH = {}
        gridPosW = {}

        for i = 0, 20 do
            
            table.insert(gridPosH, i, Vector(gridLimits.leftMidDown.x, gridLimits.leftMidDown.y, 0) + Vector(0,0,240 ) * i * 0.1 + Vector(0,0,18))
            
        end

        for index, value in pairs(gridPosH) do 


            for i = 0, 9 do

                table.insert(gridPosW, {pos = Vector(gridLimits.leftMidDown.x, gridLimits.leftMidDown.y, 0) + Vector(gridLimits.rightMidDown.x, gridLimits.rightMidDown.y, 0) * i * 0.2 + Vector(0,0,value.z) , occupied = false, line = index}   )

            end

        end

        self.grid = true

    end

    if SERVER then


        for start = 1, #gridPosW, 10 do
            local endValue = start + 9 
            
            local line = true
            for i = start, endValue do

                if not gridPosW[i].occupied then
                    line = false 
                    break
                end

            end

            if line then
                
                self:EmitSound("tetris/line.wav", 100,100,100)

                for i = start, endValue do

                    if gridPosW[i].ent and IsValid(gridPosW[i].ent) then

                        gridPosW[i].ent:SetColor(Color(255,255,255))
                        gridPosW[i].ent:SetRenderFX(10)
                        gridPosW[i].occupied = false 

                    end
                    
                end

                timer.Simple(0.5, function()

                    for i = start, endValue do

                        if gridPosW[i].ent and IsValid(gridPosW[i].ent) then
                            
                            gridPosW[i].ent:Remove()

                        end
                        
                    end
                    self.linesRemoved = self.linesRemoved + 1
                    self.startLine = start

                end)

                self.score = self.score + 10

                net.Start("TetrisScore")
                    net.WriteInt(self.score, 14)
                net.Broadcast()
                
            end
        end

        if self.linesRemoved > 0 then
            for i = self.startLine, #gridPosW do
                local targetIndex = (i - 10 * self.linesRemoved) 
                if IsValid(gridPosW[i].ent) and gridPosW[i].occupied then
                    gridPosW[targetIndex].ent = gridPosW[i].ent
                    gridPosW[targetIndex].ent:SetPos(self:LocalToWorld(gridPosW[targetIndex].pos))
                    gridPosW[targetIndex].occupied = true 
                    gridPosW[i].occupied = false
                    gridPosW[i].ent = nil
                end
            end
            self.linesRemoved = 0 
            self.startLine = 0
        end


        if not self.pieces and not self.gameOver then


            if not self.nextPiece then
                self.pieceType = pieceTypes[math.random(1,7)]
                self.nextPiece = pieceTypes[math.random(1,7)]
            else
                self.pieceType = self.nextPiece
                self.nextPiece = pieceTypes[math.random(1,7)]
            end
            
            self.pieces = {}
            self.nextPieces = {}
            self.pieceRotation = 0

            

            for i = 1, self.pieceType.num do
                if gridPosW[self.pieceType.spawnPos[i]].occupied then 
                    self.pieces = nil
                    self.gameOver = true
                    net.Start("GameOver")
                        net.WriteBool(true)
                    net.Broadcast()
                    return
                end
            end

            for i = 1, self.pieceType.num do

                local piece = ents.Create("prop_physics")
                piece:SetModel("models/hunter/blocks/cube05x05x05.mdl")
                piece:SetColor(self.pieceType.color)
                piece:Spawn()
                piece:SetPos(self:LocalToWorld(gridPosW[self.pieceType.spawnPos[i]].pos))
                piece:SetAngles(self:GetAngles())
                piece.active = true
                local piecePhys = piece:GetPhysicsObject()
                piecePhys:EnableGravity(false)
                piecePhys:EnableDrag(false)
                piecePhys:EnableMotion(false)
                table.insert(self.pieces , piece)
                self.activePiece = true
                piece.gridPos = self.pieceType.spawnPos[i]
            end

            for i = 1, self.nextPiece.num do

                local piece = ents.Create("prop_physics")
                piece:SetModel("models/hunter/blocks/cube05x05x05.mdl")
                piece:SetColor(self.nextPiece.color)
                piece:SetMaterial("models/wireframe")
                piece:Spawn()
                piece:SetPos(self:LocalToWorld(gridPosW[self.nextPiece.spawnPos[i]].pos) + self:GetRight()*210 + Vector(0,0,-300))
                piece:SetAngles(self:GetAngles())
                -- piece.active = true
                local piecePhys = piece:GetPhysicsObject()
                piecePhys:EnableGravity(false)
                piecePhys:EnableDrag(false)
                piecePhys:EnableMotion(false)
                table.insert(self.nextPieces , piece)
                -- table.insert(self.pieces , piece)
                -- self.activePiece = true
                -- piece.gridPos = self.pieceType.spawnPos[i]
            end
            
        end

        if self.downButton then 
            self.speed = 0.01 / GetConVar("tetris_game_speed"):GetFloat() * 20
        else
            self.speed = 1 / GetConVar("tetris_game_speed"):GetFloat()
        end

        if CurTime() - self.pieceTimer > self.speed and self.pieces and not self.pause then

            for k,v in pairs(self.pieces) do 
                
                local nextPosDown = v.gridPos - 10
                if not gridPosW[nextPosDown] or gridPosW[nextPosDown].occupied  then 
                    for k2 ,v2 in pairs(self.pieces) do
                        v2.ok = false 
                        v2:EmitSound("tetris/block_hit.wav", 66,100,100)
                    end
                    break
                else
                    v.ok = true
                end
                
            end

            for k,v in pairs(self.pieces) do 
                
                if not v.ok then 

                    if gridPosW[v.gridPos - 10] == nil  or  gridPosW[v.gridPos - 10].occupied then
                        local effectData = EffectData()
                        effectData:SetOrigin(v:GetPos() + Vector(0,0,-12.5)) 
                        effectData:SetNormal(Vector(0, 0, 1)) 
                        effectData:SetScale(1) 
                        util.Effect("cball_bounce", effectData)
                    end

                    gridPosW[v.gridPos].occupied = true 
                    gridPosW[v.gridPos].ent = v
                    v.active = false
                    self.activePiece = false
                    self.pieces = nil

                    if self.nextPieces then
                        for k, v in pairs(self.nextPieces) do
                            v:Remove()
                        end
                    end
                    self.nextPieces = nil 
                    
                    if gridPosW[205].occupied or gridPosW[206].occupied then

                        self.gameOver = true 
                        net.Start("GameOver")
                            net.WriteBool(true)
                        net.Broadcast()
                        
                    end

                else

                    v.gridPos = v.gridPos - 10
                    v:SetPos(self:LocalToWorld(gridPosW[v.gridPos].pos))

                end
                
            end
            
            self.pieceTimer = CurTime()
        end

        for k,v in pairs(positions) do 


            if not self[k.."Border"] then
                self[k.."Border"] = ents.Create("prop_physics")
                self[k.."Border"]:SetModel("models/hunter/blocks/cube025x025x025.mdl")
                self[k.."Border"]:SetRenderMode(RENDERMODE_NONE)
                self[k.."Border"]:SetCollisionGroup(COLLISION_GROUP_WORLD)
                self[k.."Border"]:Spawn()
                self[k.."BorderPhys"] = self[k.."Border"]:GetPhysicsObject()
                self[k.."BorderPhys"]:EnableGravity(false)
                self[k.."BorderPhys"]:SetVelocity(Vector(0,0,500))
                self[k.."Border"]:SetPos(self:LocalToWorld(v))
                local test = constraint.Elastic(self, self[k.."Border"], 0, 0, v + Vector(0,0,-7), Vector(0,0,0) ,  0, 0, 0,  "cable/redlaser",20, true)
                
    
            end

            local dist = (self:LocalToWorld(v) - self[k.."Border"]:GetPos()):GetNormalized() * 200
            local distX = dist.x
            local distY = dist.y
            if distX > 0.1 or distY > 0.01 then

                self[k.."BorderPhys"]:SetVelocity(Vector(distX,distY,self[k.."BorderPhys"]:GetVelocity().z))

            end

        end
        
        

    end
    
  

    if CLIENT then

        if GetConVar("tetris_music_enable"):GetBool() and (CurTime() - self.cl_soundTimer > 292 or self.cl_soundTimer == 0) then
            self.cl_SoundChannel:Stop()
            self.cl_SoundChannel:Play()
            self.cl_soundTimer = CurTime()
        end 

        if GetConVar("tetris_music_enable"):GetBool() == false then
            self.cl_SoundChannel:Stop()
            self.cl_soundTimer = 0
        end

        if self.cl_displace > 0.5 and CurTime() - self.cl_displaceTime < 5 then
            self.cl_displace = self.cl_displace - (self.cl_displace*2^(-(CurTime() - self.cl_displaceTime)))/12 -- i dont know math, sorry
            self.cl_sampleTime = CurTime() + 0.015
            
        elseif self.cl_displace < 0.5 or CurTime() - self.cl_displaceTime > 5 then
            self.cl_displace = 0
        end

        

        hook.Add("PostDrawOpaqueRenderables", "DrawEntityText", function()
            local entity = self 
            
            if IsValid(entity) then

            

                if self.cl_displace > 60 then
                    self.cl_tetris_4 = true 
                end

                if self.cl_tetris_4 and self.cl_displace > 0 then
                    if CurTime() - self.cl_slowThink > 0 then
                        self.cl_color = ColorRand()
                        self.cl_slowThink = CurTime() + 0.1
                    end 
                else
                    self.cl_tetris_4 = false 
                    self.cl_color = color_white
                end 

                net.Receive("TetrisScore", function()
                    local netScore = net.ReadInt(14)
                    self.cl_tetrisScore = netScore
                    self.cl_displace = self.cl_displace + 20
                    self.cl_displaceTime = CurTime()
                end)

                net.Receive("GameOver", function()
                    local status = net.ReadBool()
                    self.cl_gameOver = status
                end)

                local color = self.cl_color
                local pos = entity:GetPos()
                pos = pos + entity:GetRight() * 220 
                pos = pos + entity:GetUp() * 40 + entity:GetUp() * self.cl_displace

                local angle = self:GetAngles()
                angle:RotateAroundAxis( angle:Up(), -270 )
                angle:RotateAroundAxis( angle:Forward(), 90 )



                
                local text = "SCORE : "..self.cl_tetrisScore 
                surface.SetFont( "TheDefaultSettings" )
                local textWidth, textHeight = surface.GetTextSize(text)
                
                cam.Start3D2D(pos, angle , 0.1)  
                    
                    draw.SimpleTextOutlined(text, "TheDefaultSettings", -textWidth * 0.5, -textHeight * 0.5, color, TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,4,color_black) 

                cam.End3D2D() 

                local nextTextPos = entity:GetPos()
                nextTextPos = nextTextPos + entity:GetRight() * 220 
                nextTextPos = nextTextPos + entity:GetUp() * 240 + entity:GetUp() 

                local nextText = "NEXT"
                surface.SetFont( "DermaLarge" )
                local NextTextWidth, NextTextHeight = surface.GetTextSize(nextText)
                
                cam.Start3D2D(nextTextPos, angle , 0.06)  
                    
                    draw.SimpleTextOutlined(nextText, "TheDefaultSettings", -NextTextWidth * 0.5, -NextTextHeight * 0.5, color_white, TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT,3,color_black) 

                cam.End3D2D() 

                local gameOverText = "GAME OVER"
                local gameOverText2 = "Press the left/right arrow keys to restart"

                local GOtextWidth, GOtextHeight = surface.GetTextSize(gameOverText)
                local GOtextWidth2, GOtextHeight2 = surface.GetTextSize(gameOverText2)

                if self.cl_gameOver then

                    local GOpos = entity:GetPos()
                    GOpos = GOpos + entity:GetForward() * 30 
                    GOpos = GOpos + entity:GetUp() * 40
                    cam.Start3D2D(entity:GetPos() + Vector(0,0,100) + entity:GetForward() * 30 , angle , 0.2)  
                    
                        draw.DrawText(gameOverText, "TheDefaultSettings", -GOtextWidth * 0.5, -GOtextHeight * 0.5, Color(224,0,0), TEXT_ALIGN_LEFT) 
                        draw.DrawText(gameOverText2, "smallerDefault", 0, 80, Color(224,0,0), TEXT_ALIGN_CENTER)

                    cam.End3D2D() 
                end

            end
        end)

        self:SetNextClientThink( CurTime() + 0.012 )

    end

end




function ENT:StartNewGame()

    for k, v in pairs(gridPosW) do 
        if IsValid(v.ent) then
            v.ent:Remove()
        end 
        if v.occupied then
            v.occupied = false  
        end
        -- this is done in two parts just in case
    end
    self.score = 0
    net.Start("TetrisScore")
        net.WriteInt(self.score, 14)
    net.Broadcast()
    net.Start("GameOver")
        net.WriteBool(false)
    net.Broadcast()
    self.gameOver = false 
    self:EmitSound("tetris/new_start.wav",100,100,100)
end



function ENT:MovePiece (ply, key)

    if SERVER then
        if key == 26 then 
            self.pause = not self.pause
        end

        if key == 91 then

            if self.gameOver then
                self:StartNewGame()
                return
            end

            if self.pieces then

                for k , v in pairs(self.pieces) do 
                    local nextPosRight = v.gridPos + 1

                    local curPos = tonumber(string.sub(tostring(v.gridPos),-1))

                    if gridPosW[nextPosRight] and gridPosW[nextPosRight].occupied == false and curPos ~= 0 then 
                        v.okSide = true

                        
                    else
                        for k2, v2 in pairs(self.pieces) do 
                            v2.okSide = false
                        end
                        break 
                    end
                    
                end

                for k , v in pairs(self.pieces) do 
                    local nextPosRight = v.gridPos + 1
                    if v.okSide then
                        v.gridPos = nextPosRight
                        v:SetPos(self:LocalToWorld(gridPosW[v.gridPos].pos))
                    end

                end

            end

        end  

        if key == 89 then

            if self.gameOver then
                self:StartNewGame()
                return
            end

            if self.pieces then

                for k , v in pairs(self.pieces) do 
                    local nextPosLeft = v.gridPos - 1
                    local curPos = tonumber(string.sub(tostring(v.gridPos),-1))

                    if gridPosW[nextPosLeft] and gridPosW[nextPosLeft].occupied == false and curPos ~= 1  then 
                        v.okSide = true

                        
                    else
                        for k2, v2 in pairs(self.pieces) do 
                            v2.okSide = false
                        end
                        break 
                    end
                    
                end

                for k , v in pairs(self.pieces) do 
                    local nextPosLeft = v.gridPos - 1
                    if v.okSide then
                        v.gridPos = nextPosLeft
                        v:SetPos(self:LocalToWorld(gridPosW[v.gridPos].pos))
                    end

                end

            end
           
        end

        if key == 88 then

            if self.gameOver then
                self:StartNewGame()
                return
            end

            if self.pieces then

                local newPos

                if self.pieceRotation == 4 then
                    self.pieceRotation = 1
                else
                    self.pieceRotation =  self.pieceRotation + 1
                end

                newPos = self.pieceType.rotations[self.pieceRotation]
                
                local moved = false
                ::test::
                local occupiedAmount = 0
                -- for index, value in pairs(newPos) do 

                --     PrintTable(newPos)
                    
                --     if gridPosW[value].occupied then

                --         occupiedAmount = occupiedAmount + 1

                --     end

                -- end
                --PrintTable(gridPosW)

                for k,v in pairs(newPos) do 
                    if gridPosW[self.pieces[3].gridPos + newPos[k]].occupied or (gridPosW[self.pieces[3].gridPos].pos - gridPosW[self.pieces[3].gridPos + newPos[k]].pos):Length() > 100 then
                        return 
                        -- occupiedAmount = occupiedAmount + 1
                    end
                end

                -- if occupiedAmount > 0 and not moved then
                --     print("OLD VALUES ARE ")
                --     PrintTable(newPos)
                --     print ("OCCUPIED BY THIS NUMBER", occupiedAmount)
                --     for index, value in pairs(newPos) do 
                --         newValue = value - occupiedAmount
                --         newPos[index] = newValue
                        
                --     end
                --     print("NEW VALUES ARE ")
                --     PrintTable(newPos)
                --     moved = true
                --     goto test
                -- end 

                -- if occupiedAmount > 0 and moved then
                --     return 
                -- end


                self.pieces[1]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[1]].pos))
                self.pieces[1].gridPos = self.pieces[3].gridPos + newPos[1]

                self.pieces[2]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[2]].pos))
                self.pieces[2].gridPos = self.pieces[3].gridPos + newPos[2]

                self.pieces[3]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[3]].pos))
                self.pieces[3].gridPos = self.pieces[3].gridPos + newPos[3]
                
                self.pieces[4]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[4]].pos))
                self.pieces[4].gridPos = self.pieces[3].gridPos + newPos[4]

            end

        end

        if key == 90 then
            
            if self.gameOver then
                return
            end
            self.downButton = true
           
        end

   end

end

function ENT:SlowPiece(ply , key)

    if key == 90 then
        self.downButton = false 
    end
end


function UnbindInputs(ply, bind)
    if bind == "+left" or bind == "+right" then
        return true 
    end
end


function ENT:OnRemove() 
    if CLIENT then
        self.cl_SoundChannel:Stop()
    end
    hook.Remove("PlayerBindPress", "UnbindInputs")
    hook.Remove("PlayerButtonDown", "MovePiece")
    hook.Remove("PlayerButtonUp", "SlowPiece")
    hook.Remove("HUDPaint", "DrawEntityText")
end
