SWEP.Base = "weapon_base"
SWEP.PrintName = "Cockroach Gun"
SWEP.Category = "Cockroach Weapons"
SWEP.Author = "SMOK"
SWEP.Spawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/smok/cockroach.mdl"
SWEP.WorldModel = "models/smok/cockroach.mdl"
SWEP.ViewModelFOV = 100
SWEP.ViewModelFlip = true
SWEP.BobScale = 1
SWEP.SwayScale = 1


SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true  
SWEP.Primary.Ammo = "cockroach"
SWEP.Secondary.Ammo = "cockroach"

SWEP.Primary.Spread = 0.01
SWEP.Secondary.Spread = 80
SWEP.IronSightsPos = Vector(9.49, 10.5, -12.371)
SWEP.IronSightsAng = Vector(12, 65, -22.19)

SWEP.RecoilTime = 0
SWEP.RecoilAmount = 0


function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            
			local offsetVec = Vector(5, -2.7, 2)
			local offsetAng = Angle(180, -30, 0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") 
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
			WorldModel:SetModelScale(4)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end


	net.Receive("WeaponRecoil", function()
        local time = net.ReadFloat()
        local amount = net.ReadFloat()

        
        local wep = LocalPlayer():GetActiveWeapon()
        if IsValid(wep) then
            wep.RecoilTime = CurTime() + time
			if wep.RecoilAmount < 3 then 
            	wep.RecoilAmount = wep.RecoilAmount + amount
			else
				wep.RecoilAmount = wep.RecoilAmount
			end
        end
    end)

	function SWEP:GetViewModelPosition(pos, ang)
		pos = pos + ang:Forward() * 5 + ang:Right() * 5 + ang:Up() * - 4
		ang:RotateAroundAxis(ang:Up(), 180)
		ang:RotateAroundAxis(ang:Forward(), 40)
	
		if self.RecoilTime > CurTime() then
			pos = pos + ang:Forward() * self.RecoilAmount
			ang:RotateAroundAxis(ang:Right(), -self.RecoilAmount)
			
		end
		
		return pos, ang
	end

	function SWEP:Think()
		if self.RecoilAmount > 0 then
			self.RecoilAmount = self.RecoilAmount - 0.1
		end
	end

	
end

function SWEP:ViewModelDrawn()
		
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		local pos = vm:GetPos()
		local ang = vm:GetAngles()

		pos = pos + ang:Forward() * 5 + ang:Right() * 5 + ang:Up() * -5
		ang:RotateAroundAxis(ang:Up(), 180)

		vm:SetPos(pos)
		vm:SetAngles(ang)

	end
end

if SERVER then

	util.AddNetworkString("WeaponRecoil")

	function SWEP:PrimaryAttack()
		if !self:CanPrimaryAttack() then return end
		self:StopSound("phx/epicmetal_soft2.wav")
		self:EmitSound("phx/epicmetal_soft2.wav", 42, math.random(90,110))
		self:ShootRat()
		self:SetNextPrimaryFire(CurTime() + 0.05)
		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.Owner:SetAnimation(PLAYER_ATTACK1)



		net.Start("WeaponRecoil")
		net.WriteFloat(0.1) -- recoil time
		net.WriteFloat(1) -- recoil amount
		net.Send(self.Owner)

	end 



	function SWEP:SecondaryAttack()
		if !self:CanPrimaryAttack() then return end
		self:EmitSound("phx/epicmetal_hard2.wav", 100, 100)
		self:ShootRatSpread()
		self:SetNextSecondaryFire(CurTime() + 0.4)
		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		net.Start("WeaponRecoil")
		net.WriteFloat(0.1) -- recoil time
		net.WriteFloat(3) -- recoil amount
		net.Send(self.Owner)
	end 

end
