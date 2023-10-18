AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("vgui/menu_main.lua")

include("shared.lua")

if SERVER then
    AddCSLuaFile("entities/npc_rat/init.lua")

    --include("entities/npc_rat/init.lua")
end

function GM:PlayerSpawn(ply)
    ply:SetGravity(.80)
    ply:SetRunSpeed(500)
    ply:SetWalkSpeed(300)
    ply:Give("weapon_physcannon")
    --ply:Give("weapon_physgun")
    ply:Give("weapon_fists")
    ply:SetupHands()
    ply:AllowFlashlight(true)
    ply:ChatPrint("You Have Spawned!")
    ply:SetModel("models/player/Group01/male_07.mdl")
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


util.AddNetworkString("f4menu")


function GM:ShowSpare2(ply)
    net.Start ("f4menu")
        net.Send( ply )
    print("F4 PRESSED")
    
end

util.AddNetworkString("KillPlayer")

net.Receive("KillPlayer", function(len, ply)
    ply:Kill()
end)


util.AddNetworkString("buyPistol")

net.Receive("buyPistol", function(len, ply)
    local currentMoney = ReadPlayerMoneyFromFile(ply)
    local newMoney = currentMoney - 10
    if (newMoney < 0) then return end
    ply:SetNWInt("money", newMoney)
    WritePlayerMoneyToFile(ply, newMoney)

    if ply:HasWeapon("weapon_pistol") then 
        ply:GiveAmmo(18,"Pistol")
    else
        ply:Give("weapon_pistol")
        ply:SwitchToDefaultWeapon()
    end
end)


util.AddNetworkString("buyShotgun")

net.Receive("buyShotgun", function(len, ply)
    local currentMoney = ReadPlayerMoneyFromFile(ply)
    local newMoney = currentMoney - 30
    if (newMoney < 0) then return end
    ply:SetNWInt("money", newMoney)
    WritePlayerMoneyToFile(ply, newMoney)

    if ply:HasWeapon("weapon_shotgun") then 
        ply:GiveAmmo(6,"Buckshot")
    else
        ply:Give("weapon_shotgun")
        ply:SwitchToDefaultWeapon()
    end
end)


function GM:PlayerInitialSpawn(ply)

end

util.AddNetworkString("PlayerHeal")
hook.Add("OnNPCKilled", "NPCDeath", function(npc, attacker, inflictor)
    local currentMoney = ReadPlayerMoneyFromFile(attacker)
    local newMoney = currentMoney + 10

    WritePlayerMoneyToFile(attacker, newMoney)
    attacker:SetNWInt("money", newMoney)
    
    print ("something killed")
    if npc:GetClass() == "npc_rat" or npc:GetClass() == "npc_rat_hostile" then
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

function SetPlayerMoney(ply)
    local money = ReadPlayerMoneyFromFile(ply) 
    ply:SetNWInt("money", money) 
end

hook.Add("PlayerInitialSpawn", "SetPlayerMoney", SetPlayerMoney)

function ReadPlayerMoneyFromFile(ply)
    local steamid = ply:SteamID() 
    local money = 0

    if file.Exists("money.txt", "DATA") then 
        local data = util.JSONToTable(file.Read("money.txt", "DATA")) 
        if data and data[steamid] then
            money = data[steamid] or 0 
        else
            money = 0
        end
        
    end

    return money
end

function WritePlayerMoneyToFile(ply, money)
    local steamid = ply:SteamID() 
    print ("TEST STEAM ID IS ", steamid)
    if file.Exists("money.txt", "DATA") then 
        local data = util.JSONToTable(file.Read("money.txt", "DATA"))  
        if data then
            print("STEAMID TEST :", data[steamid])
            data[steamid] = money 
            file.Write("money.txt", util.TableToJSON(data)) 
        else
            local data = {[steamid] = money}
            file.Write("money.txt", util.TableToJSON(data)) 
        end
    else
        
    end
end

