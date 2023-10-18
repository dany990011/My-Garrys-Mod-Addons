AddCSLuaFile()

SWEP.Author = "SMOK"
SWEP.Base = "weapon_base"
SWEP.PrintName = "Rat Gun"
SWEP.Category = "Rat Weapons"
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.ViewModelFOV = 82
SWEP.ViewModelFlip = true



SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true  
SWEP.Primary.Ammo = "rats"
SWEP.Secondary.Ammo = "rats"

function SWEP:Initialize()
    self:SetHoldType("smg")
end

function SWEP:PrimaryAttack()
    if !self:CanPrimaryAttack() then return end
    self:EmitSound("phx/epicmetal_soft1.wav", 130, 100)
    self:ShootRat()
    self:SetNextPrimaryFire(CurTime() + 0.2)
    self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
end 

function SWEP:SecondaryAttack()
    if !self:CanPrimaryAttack() then return end
    self:EmitSound("phx/epicmetal_hard1.wav", 130, 100)
    self:ShootRatSpread()
    self:SetNextSecondaryFire(CurTime() + 0.4)
    self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
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
        
        phys:SetVelocity(owner:GetAimVector() * 3000)
        
    end

    local trail = util.SpriteTrail(rat, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat.Trail = trail

end

function SWEP:ShootRatSpread()
    local owner = self:GetOwner()
    if !IsValid(owner) then return end


    local rat1 = ents.Create("rat_bullet")
    local rat2 = ents.Create("rat_bullet")
    local rat3 = ents.Create("rat_bullet")
    local rat4 = ents.Create("rat_bullet")
    
    rat1:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 - Vector(0, 0, 20) + Vector(0, -10, 0))
    
    rat1:SetAngles(owner:EyeAngles())
    rat1:SetGravity(0)
    rat1:Spawn()

    local phys = rat1:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(0,math.random(40,-40),math.random(40,-40)))
        
    end

    local trail = util.SpriteTrail(rat1, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat1.Trail = trail

    rat2:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 + Vector(0, 0, 20))
    
    rat2:SetAngles(owner:EyeAngles())
    rat2:SetGravity(0)
    rat2:Spawn()

    local phys = rat2:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(0,math.random(40,-40),math.random(40,-40)))
        
    end

    local trail = util.SpriteTrail(rat2, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat2.Trail = trail

    rat3:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 + owner:GetRight() * 20)
    
    rat3:SetAngles(owner:EyeAngles())
    rat3:SetGravity(0)
    rat3:Spawn()

    local phys = rat3:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(0,math.random(40,-40),math.random(40,-40)))
        
    end

    local trail = util.SpriteTrail(rat3, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat3.Trail = trail

    rat4:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 - owner:GetRight() * 20)
    
    rat4:SetAngles(owner:EyeAngles())
    rat4:SetGravity(0)
    rat4:Spawn()
    
    local phys = rat4:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(0,math.random(40,-40),math.random(40,-40)))
        
    end

    local trail = util.SpriteTrail(rat4, 0, Color(96, 81, 48), false, 10, 0, 2, 1, "trails/smoke.vmt")
    rat4.Trail = trail


    
end