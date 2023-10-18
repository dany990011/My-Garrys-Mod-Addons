AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


local deathSounds = {
    "rat/rat_death_1.wav",
    "rat/rat_death_2.wav",
    "rat/rat_death_3.wav"
}
local idleSounds = {
    "rat/rat_squeak_1.wav",
    "rat/rat_squeak_2.wav"
}

local idleTime = 0
local scale = 2
local pitch = 50



function ENT:Initialize()
    self:SetModel("models/alieneer/rat.mdl")
    self:SetKeyValue("npc_template","npc_rat_big")
    self:SetHullType(HULL_TINY)
    self:SetHullSizeNormal()
    self:SetSolid(SOLID_BBOX)
    self:SetMoveType(MOVETYPE_STEP)
    self:CapabilitiesAdd(CAP_MOVE_GROUND)
    self:SetMaxYawSpeed(5000)
    self:SetHealth(40)
    self:SetModelScale(scale, 0)
    self.time = CurTime()
    self.timeRuning = CurTime()
    self.followTime = CurTime()
    self.petTime = CurTime()
    self.sniffTime = 0
    self.startEatTime = false 
    self.eatTime = nil
    self.isPanicked = false
    self.isFriendly = false
    self.foundCorpse = false
    self.igonreRatCorpses = false

    self.ignoreCorpses = {}
    
    
end


function ENT:Think()
    if GetConVar("ai_disabled"):GetBool() == true then 
        
        return
    end
    if not self.isPanicked then
        local corpses = ents.FindInSphere(self:GetPos(), 200) 
        
        for i, ent in pairs(corpses) do

            if ent:GetClass() == "prop_ragdoll" then

                if (ent:GetModel() == "models/alieneer/rat.mdl" or ent:GetModel() == "models/alieneer2/rat.mdl")  and self.igonreRatCorpses then
                    continue
                end

                if table.HasValue(self.ignoreCorpses, corpses[i]) then

                    continue
                end
                
                local corpsePos = ent:GetPos()
                local ratPos = self:GetPos()
                local dir = ratPos - corpsePos
                local distance = dir:Length()

                self:SetLastPosition(ratPos - (dir - dir:GetNormalized()*40))
                self:SetSchedule(SCHED_FORCED_GO_RUN)
                
                if distance < 50 and CurTime() - self.sniffTime > 4 then 

                    self:EmitSound("rat/rat_sniff_1.wav", 80, pitch+30)
                    self.sniffTime = CurTime()

                    if not self.startEatTime then
                        self.eatTime = CurTime() + 5
                        self.startEatTime = true
                    end 

                    if (ent:GetModel() == "models/alieneer/rat.mdl" or ent:GetModel() == "models/alieneer2/rat.mdl") then 
                        self.isPanicked = true
                        self.igonreRatCorpses = true 
                        self:StopSound("rat/rat_sniff_1.wav")
                        self:EmitSound("rat/rat_panic_1.wav", 80, pitch)
                        break
                    end
                end
                if self.startEatTime and self.eatTime <= CurTime() then
                    table.insert(self.ignoreCorpses, corpses[i])
                    self.eatTime = nil
                    self.startEatTime = false
                    self:StopSound("rat/rat_sniff_1.wav")
                    
                end
                break
            end
            
        end
    end
    if not self.isFriendly then
        local players = ents.FindInSphere(self:GetPos(), 100) 
        for _, ent in pairs(players) do
            if self.isPanicked then
                if CurTime() - self.timeRuning > 5 then
                    self.isPanicked = false 
                end
                
                
                if self:GetCurrentSchedule() != SCHED_RUN_RANDOM then
                    
                    self:SetSchedule(SCHED_RUN_RANDOM)
                    idleTime = 0
                end
            end 
            if ent:IsPlayer() and CurTime() - self.timeRuning > 2 then 
                
                self:ClearSchedule()
                local ratPos = self:GetPos()
                local playerPos = ent:GetPos()
                local dir = ratPos - playerPos
                local distance = dir:Length()
                local awayPos = ratPos + dir:GetNormalized() * (distance + 100) 
                self:SetLastPosition(awayPos)
                self:SetSchedule(SCHED_FORCED_GO_RUN) 
                self.timeRuning = CurTime()
                idleTime = 0
                return

            end
            if not self:IsMoving() and ent:IsPlayer() then
                
                timer.Simple(1, function() idleTime = idleTime + 1 end)
                if idleTime >= 2 then 
                    self.isPanicked = true
                    self:EmitSound("rat/rat_panic_1.wav", 80, pitch)
                end
            end

        end
        if self.isFriendly then
            --local particleEmitter = ParticleEmitter(self:GetPos())
            --local heartParticle = particleEmitter:Add("particles/heart", self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1")))
            
        end
    else 
        
        local ply = self.plyToFollow 
        --if ply and IsValid(ply) then
            local plyPos = ply:GetPos()
            local ratPos = self:GetPos()
            local dist = ratPos:Distance(plyPos)
            if dist > 600 and CurTime() -  self.followTime > 2 then -- if the player is far enough away, move towards their position
                self:SetLastPosition(plyPos)
                self:SetActivity( ACT_RUN )
                self:SetSchedule(SCHED_FORCED_GO_RUN)
                self.followTime = CurTime()
            else 
                if self:GetPos():Distance(plyPos) < 30 then
                    self:SetSchedule(SCHED_IDLE_STAND)
                end
            end
        --end
    end

end
function ENT:SelectSchedule()
    self:SetActivity( ACT_RUN )
    self:SetSchedule(SCHED_RUN_RANDOM)
    local randomNum = math.random(0,3)
    if randomNum == 3 then 
        self:EmitSound(idleSounds[math.random(1,2)], 70, pitch)
    end
    --print("RAT IS RUNNING")
    
    if not self:IsMoving() and CurTime() - self.time > 6 then
        self:ClearSchedule()
        
        self:SetSchedule(SCHED_IDLE_STAND)
        --print("RAT IS IDLE")
        self.time = CurTime()

    end
    

end

function ENT:AcceptInput(inputName, activator, called, data)
    if not self.isPanicked and inputName == "Use" and IsValid(activator) and activator:IsPlayer() then
        
        if CurTime() - self.petTime > 0.5 then 
        self:EmitSound("physics/body/body_medium_impact_soft" ..math.random(3,7) .. ".wav", 100, math.random(90,110))
        self.isFriendly = true
        self.plyToFollow = activator
        self.petTime = CurTime()
        end

    end
end
function ENT:PlayPanicSound()
    if not self.isPanicked then
        self:EmitSound("rat/rat_panic_1.wav", 80, pitch)
    end
end
function ENT:OnTakeDamage(dmginfo)
    self:PlayPanicSound()
    self.isFriendly = false 
    self.isPanicked = true
    self:SetHealth(self:Health() - dmginfo:GetDamage())
    if self:Health() <= 0 then
        self:OnDeath(dmginfo)
    end
    --print("CURRENT SCHEDULE IS ",self:GetCurrentSchedule())
    --print("CURRENT ACTIVITY IS ",self:GetActivity())
    local effect = EffectData()
    effect:SetOrigin(dmginfo:GetDamagePosition())
    effect:SetMagnitude(dmginfo:GetDamage())
    effect:SetScale(1)
    util.Effect("BloodImpact", effect)
    local attacker = dmginfo:GetAttacker()
    local direction = attacker:GetAimVector()
    local startpos = attacker:GetShootPos()
    local endpos = startpos + direction * 300
    
    local tr = util.TraceLine({
        start = startpos,
        endpos = endpos,
        filter = function(ent)
            if ent == ply or ent == attacker:GetActiveWeapon() or ent == self then
                return false 
            end
            return false
        end 
        
    })

    util.Decal("Blood" , tr.HitPos + tr.HitNormal , tr.HitPos - tr.HitNormal)
    
end



function ENT:OnDeath(damageInfo)
    self:SetModelScale(scale, 0)
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetNoDraw(true)
    self:SetNotSolid(true)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    self:EmitSound(deathSounds[math.random(1,3)], 90, pitch)
    self:StopSound("rat/rat_panic_1.wav")
    local ragdoll = ents.Create("prop_ragdoll")
    ragdoll:SetModel("models/alieneer2/rat.mdl")
    ragdoll:SetPos(self:GetPos() + Vector(0, 0, 10))
    ragdoll:SetAngles(self:GetAngles())
    ragdoll:Spawn()
    ragdoll:Activate()
    ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    ragdoll:SetVelocity(self:GetVelocity())
    local pos = self:GetPos() + Vector(0, 0, 10)
    ParticleEffect("blood_impact_red_01", pos, Angle(0, 0, 0), nil)
    local direction = damageInfo:GetDamageForce():GetNormalized()
    local force = direction * damageInfo:GetDamage() * 300
    ragdoll:GetPhysicsObject():ApplyForceCenter(force)
    
    
    self:Remove()
end





