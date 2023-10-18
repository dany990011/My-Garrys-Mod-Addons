AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")








function SWEP:Initialize()
    self:SetHoldType("smg")
end

function SWEP:PrimaryAttack()
    if !self:CanPrimaryAttack() then return end
    self:EmitSound("phx/epicmetal_soft2.wav", 60, math.random(100,80))
    self:ShootRat()
    self:SetNextPrimaryFire(CurTime() + 0.2)
    self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
    self.Owner:SetAnimation(PLAYER_ATTACK1)

end 



function SWEP:SecondaryAttack()
    if !self:CanPrimaryAttack() then return end
    self:EmitSound("phx/epicmetal_hard2.wav", 100, 100)
    self:ShootRatSpread()
    self:SetNextSecondaryFire(CurTime() + 0.4)
    self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
    self.Owner:SetAnimation(PLAYER_ATTACK1)
end 

function SWEP:ShootRat()
    local owner = self:GetOwner()
    if !IsValid(owner) then return end


    local rat = ents.Create("rat_bullet")
    
    rat:SetPos(owner:GetShootPos() + owner:GetAimVector() * 20)
    rat:SetAngles(owner:EyeAngles())
    rat:SetGravity(0)
    rat:Spawn()
    
    

    local phys = rat:GetPhysicsObject()
    if IsValid(phys) then
        local Spread = self.Primary.Spread
        
        phys:SetVelocity((owner:GetAimVector() + Vector(math.Rand(-Spread,Spread),math.Rand(-Spread,Spread),math.Rand(-Spread,Spread))) * 3000 )
        
    end

    local trail = util.SpriteTrail(rat, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat.Trail = trail

end

function SWEP:ShootRatSpread()
    local owner = self:GetOwner()
    local Spread = self.Secondary.Spread
    if !IsValid(owner) then return end


    local rat1 = ents.Create("rat_bullet")
    local rat2 = ents.Create("rat_bullet")
    local rat3 = ents.Create("rat_bullet")
    local rat4 = ents.Create("rat_bullet")
    
    rat1:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat1:SetAngles(owner:EyeAngles())
    rat1:SetGravity(0)
    rat1:Spawn()

    local phys = rat1:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end

    local trail = util.SpriteTrail(rat1, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat1.Trail = trail

    rat2:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat2:SetAngles(owner:EyeAngles())
    rat2:SetGravity(0)
    rat2:Spawn()

    local phys = rat2:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end

    local trail = util.SpriteTrail(rat2, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat2.Trail = trail

    rat3:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat3:SetAngles(owner:EyeAngles())
    rat3:SetGravity(0)
    rat3:Spawn()

    local phys = rat3:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end

    local trail = util.SpriteTrail(rat3, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat3.Trail = trail

    rat4:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat4:SetAngles(owner:EyeAngles())
    rat4:SetGravity(0)
    rat4:Spawn()
    
    local phys = rat4:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end

    local trail = util.SpriteTrail(rat4, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat4.Trail = trail


    
end