GM.Name = "Sewer Life"
GM.Author = "SMOK"
GM.Email = "N/A"
GM.Website = "N/A"

DeriveGamemode("sandbox")

function GM:Initialize()
    
end


-- Disable noclip
function GM:PlayerNoClip(ply)
    if not ply:IsAdmin() then
        print(ply:Name() , ply:SteamID() , " tried to use noclip")
        return false
    else
        print(ply:Name() , ply:SteamID() , " used noclip")
        return true
    end
end

local locations = {
    ["first"] = {
        maxX = 426,
        minX = -699,
        maxZ = -2139,
        minZ = -2385,
        floor = 80
    },
    ["second"] = {
        maxX = -2071,
        minX = -2123,
        maxZ = -3159,
        minZ = -3393,
        floor = 44
    }


}


NPCs = {
    ["first"] = {
        maxNPCs = 10,
        aliveNPCs = 0
    },
    ["second"] = {
        maxNPCs = 4,
        aliveNPCs = 0
    }
}


local index = 1
function SpawnNPCs(location)
    local maxNPCs = NPCs[location]["maxNPCs"]
    local numNPCs = NPCs[location]["aliveNPCs"]
    
    for key, value in pairs(locations[location]) do
        index = key
    end

    if numNPCs < maxNPCs then
        print("rat spawned ", locations[location][index])
        
        local npc = ents.Create("npc_rat_hostile")
        npc:SetPos(Vector(math.random(locations[location]["minX"], locations[location]["maxX"]),math.random(locations[location]["minZ"], locations[location]["maxZ"]),locations[location]["floor"]))
        npc:SetAngles(Angle(0,math.random(0,360),0))
        npc.spawnArea = location
        npc:Spawn()
        NPCs[location]["aliveNPCs"] = NPCs[location]["aliveNPCs"] + 1
        print("Living rats in location:" , NPCs[location]["aliveNPCs"] , "Max rats in location:", NPCs[location]["maxNPCs"])
    end
end


timer.Create("NPCSpawner",5, 0, function() SpawnNPCs("first") end)


timer.Create("NPCSpawner2",10, 0, function() SpawnNPCs("second") end)


if CLIENT then
    net.Receive("PlayerHeal", function()
        PlayerHeal()
    end)
end

function PlayerHeal()
    local greenScreen = Material("pp/fb")

    
    local startTime = CurTime()
    hook.Add("RenderScreenspaceEffects", "GreenHealingScreen", function()
        local timePassed = CurTime() - startTime
        local alpha = math.Clamp(1 - (timePassed / 1), 0, 1)
        local contAlpha = math.Clamp(1 - (timePassed / 1), 1, 2)
        
        DrawColorModify({
            ["$pp_colour_addr"] = 0,
            ["$pp_colour_addg"] = 0,
            ["$pp_colour_addb"] = 0,
            ["$pp_colour_brightness"] = -0.04 * alpha,
            ["$pp_colour_contrast"] = 1 * ((alpha/2)+1),
            ["$pp_colour_colour"] = 1 * ((alpha/1)+1),
            ["$pp_colour_mulr"] = 0,
            ["$pp_colour_mulg"] = 0,
            ["$pp_colour_mulb"] = 0
        })
        if timePassed >= 1 then
            hook.Remove("RenderScreenspaceEffects", "GreenHealingScreen")
        end
    end)
end