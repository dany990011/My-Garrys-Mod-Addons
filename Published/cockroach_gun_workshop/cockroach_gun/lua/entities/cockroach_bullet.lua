AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Cockroach Bullet"
ENT.Author = "SMOK"
ENT.Spawnable = false
ENT.AdminSpawnable = true


function ENT:Initialize()
    if SERVER then
        self:SetModel("models/smok/cockroach.mdl")
        self:SetMoveType(MOVETYPE_FLY)
        self:SetSolid(SOLID_BBOX)
        self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
        self:PhysicsInit(SOLID_BBOX)
       
        
        local phys = self:GetPhysicsObject()
        
        if IsValid(phys) then
            phys:Wake()
            phys:SetMass(1)
            phys:EnableDrag(false)
            
            phys:EnableGravity(false)
            
            phys:AddAngleVelocity(Vector(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500)))
            
        end

        
    end
end

function ENT:PhysicsCollide(hitData, collider)
    
    local dmgInfo = DamageInfo()
    dmgInfo:SetDamage(5) 
    dmgInfo:SetDamageType(DMG_SLASH) 
    dmgInfo:SetAttacker(self) 
    dmgInfo:SetInflictor(self) 
    dmgInfo:SetDamagePosition(self:GetPos())  
    dmgInfo:SetDamageForce(hitData.OurOldVelocity * 2) 
    hitData.HitEntity:TakeDamageInfo(dmgInfo) 

    if hitData.HitEntity:IsWorld() or IsValid(hitData.HitEntity:GetOwner()) or hitData.HitEntity:IsValid() then
        
        local Pos1 = hitData.HitPos + hitData.HitNormal
        local Pos2 = hitData.HitPos - hitData.HitNormal
        util.Decal("YellowBlood", Pos1, Pos2)
        local effect = EffectData()
        effect:SetOrigin(dmgInfo:GetDamagePosition())

        effect:SetScale(0.2)
        util.Effect("StriderBlood", effect)
        self:EmitSound("physics/flesh/flesh_squishy_impact_hard" .. math.random(2,4).. ".wav", 80 , 90)
        self:Remove()
        
    end
end