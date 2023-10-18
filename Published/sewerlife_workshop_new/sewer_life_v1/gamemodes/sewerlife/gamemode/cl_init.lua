include("shared.lua")
--include("hud.lua")
 
 function GM:SpawnMenuOpen()
     if !LocalPlayer():IsAdmin() then
         print(LocalPlayer():Name() , LocalPlayer():SteamID() , " tried to use the Spwan Menu")
         return false
    
     end
     print(LocalPlayer():Name() , LocalPlayer():SteamID() , " opened the Spwan Menu")
     return true
end 
local time = CurTime()

hook.Add("HUDPaint", "WelcomeMessage", function()
    local ply = LocalPlayer()
    local message = "Welcome to the Sewer Life! \n\n 1) Kill Rats \n\n 2) Rats Give Health \n\n 3) Kill Players \n\n message will disappear in ".. 20 - math.floor(CurTime() - time) .."."
    local message2 = "1) Kill Rats"
    local message3 = "2) Rats Give More Health"
    local message4 = "3) Kill Players"
    local font = "DermaLarge"

    surface.SetFont(font)
    local w, h = surface.GetTextSize(message)
    if (CurTime() - time) < 20 then
        draw.DrawText(message , font, ScrW()/2 - w/2, ScrH()/2 - h/2, Color(255,255,255), TEXT_ALIGN_LEFT)
    end
end)

