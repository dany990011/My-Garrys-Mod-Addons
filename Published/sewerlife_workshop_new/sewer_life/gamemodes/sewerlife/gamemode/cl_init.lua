include("shared.lua")
include("hud.lua")
include("vgui/menu_main.lua")
 
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
    local message = "Welcome to the Sewer Life! \n\n 1) Rats give health and money \n\n 2) Use the money to buy guns \n\n 3) Kill Players ?\n\n message will disappear in ".. 20 - math.floor(CurTime() - time) .."."
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

net.Receive("f4menu",function()
    if !MainMenu then
        MainMenu = vgui.Create("menu_main")
        MainMenu:SetVisible(false)
    end

    if MainMenu:IsVisible() then 
        MainMenu:SetVisible(false)
        gui.EnableScreenClicker(false)
    else
        MainMenu:SetVisible(true)
        gui.EnableScreenClicker(true)
    end
        --[[ local frame = vgui.Create("DFrame")
        frame:SetSize(1000,720)
        
        frame:Center()
        frame:SetDraggable(false )
        frame:SetVisible(true)
        frame:MakePopup()
        
        frame.Paint = function (self , w ,h)
            draw.RoundedBox (0, 0 , 0, w, h, Color(204,58,58,200))
        end

        frame:SetDeleteOnClose(true)

        local x,y = frame:GetSize()

        local button = vgui.Create("DButton", frame)
        button:SetText("KILL?")
        button:SetSize(100, 60 )
        button:SetPos(20,20)
        button.DoClick = function()
            KillPlayer()
        end

        local button = vgui.Create("DButton", frame)
        button:SetText("PISTOL - 10$")
        button:SetSize(100, 60 )
        button:SetPos(140,20)
        button.DoClick = function()
            BuyPistol()
        end

        local button = vgui.Create("DButton", frame)
        button:SetText("SHOTGUN - 30$")
        button:SetSize(100, 60 )
        button:SetPos(260,20)
        button.DoClick = function()
            BuyShotgun()
        end ]]
    

end)

function KillPlayer()
    net.Start("KillPlayer")
    net.SendToServer()
end

function BuyPistol()
    net.Start("buyPistol")
    net.SendToServer()
end

function BuyShotgun()
    net.Start("buyShotgun")
    net.SendToServer()
end