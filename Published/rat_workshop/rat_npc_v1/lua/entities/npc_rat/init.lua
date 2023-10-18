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


function ENT:Initialize()
    self:SetModel("models/alieneer/rat.mdl")
    self:SetKeyValue("npc_template","npc_rat")
    self:SetHullType(HULL_TINY)
    self:SetHullSizeNormal()
    self:SetSolid(SOLID_BBOX)
    self:SetMoveType(MOVETYPE_STEP)
    self:CapabilitiesAdd(CAP_MOVE_GROUND)
    self:SetMaxYawSpeed(5000)
    self:SetHealth(20)
    self.time = CurTime()
    self.timeRuning = CurTime()
    self.isPanicked = false

    
end

local idleTime = 0
function ENT:Think()
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
                self:EmitSound("rat/rat_panic_1.wav", 80, 100)
            end
        end

    end
end
function ENT:SelectSchedule()
    self:SetActivity( ACT_RUN )
    self:SetSchedule(SCHED_RUN_RANDOM)
    local randomNum = math.random(0,3)
    if randomNum == 3 then 
        self:EmitSound(idleSounds[math.random(1,2)], 70, 100)
    end
    --print("RAT IS RUNNING")
    
    if not self:IsMoving() and CurTime() - self.time > 6 then
        self:ClearSchedule()
        
        self:SetSchedule(SCHED_IDLE_STAND)
        --print("RAT IS IDLE")
        self.time = CurTime()

    end
    

end

function ENT:OnTakeDamage(dmginfo)
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
    self:SetSolid(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetNoDraw(true)
    self:SetNotSolid(true)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    self:EmitSound(deathSounds[math.random(1,3)], 90, 100)
    local ragdoll = ents.Create("prop_ragdoll")
    ragdoll:SetModel(self:GetModel())
    ragdoll:SetPos(self:GetPos())
    ragdoll:SetAngles(self:GetAngles())
    ragdoll:Spawn()
    ragdoll:Activate()
    ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    ragdoll:SetVelocity(self:GetVelocity())
    local pos = self:GetPos() + Vector(0, 0, 10)
    ParticleEffect("blood_impact_red_01", pos, Angle(0, 0, 0), nil)
    local direction = damageInfo:GetDamageForce():GetNormalized()
    local force = direction * damageInfo:GetDamage() * 100
    ragdoll:GetPhysicsObject():ApplyForceCenter(force)
    
    
    self:Remove()
end





