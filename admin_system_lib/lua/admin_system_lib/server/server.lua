--[[ Functions ]]--
function Lib.Log(ply, str)
    if !ply:IsPlayer() then return end
    if !isstring(str) then return end

    local nick = ply:Nick()
    local steamid = ply:SteamID()

    ServerLog("[Logger] "..nick.." ("..steamid..") "..str.."\n")
end