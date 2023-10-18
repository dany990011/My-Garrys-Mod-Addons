AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function SWEP:ShootRat()
    local owner = self:GetOwner()
    if !IsValid(owner) then return end


    local rat = ents.Create("cockroach_bullet")
    
    rat:SetPos(owner:GetShootPos() + owner:GetAimVector() * 25 )
    rat:SetAngles(owner:EyeAngles())
    rat:SetGravity(0)
    rat:Spawn()
    
    

    local phys = rat:GetPhysicsObject()
    if IsValid(phys) then
        local Spread = self.Primary.Spread
        
        phys:SetVelocity((owner:GetAimVector() + Vector(math.Rand(-Spread,Spread),math.Rand(-Spread,Spread),math.Rand(-Spread,Spread))) * 3000 )
        
    end



end

function SWEP:ShootRatSpread()
    local owner = self:GetOwner()
    local Spread = self.Secondary.Spread
    if !IsValid(owner) then return end


    local rat1 = ents.Create("cockroach_bullet")
    local rat2 = ents.Create("cockroach_bullet")
    local rat3 = ents.Create("cockroach_bullet")
    local rat4 = ents.Create("cockroach_bullet")
    
    rat1:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat1:SetAngles(owner:EyeAngles())
    rat1:SetGravity(0)
    rat1:Spawn()

    local phys = rat1:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end



    rat2:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat2:SetAngles(owner:EyeAngles())
    rat2:SetGravity(0)
    rat2:Spawn()

    local phys = rat2:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end



    rat3:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat3:SetAngles(owner:EyeAngles())
    rat3:SetGravity(0)
    rat3:Spawn()

    local phys = rat3:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end



    rat4:SetPos(owner:GetShootPos() + owner:GetAimVector() * 40 )
    
    rat4:SetAngles(owner:EyeAngles())
    rat4:SetGravity(0)
    rat4:Spawn()
    
    local phys = rat4:GetPhysicsObject()
    if IsValid(phys) then
        
        phys:SetVelocity(owner:GetAimVector() * 2000 + Vector(math.random(Spread,-Spread),math.random(Spread,-Spread),math.random(Spread,-Spread)))
        
    end




    
end