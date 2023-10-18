
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube075x075x075.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    

    local phys = self:GetPhysicsObject()
    phys:Wake()
    phys:SetMass(100)
    
    self.entsTable = {}

end

function ENT:SpawnFunction(ply, tr , ClassName)

    self.spwanedBy = ply

    -- Bellow this is copied from base_entity.lua
    if ( !tr.Hit ) then return end
    
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	local ent = ents.Create( ClassName )
	ent:SetCreator( ply )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()

	ent:DropToFloor()

	return ent

    -- ends here
end

function ENT:Think()
    local phys = self:GetPhysicsObject()
    --local players = ents.FindByClass("player")
    local player = self.spwanedBy
    
    
    
    local playerPos = player:GetPos()
    local force = playerPos-self:GetPos()
    local forceDir = (playerPos-self:GetPos()):GetNormalized()
    local distance = force:Length()
    if distance > 150 then
        --print(phys:GetVelocity():Length())
        local distanceMult = math.Clamp(distance*50,0,3000)
        if phys:GetVelocity():Length() < 150 then
            distanceMult = math.Clamp(distance*50,0,3000)
        end
        if phys:GetVelocity():Length() > 200 then
            
            distanceMult = math.Clamp(distance*50,0,1000)
        end
        --phys:ApplyForceCenter(forceDir*distanceMult)
        phys:ApplyForceOffset(forceDir*distanceMult, self:GetPos() + Vector(0,0,60))
    end

    local things = ents.FindInSphere(self:GetPos(), 100)
    for _,ent in pairs(things) do 
        if ent ~= self and not ent:GetOwner():IsPlayer() and not ent:GetOwner():IsWorld() and not ent:IsPlayer() then
            Consume(self, ent)
            ent:Remove()
        end
    end
    return
end
--[[ ( string.find(ent:GetClass(),"prop.*") or string.find(ent:GetClass(),"ent.*") ) ]]

function ENT:PhysicsCollide(data, phys)
	if data.DeltaTime > 0.1 and data.Speed > 5 then
		
        self:EmitSound("physics/concrete/concrete_impact_hard" .. math.random(1, 3) .. ".wav", 90 * math.Clamp(data.Speed/300,0.8,1), 100 * math.Clamp(data.Speed/300,0,1), 1 * math.Clamp(data.Speed/150,0,1) )
    
	end
end

function Consume(self, ent)

    table.insert(self.entsTable, {ent:GetClass() , ent:GetModel()})
    print(ent, "Added to the table,")
    PrintTable(self.entsTable)
    
end

function ENT:AcceptInput( name, activator, caller, data )
	for _, ent in pairs(self.entsTable) do
        local spwanEnt = ents.Create(ent[1])
        spwanEnt:SetPos(self:GetPos() + Vector(0,0,40))
        spwanEnt:SetModel(ent[2])
        --ent:SetAngles(data.angle)
        -- set any other data you need to recreate the entity
        spwanEnt:Spawn()
        
        --self:NextThink(CurTime() + 1)
        break
    end
end
