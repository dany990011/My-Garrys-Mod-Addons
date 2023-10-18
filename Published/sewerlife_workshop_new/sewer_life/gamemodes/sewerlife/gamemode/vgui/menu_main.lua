local PANEL = {
    Init = function (self)
        self:SetSize(1000,700)
        self:Center()
        self:SetVisible(true)
        --self:MakePopup()
        


        local x,y = self:GetSize()

        local button = vgui.Create("DButton", self)
        button:SetText("KILL?")
        button:SetSize(100, 60 )
        button:SetPos(20,20)
        button.DoClick = function()
            KillPlayer()
        end

        local button = vgui.Create("DButton", self)
        button:SetText("PISTOL - 10$")
        button:SetSize(100, 60 )
        button:SetPos(140,20)
        button.DoClick = function()
            BuyPistol()
        end

        local button = vgui.Create("DButton", self)
        button:SetText("SHOTGUN - 30$")
        button:SetSize(100, 60 )
        button:SetPos(260,20)
        button.DoClick = function()
            BuyShotgun()
            
        end
       
        
    end,

    Paint = function( self ,w ,h)

        draw.RoundedBox(0,0,0,w,h,Color(10,10,10,200))
        surface.SetDrawColor(255,255,255)
        surface.DrawOutlinedRect(2,2,w-4,h-4)


    end
}

vgui.Register("menu_main", PANEL)