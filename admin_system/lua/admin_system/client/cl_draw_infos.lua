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


-- Draw informations
--[[local contextIsOpen = AdminSystem.Config.ShowExtraInfos
local background

hook.Add("HUDPaint", "AdminSystem:HUDPaint", function()
	local ply = LocalPlayer()

    if ply:GetNWInt("AdminSystem:AdminMode") < 1 then return end

                    --draw.SimpleText(selectedPlayer:Nick(), "Comfortaa35", w/2, Lib.RespY(20), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                   -- draw.SimpleText("Argent perdu : "..selectedPlayer.refundInformations.money.."€", "Comfortaa25", Lib.RespX(20), Lib.RespY(170), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                   -- draw.SimpleText("Armes perdues :", "Comfortaa25", Lib.RespX(20), Lib.RespY(330), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                   -- draw.SimpleText("Job précédent : "..team.GetName(selectedPlayer.refundInformations.job), "Comfortaa25", Lib.RespX(20), Lib.RespY(250), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	if AdminSystem.Config.AdminSystemEnabled then

		--surface.SetDrawColor(Color(69, 69, 69, 255))
    	--surface.DrawRect(650, 0, 295, 110)
    	--surface.SetDrawColor(Color(20, 111, 255, 255))
    	--surface.DrawRect(650, 0, 295, 45)
		draw.SimpleTextOutlined("En service", "Comfortaa50", ScrW()/2, Lib.RespY(0), Color(20, 111, 255), 1, 3, 1, color_black)
		draw.SimpleTextOutlined("God", "Comfortaa30", ScrW()/2, Lib.RespY(60), Color(20, 167, 1), 1, 3, 1, color_black)
			
		if ply:GetMoveType() == MOVETYPE_NOCLIP then
			draw.SimpleTextOutlined("Noclip", "Comfortaa30", ScrW()/2-Lib.RespX(40), Lib.RespY(60), Color(20, 167, 1), 2, 3, 1, color_black)
		else
			draw.SimpleTextOutlined("Noclip", "Comfortaa30", ScrW()/2-Lib.RespX(50), Lib.RespY(60), Color(255, 40, 40), 2, 3, 1, color_black)
		end

		if ply:GetNoDraw() or ply:GetRenderMode() == RENDERMODE_TRANSALPHA then
			draw.SimpleTextOutlined("Cloak", "Comfortaa30", ScrW()/2+Lib.RespX(40), Lib.RespY(60), Color(20, 167, 1), 0, 3, 1, color_black)
		else
			draw.SimpleTextOutlined("Cloak", "Comfortaa30", ScrW()/2+Lib.RespX(50), Lib.RespY(60), Color(255, 40, 40), 0, 3, 1, color_black)
		end
	end

	if AdminSystem.Config.ShowBasicsInfos then

		for _,victim in pairs(player.GetAll()) do

			if victim == ply then continue end
			if !IsValid(victim) then continue end
			
			if !AdminSystem.Config.HighRanks[ply:GetUserGroup()] then
				if AdminSystem.Config.HighRanks[victim:GetUserGroup()] then continue end
			end

			local pos = victim:GetShootPos()
			if ply:GetPos():DistToSqr(pos) > AdminSystem.Config.DistToShow^2 then continue end

			pos.z = pos.z + 15
			pos = pos:ToScreen()
			if !pos.visible then continue end
			local x, y = pos.x+10, pos.y

			draw.SimpleTextOutlined("●", "Comfortaa22", x-10, y-20, team.GetColor(victim:Team()), 1, 1, 1, color_white)

			local plyNick = victim:Nick()
			local plyNickLen = string.len(plyNick)

			-- Name
			surface.SetDrawColor(Color(0, 0, 0, 25))
			surface.DrawRect(x-62, y-71, 150, 20)

			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(Material("icon16/vcard.png"))
			surface.DrawTexturedRect(x-60, y-69, 16, 16)

			draw.SimpleTextOutlined(plyNick, "Comfortaa20", x-35, y-72, color_white, 0, 3, 1, color_black)

			-- Job
			local jobColor = team.GetColor(victim:Team())
			local jobName = team.GetName(victim:Team())
			local jobLen = string.len(jobName)

			surface.SetDrawColor(jobColor)
			surface.DrawRect(x-62, y-50, 150, 20)

			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(Material("icon16/user_suit.png"))
			surface.DrawTexturedRect(x-60, y-48, 16, 16)

			draw.SimpleTextOutlined(jobName, "Comfortaa20", x-35, y-50, Color(255,255,255,200), 0, 3, 1, color_black)

			if contextIsOpen && ply:GetPos():DistToSqr(victim:GetShootPos()) < AdminSystem.Config.DistToShowExtra^2 then

				-- Money
				local money = victim:getDarkRPVar("money") or 0
				local moneyString = string.len(tostring(money))

				surface.SetDrawColor(Color(0, 204, 0, 25))
				surface.DrawRect(x-62, y-92, 150, 20)

				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(Material("icon16/money.png"))
				surface.DrawTexturedRect(x-60, y-90, 16, 16)

				draw.SimpleTextOutlined(money.."€", "Comfortaa20", x-35, y-93, Color(255,255,255), 0, 3, 1, color_black)

				-- Health
				local plyHealth = math.Clamp(victim:Health(), 0, 100)
				local plyHealthLen = string.len(tostring(plyHealth))

				surface.SetDrawColor(Color(255, 0, 0, 25))
				surface.DrawRect(x-62, y-114, 150, 20)

				surface.SetDrawColor(Color(255, 0, 0))
				surface.SetMaterial(Material("icon16/heart.png"))
				surface.DrawTexturedRect(x-60, y-112, 16, 16)

				draw.SimpleTextOutlined(victim:Health().."%", "Comfortaa20", x-35, y-114, Color(255,255,255,200), 0, 3, 1, color_black)

				-- Armor
				local plyArmor = math.Clamp(victim:Armor(), 0, 100)
				local plyArmorLen = string.len(tostring(plyArmor))

				surface.SetDrawColor(Color(50, 60, 255, 25))
				surface.DrawRect(x-62, y-136, 150, 20)
				
				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(Material("icon16/shield.png"))
				surface.DrawTexturedRect(x-60, y-134, 16, 16)

				draw.SimpleTextOutlined(victim:Armor().."%", "Comfortaa20", x-35, y-136, Color(255,255,255,200), 0, 3, 1, color_black)

				-- Hunger
				local plyHunger = victim:getDarkRPVar("Energy") or 0
				local plyHungerLen = string.len(tostring(plyHunger))

				surface.SetDrawColor(Color(255, 110, 0, 25))
				surface.DrawRect(x-62, y-158, 150, 20)
				
				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(Material("icon16/cup.png"))
				surface.DrawTexturedRect(x-60, y-156, 16, 16)

				draw.SimpleTextOutlined(plyHunger.."%", "Comfortaa20", x-35, y-158, Color(255,255,255), 0, 3, 1, color_black)
				
				-- Rank
				local plyRank = victim:GetUserGroup()
				local plyRankLen = string.len(plyRank)

				surface.SetDrawColor(Color(253, 182, 0, 25))
				surface.DrawRect(x-62, y-178, 150, 20)

				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(Material("icon16/key.png"))
				surface.DrawTexturedRect(x-60, y-176, 16, 16)

				draw.SimpleTextOutlined(plyRank, "Comfortaa20", x-35, y-179, Color(255,255,255), 0, 3, 1, color_black)

			end
		end
	end

	if AdminSystem.Config.ShowVehiclesInfos then
		for _,veh in pairs(ents.FindByClass("prop_vehicle_jeep")) do

			if !veh:IsVehicle() then continue end

			local pos = veh:GetPos()
			if ply:GetPos():DistToSqr(pos) > AdminSystem.Config.DistToShow^2 then continue end
			
			pos.z = pos.z + 75
			pos = pos:ToScreen()
			if !pos.visible then continue end
			local x, y = pos.x, pos.y

			local vName = veh:GetVehicleClass()
			if VC then vName = veh:VC_getName() end

			draw.SimpleTextOutlined("●", "Comfortaa22", x-10, y-20, Color(40, 40, 255), 1, 1, 1, color_white)
			draw.SimpleTextOutlined(vName, "Comfortaa20", x-15, y-40, color_white, 1, 1, 1, color_black)

		end
	end

end)--]]

hook.Add("OnContextMenuOpen", "AdminSystem:OpenContext", function()
	if !AdminSystem.Config.ShowExtraInfos then contextIsOpen = true end
end)

hook.Add("OnContextMenuClose", "AdminSystem:CloseContext", function()
	if !AdminSystem.Config.ShowExtraInfos then contextIsOpen = false end
end)