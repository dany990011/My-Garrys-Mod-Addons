function hud()
    local client = LocalPlayer()
    
    if !client:Alive() then 
        return 
    end

    draw.RoundedBox(10, 50, ScrH() - 250, 250, 100, Color(50,50,50,101))

    draw.SimpleText("MONEY      "..client:GetNWInt("money").."$", "DermaLarge", 70 , ScrH() - 215, Color(56,255,86,230),0 ,50)
 --[[   draw.RoundedBox(5, 20, ScrH() - 80, math.Clamp(client:Health(), 0, 100) * 2.2, 15, Color(0, 200, 0 , 230))
    draw.RoundedBox(5, 20, ScrH() - 80, math.Clamp(client:Health(), 0, 100) * 2.2, 5, Color(0, 240, 0 , 230))
 
    draw.SimpleText("Health: "..client:Health().."%", "DermaDefaultBold", 20 , ScrH() - 100, Color(255,255,255,230),0 ,50)
    draw.RoundedBox(5, 20, ScrH() - 80, math.Clamp(client:Health(), 0, 100) * 2.2, 15, Color(0, 200, 0 , 230))
    draw.RoundedBox(5, 20, ScrH() - 80, math.Clamp(client:Health(), 0, 100) * 2.2, 5, Color(0, 240, 0 , 230))

    draw.SimpleText("Armor: "..client:Armor().."%", "DermaDefaultBold", 20 , ScrH() - 60, Color(255,255,255,230),0 ,50)
    draw.RoundedBox(5, 20, ScrH() - 40, math.Clamp(client:Armor(), 0, 100) * 2.2, 15, Color(0, 0, 200 , 230))
    draw.RoundedBox(5, 20, ScrH() - 40, math.Clamp(client:Armor(), 0, 100) * 2.2, 5, Color(0, 0, 240 , 230))

    draw.RoundedBox(5, 265, ScrH() - 80, 125, 70, Color(50,50,50,230))

    if (client:GetActiveWeapon():GetPrintName() != nil) then
        draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "DermaDefaultBold", 275, ScrH()-60, Color(255,255,255,230),0 , 0)
    end

    if (client:GetActiveWeapon():Clip1() != -1) then 
        draw.SimpleText(client:GetActiveWeapon():Clip1() .."/".. client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold" , 275, ScrH()-40, Color(255,255,255,230),0 , 0)
    else
        draw.SimpleText(client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType()), "DermaDefaultBold", 275, ScrH()-40, Color(255,255,255,230),0 , 0)
    end ]]
    
end
hook.Add("HUDPaint", "TestHud", hud)

--[[ function HideHud(name)
    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do 
        if name == v then
            return false
        end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud) ]]