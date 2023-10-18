AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Pac-Man entity"
ENT.Category = "Pac-Man"
ENT.Author = "SMOK"
ENT.Spawnable = true
ENT.AdminSpawnable = true

if SERVER then

    function ENT:Initialize()
        self:SetSolid(SOLID_BBOX)
        -- self:PhysicsInit(SOLID_BBOX)
        self:SetAutomaticFrameAdvance(true)
        self:SetModel("models/smok/pacman/pacman.mdl")
        self:SetModelScale(3)
        --self:ResetSequence(1)
        self.test = false 
        
    end

end