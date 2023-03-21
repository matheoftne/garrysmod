--[[ Functions ]]--
function AdminSystem.AdminTable(ticketOnly)

    if !isbool(ticketOnly) then ticketOnly = false end

    local tbl = {}
    for k,v in pairs(player.GetAll()) do
        if !IsValid(v) then continue end
        if !AdminSystem.CheckStaff(v) then continue end
        if ticketOnly then
            if !AdminSystem.Config.TicketOnlyAdmin && v:GetNWInt("AdminSystem:AdminMode") == 0 then continue end
        end

        table.insert(tbl, v)
    end
    return tbl
end

--[[function AdminSystem.UpdateAdminMod(ply)
    if !IsValid(ply) then return end
    if !AdminSystem.CheckStaff(ply) then return end

    if ply:GetNWInt("AdminSystem:AdminMode") == 0 then

        ply:SetNWInt("AdminSystem:AdminMode", 1)

        if AdminSystem.Config.AdminSystemEnabled then
            
            if AdminSystem.ULXorFAdmin() then
                ULib.invisible(ply, true)
                RunConsoleCommand("ulx", "god", ply:Nick())
            else
                RunConsoleCommand("_FAdmin", "Cloak", ply:UserID())
                RunConsoleCommand("_FAdmin", "God", ply:UserID())
            end
            
            if ply:GetMoveType() == MOVETYPE_WALK then ply:SetMoveType(MOVETYPE_NOCLIP) end

            DarkRP.notify(ply, 0, 7, AdminSystem.Language.AdminModeEnabled)
            Lib.Log(ply, "a activé le mode administratif !")
            AdminSystem.AdminLogging(ply, "a activé le mode administratif !")

            sound.Play("player/suit_sprint.wav", ply:GetPos())
        end

    else

        ply:SetNWInt("AdminSystem:AdminMode", 0)

        if AdminSystem.Config.AdminSystemEnabled then

            if AdminSystem.ULXorFAdmin() then
                ULib.invisible(ply, false)
                RunConsoleCommand("ulx", "ungod", ply:Nick())
            else
                RunConsoleCommand("_FAdmin", "UnCloak", ply:UserID())
                RunConsoleCommand("_FAdmin", "UnGod", ply:UserID())
            end

            if ply:GetMoveType() == MOVETYPE_NOCLIP then ply:SetMoveType(MOVETYPE_WALK) end

            DarkRP.notify(ply, 0, 7, AdminSystem.Language.AdminModeDisabled)
            Lib.Log(ply, "a désactivé le mode administratif !")
            AdminSystem.AdminLogging(ply, "a désactivé le mode administratif !")
        
            sound.Play("player/suit_sprint.wav", ply:GetPos())
        end

    end
end--]]
