if !CLIENT then return end

--[[ Create fonts ]]--
local function RespFont(font) return font/1920*ScrW() end
for i=1, 100 do
    surface.CreateFont("Comfortaa"..i, {
        font = "comfortaa",
        extended = false,
        size = RespFont(i),
        weight = 600,
    })
end


function AdminSystem.AddInfo()
    local update = net.ReadBool()
    local nooby = net.ReadEntity()
    if !IsValid(nooby) then return end

    if update then
        local tbl = net.ReadTable()
        nooby.refundInformations = tbl
    else
        nooby.refundInformations = nil
    end
end
net.Receive("AdminSystem:RefundMenu:SendToAdmins", AdminSystem.AddInfo)

function AdminSystem.OpenRefundMenu()
    
    if !AdminSystem.Config.RefundMenuEnabled then return end
    if !IsValid(LocalPlayer()) then return end
	if !LocalPlayer():Alive() then return end
    if !AdminSystem.CheckStaff(LocalPlayer()) then return end
    
    local selectedPlayer
    local rightPanel

    local basicFrame = vgui.Create("AS_DFrame")
	basicFrame:SetRSize(1400, 800)
	basicFrame:Center()
	basicFrame:CloseButton(true)
	basicFrame:SetLibTitle("Menu Remboursement")
    basicFrame:SlideDown(0.5)
    basicFrame.PaintOver = function(self, w, h)
        draw.SimpleText("Joueurs", "Comfortaa30", Lib.RespX(362), Lib.RespY(75), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("Informations", "Comfortaa30", Lib.RespX(1051), Lib.RespY(75), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    --[[ Left panel ]]--
    local leftPanel = vgui.Create("DPanel", basicFrame)
    leftPanel:SetSize(Lib.RespX(675), Lib.RespY(670))
    leftPanel:SetPos(Lib.RespX(25), Lib.RespY(110))
    function leftPanel:Paint(w, h)
        surface.SetDrawColor(Color(69, 69, 69, 255))
        surface.DrawRect(0, 0, w, h)
    end

    local scrollPanel = vgui.Create("DScrollPanel", leftPanel)
    scrollPanel:Dock(FILL)
    local sbar = scrollPanel:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end

    scrollPanel:Clear()
    local posy = -1
    for k,v in pairs(player.GetAll()) do
        if !IsValid(v) then continue end 
        if !v:Alive() then continue end
        if !v.refundInformations then continue end
        posy = posy + 1

        local plyButton = vgui.Create("AS_DButton", scrollPanel)
        plyButton:SetRSize(675, 50)
        plyButton:SetRPos(0, 55*posy)
        plyButton:SetLibText(v:Nick(), color_white)
        plyButton.DoClick = function(self)
            selectedPlayer = v

            if IsValid(rightPanel) then rightPanel:Remove() end

            --[[ Right panel ]]--
            rightPanel = vgui.Create("DPanel", basicFrame)
            rightPanel:SetSize(Lib.RespX(650), Lib.RespY(670))
            rightPanel:SetPos(Lib.RespX(725), Lib.RespY(110))
            rightPanel:SlideDown(0.5)
            function rightPanel:Paint(w, h)
                surface.SetDrawColor(Color(69, 69, 69, 255))
                surface.DrawRect(0, 0, w, h)

                if IsValid(selectedPlayer) && selectedPlayer.refundInformations then

                    draw.SimpleText(selectedPlayer:Nick(), "Comfortaa35", w/2, Lib.RespY(20), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    draw.SimpleText("Argent perdu : "..selectedPlayer.refundInformations.money.."€", "Comfortaa25", Lib.RespX(20), Lib.RespY(170), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Armes perdues :", "Comfortaa25", Lib.RespX(20), Lib.RespY(330), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText("Job précédent : "..team.GetName(selectedPlayer.refundInformations.job), "Comfortaa25", Lib.RespX(20), Lib.RespY(250), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                end
            end

            local pmpanel = vgui.Create("DModelPanel", rightPanel)
            pmpanel:SetSize(rightPanel:GetWide()/2, rightPanel:GetWide()/2)
            pmpanel:SetPos(rightPanel:GetWide()/2-pmpanel:GetWide()/2, Lib.RespX(40))
            if AdminSystem.Config.RefundPM then pmpanel:SetModel(selectedPlayer.refundInformations.pm) else pmpanel:SetModel(selectedPlayer:GetModel()) end

            local weap = "Fonction actuellement désactivée sur ce serveur."
            if selectedPlayer.refundInformations.weapons then 
                weap = table.concat(selectedPlayer.refundInformations.weapons, ", ")
            end

            local richText = vgui.Create("RichText", rightPanel)
            richText:SetSize(Lib.RespX(580), Lib.RespY(50))
            richText:SetPos(Lib.RespX(20), Lib.RespY(375))
            richText:SetFontInternal("Comfortaa25")
            richText:AppendText(weap)

            local toRefund = {}
            toRefund.weapons = nil 
            toRefund.money = nil 
            toRefund.job = nil 
            toRefund.PM = nil

            local refundWeap = vgui.Create("AS_DButton", rightPanel)
            refundWeap:SetSize(Lib.RespX(150), Lib.RespY(50))
            refundWeap:SetPos(Lib.RespX(40), Lib.RespY(460))
            refundWeap:SetLibText("Armes", color_white)
            refundWeap.clicked = false
            refundWeap.PaintOver = function(self, w, h)
                if self.clicked then
                    surface.SetDrawColor(Color(255, 255, 255, 50))
                    surface.DrawRect(0, 0, w, h)
                end
            end
            refundWeap.DoClick = function(self)
                if !self.clicked then
                    self.clicked = true
                    toRefund.weapons = selectedPlayer.refundInformations.weapons
                else
                    self.clicked = false 
                    toRefund.weapons = nil
                end
            end

            local refundMoney = vgui.Create("AS_DButton", rightPanel)
            refundMoney:SetSize(Lib.RespX(150), Lib.RespY(50))
            refundMoney:SetPos(Lib.RespX(255), Lib.RespY(460))
            refundMoney:SetLibText("Argent", color_white)
            refundMoney.clicked = false
            refundMoney.PaintOver = function(self, w, h)
                if self.clicked then
                    surface.SetDrawColor(Color(255, 255, 255, 50))
                    surface.DrawRect(0, 0, w, h)
                end
            end
            refundMoney.DoClick = function(self)
                if !self.clicked then
                    self.clicked = true
                    toRefund.money = selectedPlayer.refundInformations.money
                else
                    self.clicked = false
                    toRefund.money = nil
                end
            end

            local refundJob = vgui.Create("AS_DButton", rightPanel)
            refundJob:SetSize(Lib.RespX(150), Lib.RespY(50))
            refundJob:SetPos(Lib.RespX(470), Lib.RespY(460))
            refundJob:SetLibText("Métier", color_white)
            refundJob.clicked = false
            refundJob.PaintOver = function(self, w, h)
                if self.clicked then
                    surface.SetDrawColor(Color(255, 255, 255, 50))
                    surface.DrawRect(0, 0, w, h)
                end
            end
            refundJob.DoClick = function(self)
                if !self.clicked then
                    self.clicked = true
                    toRefund.job = selectedPlayer.refundInformations.job
                else
                    self.clicked = false 
                    toRefund.job = nil
                end
            end

            local send = vgui.Create("AS_DButton", rightPanel)
            send:SetSize(Lib.RespX(300), Lib.RespY(50))
            send:SetPos(Lib.RespX(180), Lib.RespY(600))
            send:SetLibText("Rembourser", color_white)
            send.clicked = false
            send.PaintOver = function(self, w, h)
                if self.clicked then
                    surface.SetDrawColor(Color(255, 255, 255, 50))
                    surface.DrawRect(0, 0, w, h)
                end
            end
            send.DoClick = function(self)
                if istable(toRefund) && toRefund then
                 net.Start("AdminSystem:RefundMenu:RefundThings")
                    net.WriteEntity(selectedPlayer)
                    net.WriteTable(toRefund)
                 net.SendToServer()
                if IsValid(basicFrame) then basicFrame:Remove() end
            end

            end

        end

    end
    
end
net.Receive("AdminSystem:RefundMenu:Open", AdminSystem.OpenRefundMenu)