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
        minZ = -2385
    }

}



local index = 1
function SpawnNPCs()
    local maxNPCs = 10
    local numNPCs = #ents.FindByClass("npc_*")
    
    for key, value in pairs(locations["first"]) do
        index = key
    end
    if numNPCs < maxNPCs then
        print("rat spawned ", locations["first"][index])
        local npc = ents.Create("npc_rat")
        npc:SetPos(Vector(math.random(locations["first"]["minX"], locations["first"]["maxX"]),math.random(locations["first"]["minZ"], locations["first"]["maxZ"]),80))
        npc:SetAngles(Angle(0,math.random(0,360),0))
        npc:Spawn()
    end
end


timer.Create("NPCSpawner",10, 0, SpawnNPCs)


if CLIENT then
    net.Receive("PlayerHeal", function()
        PlayerHeal()
    end)
end

function PlayerHeal()
    local greenScreen = Material("pp/fb")

    -- Inside your healing function:
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
            ["$pp_colour_contrast"] = 1 * ((alpha/4)+1),
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