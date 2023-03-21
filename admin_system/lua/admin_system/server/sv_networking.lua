if !SERVER then return end

--[[ Networking ]]--
util.AddNetworkString("AdminSystem:Utils:ModifyVar")
util.AddNetworkString("AdminSystem:AdminMenu:Open")
util.AddNetworkString("AdminSystem:PlayerManag:Open")
util.AddNetworkString("AdminSystem:RefundMenu:Open")
util.AddNetworkString("AdminSystem:RefundMenu:SendToAdmins")
util.AddNetworkString("AdminSystem:RefundMenu:RefundThings")
util.AddNetworkString("AdminSystem:Tickets:Open")
util.AddNetworkString("AdminSystem:Tickets:SendTicket")
util.AddNetworkString("AdminSystem:Tickets:SendToAdmins")
util.AddNetworkString("AdminSystem:Tickets:AdminTaking")

net.Receive("AdminSystem:Utils:ModifyVar", function(_, ply)
    if !IsValid(ply) then return end
    if !ply:Alive() then return end

    local int = net.ReadInt(2)
    ply:SetNWInt("AdminSystem:AdminMode", int)
end)

net.Receive("AdminSystem:Tickets:SendTicket", function(_, ply)
    if !AdminSystem.Config.TicketEnabled then return end
    if !IsValid(ply) then return end

    local tbl = {}
    tbl.plys = net.ReadTable()
    tbl.sender = ply
    tbl.subject = net.ReadString()
    tbl.description = net.ReadString()

    net.Start("AdminSystem:Tickets:SendToAdmins")
        net.WriteBool(true)
        net.WriteTable(tbl)
    net.Send(AdminSystem.AdminTable(true))
    
end)

net.Receive("AdminSystem:Tickets:AdminTaking", function(_, ply)
    if !IsValid(ply) then return end

    local bool = net.ReadBool()
    local sender = net.ReadEntity()

    if !IsValid(sender) then return end

    net.Start("AdminSystem:Tickets:SendToAdmins")
        net.WriteBool(false) -- show or complete
        net.WriteBool(bool) -- delete ?
        net.WriteEntity(ply)
        net.WriteEntity(sender)
    net.Send(AdminSystem.AdminTable(true))

end)

net.Receive("AdminSystem:RefundMenu:RefundThings", function(_, ply)
    if !IsValid(ply) then return end

    local victim = net.ReadEntity()
    local refund = net.ReadTable()

    DarkRP.notify(victim, 0, 7, "Vous avez été remboursé par "..ply:Nick().." !")
    DarkRP.notify(ply, 0, 7, "Le remboursement a eu lieu avec succès !")

    -- update for others admins
    net.Start("AdminSystem:RefundMenu:SendToAdmins")
        net.WriteBool(false)
        net.WriteEntity(victim)
    net.Send(AdminSystem.AdminTable())

end)