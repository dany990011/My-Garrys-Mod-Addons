AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
--AddCSLuaFile("hud.lua")

include("shared.lua")

if SERVER then
    AddCSLuaFile("entities/npc_rat/init.lua")

    --include("entities/npc_rat/init.lua")
end

function GM:PlayerSpawn(ply)
    ply:SetGravity(.80)
    ply:SetRunSpeed(500)
    ply:SetWalkSpeed(300)
    --ply:Give("weapon_physcannon")
    ply:Give("weapon_physgun")
    ply:Give("weapon_crowbar")
    ply:SetupHands()
    ply:AllowFlashlight(true)
    ply:ChatPrint("You Have Spawned!")
    print("Player " .. ply:Nick() .. " has spawned!")
    print("SteamID : ", ply:SteamID())
    
end

function GM:PlayerSpawnObject(ply, model, skin)
    if ply:IsAdmin() then
        return true
    else
        print(ply:Name() .. " tried to spawn " .. model)
        return false
    end
end

function GM:PlayerSpawnSENT(ply, model, skin)
    if ply:IsAdmin() then
        return true
    else
        print(ply:Name() .. " tried to spawn " .. model)
        return false
    end
end

function GM:PlayerSpawnNPC(ply, model, skin)
    if ply:IsAdmin() then
        return true
    else
        print(ply:Name() .. " tried to spawn " .. model)
        return false
    end
end

function GM:PlayerSpawnVehicle(ply, model, skin)
    if ply:IsAdmin() then
        return true
    else
        print(ply:Name() .. " tried to spawn " .. model)
        return false
    end
end

function GM:PlayerSpawnSWEP(ply, model, skin)
    if ply:IsAdmin() then
        return true
    else
        print(ply:Name() .. " tried to spawn " .. model)
        return false
    end
end





--[[ 
-- Disable noclip
function GM:PlayerNoClip(ply)
    return false
end
 ]]
function GM:PlayerInitialSpawn(ply)

end
util.AddNetworkString("PlayerHeal")
hook.Add("OnNPCKilled", "NPCDeath", function(npc, attacker, inflictor)
    print ("something killed")
    if npc:GetClass() == "npc_rat" then
        print ("rat killed")
        print (attacker)
        attacker:SetHealth(attacker:Health() + 10)
        if SERVER then
            net.Start("PlayerHeal")
            net.Send(attacker)
        end
    end
end
)

