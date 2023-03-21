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

--[[ Admin Menu ]]--
function AdminSystem.OpenAdminMenu()

	if !AdminSystem.Config.AdminMenuEnabled then return end
	if !IsValid(LocalPlayer()) then return end
	if !LocalPlayer():Alive() then return end
	if !AdminSystem.CheckStaff(LocalPlayer()) then return end

	local basicFrame = vgui.Create("AS_DFrame")
	basicFrame:SetRSize(1100, 550)
	basicFrame:Center()
	basicFrame:CloseButton(true)
	basicFrame:SetLibTitle("Menu Admin")

	--[[1]]--
	local adminColor = color_white
	if LocalPlayer():GetNWInt("AdminSystem:AdminMode") == 1 then adminColor = Color(40, 255, 40) else adminColor = Color(255, 40, 40) end

	local setAdminModButton = vgui.Create("AS_DButton", basicFrame)
	setAdminModButton:SetRPos(425, 100)
	setAdminModButton:SetRSize(250, 50)
	setAdminModButton:SetLibText("Mode Admin", adminColor)
	setAdminModButton.countdown = 0
	setAdminModButton.DoClick = function(self)

		if self.countdown < CurTime() then

			if LocalPlayer():GetNWInt("AdminSystem:AdminMode") == 1 then
				self:SetLibText("Mode Admin", Color(255, 40, 40))

				net.Start("AdminSystem:Utils:ModifyVar")
					net.WriteInt(0, 2)
				net.SendToServer()

			elseif LocalPlayer():GetNWInt("AdminSystem:AdminMode") == 0 then
				self:SetLibText("Mode Admin", Color(40, 255, 40))
				
				net.Start("AdminSystem:Utils:ModifyVar")
					net.WriteInt(1, 2)
				net.SendToServer()

			end

			self.countdown = CurTime() + 3
		end
	end

	local warnButton = vgui.Create("AS_DButton", basicFrame)
	warnButton:SetRPos(425, 200)
	warnButton:SetRSize(250, 50)
	warnButton:SetLibText("Warns", color_white)
	warnButton.countdown = 0
	warnButton.DoClick = function(self)
		if self.countdown < CurTime() then

			RunConsoleCommand("say", AdminSystem.Config.WarnsCommand)

			if IsValid(basicFrame) then
				basicFrame:Remove()
			end

			self.countdown = CurTime() + 3
		end
	end

	--[[2]]--
	local logsButton = vgui.Create("AS_DButton", basicFrame)
	logsButton:SetRPos(425, 300)
	logsButton:SetRSize(250, 50)
	logsButton:SetLibText("Logs", color_white)
	logsButton.countdown = 0
	logsButton.DoClick = function(self)

		if self.countdown < CurTime() then

			RunConsoleCommand("say", AdminSystem.Config.LogsCommand)

			if IsValid(basicFrame) then
				basicFrame:Remove()
			end
		
			self.countdown = CurTime() + 3
		end
	end
	
	local refundMenu = vgui.Create("AS_DButton", basicFrame)
	refundMenu:SetRPos(425, 400)
	refundMenu:SetRSize(250, 50)
	refundMenu:SetLibText("Remboursement", color_white)
	refundMenu.countdown = 0
	refundMenu.DoClick = function(self)
		if self.countdown < CurTime() then

			if AdminSystem then
				AdminSystem.OpenRefundMenu()
			end

			if IsValid(basicFrame) then
				basicFrame:Remove()
			end

			self.countdown = CurTime() + 3
		end
	end

	--[[ Connected Staff ]]--
	local staffConnected = 0
	for k,v in pairs(player.GetAll()) do
		if IsValid(v) && AdminSystem.CheckStaff(v) then
			staffConnected = staffConnected + 1
		end
	end

	local staffConnectedLabel = vgui.Create("DLabel", basicFrame)
	staffConnectedLabel:SetSize(Lib.RespX(180), Lib.RespY(60))
	staffConnectedLabel:SetPos(basicFrame:GetWide()-staffConnectedLabel:GetWide(), basicFrame:GetTall()-staffConnectedLabel:GetTall())
	staffConnectedLabel:SetText("")
	function staffConnectedLabel:Paint(w, h)
		draw.SimpleText("Staff connectés : "..staffConnected, "Comfortaa20", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

end
net.Receive("AdminSystem:AdminMenu:Open", AdminSystem.OpenAdminMenu)