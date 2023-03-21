--[[ Shared functions ]]--
function AdminSystem.ULXorFAdmin()
    if string.upper(AdminSystem.Config.ULXorFAdmin) == "ULX" then
        if !ULib then Error("ULib n'a pas été détecté par le système ! Cela risque de ne pas fonctionner...") end
        return true
    elseif string.upper(AdminSystem.Config.ULXorFAdmin) == "FADMIN" then
        return false
    else
        Error("Le système de cloak défini dans la configuration de l'addon est invalide.")
    end
end

function AdminSystem.AdminLogging(victim, log)
    if !AdminSystem.Config.ShowStaffActions then return end

    for _,v in pairs(player.GetAll()) do
        if AdminSystem.Config.HighRanks[v:GetUserGroup()] then
            v:PrintMessage(HUD_PRINTTALK, "[Admin System Log] "..victim:Nick().." ("..victim:SteamID()..") "..log)
        end
    end

end

function AdminSystem.CheckStaff(ply)
    if !IsValid(ply) then return end

    if AdminSystem.Config.RanksAllowed[ply:GetUserGroup()] then return true end
    if ply:IsSuperAdmin() then return true end

    return false 
end