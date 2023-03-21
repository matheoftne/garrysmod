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

local AdminSystem_TicketTimer = 0
function AdminSystem.OpenTicketMenu()

	if !IsValid(LocalPlayer()) then return end
	if !LocalPlayer():Alive() then return end
	if !AdminSystem.Config.TicketEnabled then return end

	if AdminSystem.Config.AdminSystemEnabled && !AdminSystem.Config.TicketOnlyAdmin then
		local staffConnected = 0
		for k,v in pairs(player.GetAll()) do
			if IsValid(v) && AdminSystem.CheckStaff(v) && v:GetNWInt("AdminSystem:AdminMode") > 0 then
				staffConnected = staffConnected + 1
			end
		end

		if staffConnected == 0 then chat.AddText(Color(255, 40, 40), "Aucun administrateur n'est disponible, impossible de faire un ticket !") return end
	end

	local selectedPlayer = {}

	local basicFrame = vgui.Create("AS_DFrame")
	basicFrame:SetRSize(1500, 850)
	basicFrame:Center()
	basicFrame:SlideDown(0.5)
	basicFrame:CloseButton(true)
	basicFrame:SetLibTitle("Menu Ticket")
	function basicFrame:PaintOver(w, h)
		draw.SimpleText("Liste des joueurs", "Comfortaa30", Lib.RespX(200), Lib.RespX(70), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("Urgence du ticket", "Comfortaa30", Lib.RespX(410), Lib.RespX(110), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("Description du ticket", "Comfortaa30", Lib.RespX(410), Lib.RespX(325), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	--[[ PLAYER LIST ]]--
	local scrollPanel = vgui.Create("DScrollPanel", basicFrame)
	scrollPanel:SetSize(Lib.RespX(350), Lib.RespX(800))
	scrollPanel:SetPos(Lib.RespX(25), Lib.RespX(110))
	scrollPanel:GetVBar():SetHideButtons(true)
	scrollPanel.antiSpamActive = false
	function scrollPanel:Paint(w, h)
		surface.SetDrawColor(color_white)
		surface.DrawLine(w-1, 0, w-1, h)
	end
	local sbar = scrollPanel:GetVBar()
	function sbar:Paint(w, h)
	end
	function sbar.btnGrip:Paint(w, h)
	end

	for k,v in pairs(player.GetAll()) do
		if IsValid(v) then
			if v == LocalPlayer() then continue end

			local panel = scrollPanel:Add("DPanel")
			panel:SetSize(scrollPanel:GetWide(), Lib.RespX(65))
			panel:Dock(TOP)
			panel:DockMargin(Lib.RespX(3), Lib.RespX(5), Lib.RespX(20), Lib.RespX(2))
			panel.clicked = false
			panel.hovered = false
			function panel:Paint(w, h)

				if panel.clicked or panel.hovered && #selectedPlayer < AdminSystem.Config.TicketMaxPlayers then
					draw.RoundedBox(0, 0, 0, w, h, Color(20, 111, 255))
				elseif #selectedPlayer >= AdminSystem.Config.TicketMaxPlayers then
					draw.RoundedBox(0, 0, 0, w, h, Color(47, 47, 47, 150))
				else
					draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55, 250))
				end

				surface.SetDrawColor(color_white)
				surface.DrawRect(Lib.RespX(4), Lib.RespX(4), Lib.RespX(57), Lib.RespX(57))
			end

			local avatar = vgui.Create("AvatarImage", panel)
			avatar:SetSize(Lib.RespX(55), Lib.RespX(55))
			avatar:SetPos(Lib.RespX(5), Lib.RespX(5))
			avatar:SetPlayer(v, 128)

			local button = vgui.Create("AS_DButton", panel)
			button:Dock(FILL)
			button:SetText("")
			function button:Paint(w, h)
				draw.SimpleText(v:Nick(), "Comfortaa25", Lib.RespX(70), h/Lib.RespX(2), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			function button:DoClick()
				if panel.clicked then
					panel.clicked = false
					if table.HasValue(selectedPlayer, v) then
						table.RemoveByValue(selectedPlayer, v)
					end
				elseif !panel.clicked && #selectedPlayer < AdminSystem.Config.TicketMaxPlayers then
					panel.clicked = true
					if !table.HasValue(selectedPlayer, v) then
						table.insert(selectedPlayer, v)
					end
				end
			end
			function button:OnCursorEntered()
				panel.hovered = true
			end
			function button:OnCursorExited()
				panel.hovered = false
			end

		end
	end

	--[[ REPORT PANEL ]]--
	local dboxcombo = vgui.Create("DComboBox", basicFrame)
	dboxcombo:SetSize(Lib.RespX(575), Lib.RespX(40))
	dboxcombo:SetPos(Lib.RespX(410), Lib.RespX(150))
	dboxcombo:SetValue(AdminSystem.Language.DefaultText)
	for _,val in pairs(AdminSystem.Config.TicketsLevel) do
		dboxcombo:AddChoice(val)
	end

	local descriptionEntry = vgui.Create("DTextEntry", basicFrame)
	descriptionEntry:SetSize(Lib.RespX(1050), Lib.RespX(350))
	descriptionEntry:SetPos(Lib.RespX(410), Lib.RespX(370))
	descriptionEntry:SetMultiline(true)
	descriptionEntry:SetFont("Comfortaa25")

	local valiAS_DButton = vgui.Create("AS_DButton", basicFrame)
	valiAS_DButton:SetRSize(500, 65)
	valiAS_DButton:SetRPos(675, 755)
	valiAS_DButton:SetLibText("Envoyer", color_white)
	function valiAS_DButton:DoClick()

		if AdminSystem_TicketTimer < CurTime() then

			local descriptionText = descriptionEntry:GetValue()
			local subjectText = dboxcombo:GetSelected()

			if string.len(descriptionText) > AdminSystem.Config.MinDescriptionLen && string.len(descriptionText) < 5000 && dboxcombo:GetValue() != AdminSystem.Language.DefaultText then
				
				net.Start("AdminSystem:Tickets:SendTicket")
					net.WriteTable(selectedPlayer)
					net.WriteString(subjectText)
					net.WriteString(descriptionText)
				net.SendToServer()

				chat.AddText(Color(40, 255, 40), AdminSystem.Language.SuccessTicketMsg)
			
				AdminSystem_TicketTimer = CurTime() + AdminSystem.Config.TicketTimer

				basicFrame:Close()
			
			else
				chat.AddText(Color(255, 40, 40), "Veuillez remplir correctement votre ticket !")
			end
		
		else
			chat.AddText(Color(255, 40, 40), "Veuillez attendre avant d'envoyer un autre ticket !")
		end
	end

end
net.Receive("AdminSystem:Tickets:Open", AdminSystem.OpenTicketMenu)