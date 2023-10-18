AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Tetris"
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


function ENT:Initialize()
    if SERVER then


        self.bordersSpawned = false
        self.grid = false

        self.activePiece = false
        self.dwonButton = false

        self.pieceTimer = 0
        self.speed = 1

        self.linesRemoved = 0
        self.startLine = 0

        self.score = 0
        self.gameOver = false 

        self:SetModel("models/hunter/blocks/cube05x5x025.mdl")
        self:SetColor(Color(0,161,255))
        self:SetSolid(SOLID_VPHYSICS)
        --self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
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
        self.cl_slowThink = 0
        self.cl_color = Color(255,255,255,255)

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

    --print("MAX Y IS", maxs.y - mins.y)
    --print("MAX X IS", maxs.x - mins.x)

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

        gridPosH = {
            --pos1 = (gridLimits.leftMidDown + Vector(0,0,127.3 ) * 0 + Vector(0,0,27.3 ) )
    
        }
        gridPosW = {
            --pos1 = (gridLimits.leftMidDown + Vector(0,0,127.3 ) * 0 + Vector(0,0,27.3 ) )
    
        }

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


        -- local linesRemoved = 0
        -- local startLine = 0


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

        print("LINES TO REMOVE", self.linesRemoved)
        if self.linesRemoved > 0 then
            for i = self.startLine, #gridPosW do
                local targetIndex = (i - 10 * self.linesRemoved) 
                if IsValid(gridPosW[i].ent) and gridPosW[i].occupied then
                    print("BLOCK IN", i, "IS MOVING TO",targetIndex)
                    --print("TARGET INDEX",targetIndex)
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

            self.pieceType = pieceTypes[math.random(1,7)]
            self.pieces = {}
            self.pieceRotation = 0

            for i = 1, self.pieceType.num do
                if gridPosW[self.pieceType.spawnPos[i]].occupied then 
                    self.pieces = nil
                    self.gameOver = true
                    return
                end
                print("ENDED GAME BEFORE SPWAN")
            end

            for i = 1, self.pieceType.num do

                
            
                print("HEIGHT TABLE  IS ")
                --PrintTable(gridPosH)
                print("WIDTH TABLE  IS ")
                --PrintTable(gridPosW)
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
            
        end

        if self.downButton then 
            self.speed = 0.1
        else
            self.speed = 1
        end

        if CurTime() - self.pieceTimer > self.speed and self.pieces then

            -- pieceMins = self.piece:OBBMins()
            -- pieceMaxs = self.piece:OBBMaxs()

            -- self.pieceMins = pieceMins
            -- self.pieceMaxs = pieceMaxs
            
            -- local distToMoveDown = (self.piece:LocalToWorld(pieceMaxs) - self.piece:LocalToWorld(pieceMins))/2
            
            -- local centerBottom = Vector(self.piece:GetPos().x, self.piece:GetPos().y, self.piece:LocalToWorld(pieceMins).z)
            -- local centerTop = Vector(self.piece:GetPos().x, self.piece:GetPos().y, self.piece:LocalToWorld(pieceMaxs).z)

            
            --[[ 
            local tr = util.TraceLine({
                start = centerBottom,
                endpos = centerBottom + Vector(0,0,-300),
                filter = function(ent)
                    if ent.active then
                        print("hit self")
                        return false  
                    end
                    --print("ACTIVE STATUS", self.piece.active)
                    return true 
                end
            })

            if tr.Hit then
                -- print ("STARTPOS :",centerBottom)
                -- print ("HITPOS :",tr.HitPos)
                -- print("POS:", self.piece:GetPos())
                -- print("ENTITY IS", tr.Entity)
                local dist = tr.HitPos:Distance(centerBottom)
                -- print("DIST IS",dist)
                if dist < 5 then
                    self.piece.active = false
                    self.activePiece = false
                    self.piece = nil
                    print ("WELD NOW !!!")
                    return
                end
            end
             ]]
            --self.piece:SetPos(self.piece:GetPos() - Vector(0,0,distToMoveDown.z))
            -- print("table is")
            -- PrintTable(self.pieces)
            for k,v in pairs(self.pieces) do 
                
                local nextPosDown = v.gridPos - 10
                if not gridPosW[nextPosDown] or gridPosW[nextPosDown].occupied  then 
                    for k2 ,v2 in pairs(self.pieces) do
                        v2.ok = false 
                        v2:EmitSound("tetris/block_hit.wav", 70,100,100)
                    end
                    break
                else
                    v.ok = true
                end
                
            
            end

            for k,v in pairs(self.pieces) do 
                print(k,v.ok)
                if not v.ok then 

                    if gridPosW[v.gridPos - 10] == nil  or  gridPosW[v.gridPos - 10].occupied then
                        local effectData = EffectData()
                        effectData:SetOrigin(v:GetPos() + Vector(0,0,-17.5)) -- Set the position of the effect
                        effectData:SetNormal(Vector(0, 0, 1)) -- Set the normal direction of the effect
                        effectData:SetScale(1) -- Set the scale of the effect

                        util.Effect("cball_bounce", effectData)
                    end

                    gridPosW[v.gridPos].occupied = true 
                    gridPosW[v.gridPos].ent = v
                    v.active = false
                    self.activePiece = false
                    self.pieces = nil
                    
                    print ("WELD NOW !!!")
                    if gridPosW[205].occupied or gridPosW[206].occupied then
                        self.gameOver = true 
                        print("GAME OVER!")
                    end

                else

                    v.gridPos = v.gridPos - 10
                    v:SetPos(self:LocalToWorld(gridPosW[v.gridPos].pos))
                    print (v.gridPos)
                
                    print ("NEW POS IS", gridPosW[v.gridPos ])

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
            --self[k.."Border"]:SetPos(self:LocalToWorld(Vector(leftDown.x,leftDown.y,self[k.."Border"]:GetPos().z)))
            -- local currentPos = self[k.."Border"]:GetPos()
            -- local newPos = Vector(leftDown.x, leftDown.y, currentPos.z)
            -- self[k.."Border"]:SetPos(self:LocalToWorld(newPos))
            -- print ("CUBE POSITION", self[k.."Border"]:GetPos())
            -- print ("leftDown POSITION", leftDown)
            local dist = (self:LocalToWorld(v) - self[k.."Border"]:GetPos()):GetNormalized() * 200
            local distX = dist.x
            local distY = dist.y
            if distX > 0.1 or distY > 0.01 then
                -- print(distX)
                -- print(distY)
                self[k.."BorderPhys"]:SetVelocity(Vector(distX,distY,self[k.."BorderPhys"]:GetVelocity().z))
            end

        end
        
        

    end

    if CLIENT then

        

        hook.Add("PostDrawOpaqueRenderables", "DrawEntityText", function()
            local entity = self 
            
            if IsValid(entity) then

                if self.cl_displace > 0.5 then
                    self.cl_displace = self.cl_displace - (self.cl_displace*1.5^(-(CurTime() - self.cl_displaceTime)))/40 -- i dont know math, sorry
                else
                    self.cl_displace = 0
                end


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

                local color = self.cl_color

                --print("DISPLACE IS", self.cl_displace)

                local pos = entity:GetPos()
                pos = pos + entity:GetRight() * 170 
                pos = pos + entity:GetUp() * 40 + entity:GetUp() * self.cl_displace

                local angle = self:GetAngles()
                angle:RotateAroundAxis( angle:Up(), -270 )
                angle:RotateAroundAxis( angle:Forward(), 90 )

                
                net.Receive("TetrisScore", function()
                    local netScore = net.ReadInt(14)
                    self.cl_tetrisScore = netScore
                    self.cl_displace = self.cl_displace + 20
                    self.cl_displaceTime = CurTime()
                end)

                
                local text = "SCORE : "..self.cl_tetrisScore 
                surface.SetFont( "GModNotify" )
                local textWidth, textHeight = surface.GetTextSize(text)
                
                cam.Start3D2D(pos, angle , 1)  -- Start drawing in 3D2D space
                    
                    draw.DrawText(text, "GModNotify", -textWidth * 0.5, -textHeight * 0.5, color, TEXT_ALIGN_LEFT) 
                    --draw.SimpleText( text, "DermaDefault", -textWidth * 0.5, 0, color_white )
                cam.End3D2D() 
            end
        end)

    end

end







-- Define the hook function
function ENT:MovePiece (ply, key)

    if self.gameOver then
        --PrintTable(gridPosW)
        for k, v in pairs(gridPosW) do 
            if IsValid(v.ent) then
                print("REMOVING", v.ent)
                v.ent:Remove()
               
            end 
            if v.occupied then
                print("REMOVING", v.occupied)
                v.occupied = false  
            end
            -- this is done in two parts just in case
        end
        self.score = 0
        net.Start("TetrisScore")
            net.WriteInt(self.score, 14)
        net.Broadcast()
        self.gameOver = false 
    end

    if SERVER and self.pieces then

        
        --local distToMoveSide = (self.piece:LocalToWorld(pieceMaxs) - self.piece:LocalToWorld(pieceMins))/2

        

        
        print("KEY IS",key)
        if key == 91 then



            for k , v in pairs(self.pieces) do 
                local nextPosRight = v.gridPos + 1
                -- local gridPosString = tostring(v.gridPos)

                local curPos = tonumber(string.sub(tostring(v.gridPos),-1))

                print("HERE IS TEST : ", nextLineCheck)
                print("HERE IS Pos : ", v.gridPos)
                print("HERE IS NEXT Pos : ", v.gridPos + 1)
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
                    print ("NEW POS IS", gridPosW[v.gridPos ].pos)
                    v:SetPos(self:LocalToWorld(gridPosW[v.gridPos].pos))
                end

            end


        end  

        if key == 89 then

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
                    print ("NEW POS IS", gridPosW[v.gridPos ].pos)
                    v:SetPos(self:LocalToWorld(gridPosW[v.gridPos].pos))
                end

            end
           
        end

        if key == 88 then

            -- local lineUp = 10
            -- local lineDown = -10
            -- local moveRight = 1 
            -- local moveLeft = -1 

            -- local newPos1 = self.pieces[1].gridPos + lineDown * 2 + moveRight * 2
            -- local newPos2 = self.pieces[2].gridPos + lineDown + moveRight
            -- --local newPos3 = self.pieces[1].gridPos + lineDown * 2 + moveRight * 2
            -- local newPos4 = self.pieces[4].gridPos + lineUp + moveLeft

            local newPos
            local newPos2
            local newPos4
            
            -- if self.pieceRotation == 1 then
            --     newPos = self.pieceType.rotations[1]
            -- end



            -- if self.pieceRotation == 2 then
            --     newPos = self.pieceType.rotations[2]
            -- end

            if self.pieceRotation == 4 then
                self.pieceRotation = 1
            else
                self.pieceRotation =  self.pieceRotation + 1
            end
            print("ROTATION IS"..self.pieceRotation)

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

            if occupiedAmount > 0 and not moved then
                print("OLD VALUES ARE ")
                PrintTable(newPos)
                print ("OCCUPIED BY THIS NUMBER", occupiedAmount)
                for index, value in pairs(newPos) do 
                    newValue = value - occupiedAmount
                    newPos[index] = newValue
                    
                end
                print("NEW VALUES ARE ")
                PrintTable(newPos)
                moved = true
                goto test
            end 

            if occupiedAmount > 0 and moved then
                return 
            end


            self.pieces[1]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[1]].pos))
            self.pieces[1].gridPos = self.pieces[3].gridPos + newPos[1]

            self.pieces[2]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[2]].pos))
            self.pieces[2].gridPos = self.pieces[3].gridPos + newPos[2]

            self.pieces[3]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[3]].pos))
            self.pieces[3].gridPos = self.pieces[3].gridPos + newPos[3]
            
            self.pieces[4]:SetPos(self:LocalToWorld(gridPosW[self.pieces[3].gridPos + newPos[4]].pos))
            self.pieces[4].gridPos = self.pieces[3].gridPos + newPos[4]

        end

        if key == 90 then
            
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
        return true -- Block the input
    end
end


function ENT:OnRemove() 

    hook.Remove("PlayerBindPress", "UnbindInputs")
    hook.Remove("PlayerButtonDown", "MovePiece")
    hook.Remove("PlayerButtonUp", "SlowPiece")
    hook.Remove("HUDPaint", "DrawEntityText")
end
