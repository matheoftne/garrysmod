--[[local staffJob = AdminSystem.Config.AllowedTeam
local returnJob = AdminSystem.Config.ReturnTeam
hook.Add("PlayerSay", "AdminSystem:OnStaffCommand", function(staff, text)

    if !IsValid(staff) then return end

    elseif text == AdminSystem.Config.AdminModeCommand && AdminSystem.Config.AdminSystemEnabled then

        if verifyStaff(staff) then
            
            if staff:GetNWInt("StaffMod") == 0 then

                if AdminSystem.Config.EnableChangeTeam then
                    if staff:Team() != staffJob then
                        staff:changeTeam(staffJob, true, AdminSystem.Config.HideNotifOnChangeTeam)
                    end
                end
            end
        end
    end

    elseif staff:GetNWInt("StaffMod") == 1 then
                
                if AdminSystem.Config.EnableChangeTeam then
                    if staff:Team() != returnJob then
                        staff:changeTeam(returnJob, true, AdminSystem.Config.HideNotifOnChangeTeam)
                    end
                end
    end
end)--]]