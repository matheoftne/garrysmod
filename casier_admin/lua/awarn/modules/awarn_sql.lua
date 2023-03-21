local awarn_mysql_config = {
	EnableMySQL			=	false,
	Host				=	"127.0.0.1", --Host IP
	Username			=	"root",
	Password			=	"",
	Database_name		=	"awarn2", --Existing database on the MYSQL server
	Database_port		=	3306,
	Preferred_module	=	"mysqloo", --If using MySQL module (mysqloo or tmysql4)
	MultiStatements		=	false,
}

//Change this if you run multiple servers using MySQL mode.
AWarn.ServerKey = "Server 1" --Edit this to your liking. If you run multiple servers using the same database, this is how you can identify which warnings came from which server.

--[[

 DO NOT EDIT BELOW THIS LINE!!!
 DO NOT EDIT BELOW THIS LINE!!!
 DO NOT EDIT BELOW THIS LINE!!!
 DO NOT EDIT BELOW THIS LINE!!!
 DO NOT EDIT BELOW THIS LINE!!!
 DO NOT EDIT BELOW THIS LINE!!!
 DO NOT EDIT BELOW THIS LINE!!!

]]

local loc = AWarn.localizations.localLang

MySQLite_AWarn.initialize( awarn_mysql_config )

local PlayerMeta = FindMetaTable("Player")

function awarn_tbl_exist()

	timer.Simple( 1, function()
		awarn_table_warnings_exist()
		awarn_table_playerdata_exist()
		awarn_addserverfield()
	end )

end

function awarn_table_warnings_exist()
	--Check for the existance of the awarn_warnings table and create it if necessary
	MySQLite_AWarn.tableExists( "awarn_warnings", 
		function( res )
			if res == true then
				ServerLog( "AWarn: Message Table Exists\n" )
			else
				local query
				if MySQLite_AWarn.isMySQL() then
					query = "CREATE TABLE awarn_warnings ( pid INTEGER PRIMARY KEY AUTO_INCREMENT, unique_id varchar(255), admin varchar(255), reason text, date varchar(255), server varchar(255) )"
				else
					query = "CREATE TABLE awarn_warnings ( pid INTEGER PRIMARY KEY AUTOINCREMENT, unique_id varchar(255), admin varchar(255), reason text, date varchar(255), server varchar(255) )"
				end
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
				MySQLite_AWarn.tableExists( "awarn_warnings", 
					function( res )
						if res then
							ServerLog( "AWarn: Warning Table created sucessfully.\n" )
						else
							ServerLog( "AWarn: Trouble creating the Warning Table\n" )
						end
					end,
					function( error )
						ServerLog( error )
					end )
			end
		end,
		function( error )
			ServerLog( error )
		end )
end

function awarn_table_playerdata_exist()
	--Check for the existance of the awarn_playerdata table and create it if necessary
	MySQLite_AWarn.tableExists( "awarn_playerdata", 
		function( res )
			if res == true then
				ServerLog( "AWarn: Player Data Table Exists\n" )
			else
				local query
				query = "CREATE TABLE awarn_playerdata ( unique_id varchar(255), warnings INTEGER, lastwarn varchar(255) )"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
				MySQLite_AWarn.tableExists( "awarn_playerdata", 
					function( res )
						if res then
							ServerLog( "AWarn: Player Data Table created sucessfully.\n" )
						else
							ServerLog( "AWarn: Trouble creating the Player Data Table\n" )
						end
					end,
					function( error )
						ServerLog( error )
					end )
			end
		end,
		function( error )
			ServerLog( error )
		end )
end

function awarn_addserverfield(  )
	local success, err = pcall( function()
		local query = "ALTER TABLE awarn_warnings ADD server varchar(255)"
		MySQLite_AWarn.query( query, function() end, function( error, q ) end )
	end )
	
	if success then
		ServerLog( "AWarn: Server Field Successfully Added.\n" )
	else
		ServerLog( "AWarn: Server Field Exists.\n" )	
	end
end

function awarn_addwarning( uid, reason, admin )
	reason = sql.SQLStr( reason )
	admin = sql.SQLStr( admin )
	date = os.date()
	local query = "INSERT INTO awarn_warnings VALUES (NULL, '" ..uid.. "', " ..admin.. ", " ..reason.. ", '" ..date.. "', '" ..AWarn.ServerKey.. "')"
	MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
end

function awarn_incwarnings( ply )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	
	MySQLite_AWarn.query( query, 
	function( result, last )
		local wnum = 0
		if not result then
			wnum = 1
			local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. wnum .. "', '" .. os.time() .."' )"
			MySQLite_AWarn.query( query, function() awarn_checkkickban( ply ) awarn_decaywarns( ply ) end, function( error, q ) ServerLog( error ) end )
		else
			wnum = tonumber(result[1].warnings) + 1
			local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
			MySQLite_AWarn.query( query, function() awarn_checkkickban( ply ) awarn_decaywarns( ply ) end, function( error, q ) ServerLog( error ) end )
		end
	end,
	function( error, q )
		ServerLog( error )
	end )
end

function awarn_checkkickban( ply )
	if not IsValid(ply) then return end

	local kickon = GetConVar("awarn_kick"):GetBool()
	local banon = GetConVar("awarn_ban"):GetBool()	
	local resetWarningsOnBan = GetConVar("awarn_reset_warnings_after_ban"):GetBool()
	
	local uid = ply:SteamID64()
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	
	MySQLite_AWarn.query( query, 
	function( result, last )
		local wnum = 0
		if not result then
			wnum = 0
		else
			wnum = tonumber(result[1].warnings)
		end
		
		if AWarn.PunishmentSequence[wnum] then
			if AWarn.PunishmentSequence[wnum].PunishmentType == "kick" then
				if kickon then
					ServerLog("AWarn: KICKING " .. ply:Nick().. "\n")
					for k, v in pairs(player.GetAll()) do AWSendMessage( v, "AWarn: " .. ply:Nick() .. " " .. AWarn.localizations[loc].sql1 ) end
					local AWarnLimitKick = hook.Call( "AWarnLimitKick", GAMEMODE, ply )
					timer.Simple(1, function() awarn_kick( ply, AWarn.PunishmentSequence[wnum].PunishmentMessage ) end )
					return
				end
			end
			
			if AWarn.PunishmentSequence[wnum].PunishmentType == "ban" then
				if banon then
					ServerLog("AWarn: BANNING " .. ply:Nick() .. " FOR " .. AWarn.PunishmentSequence[wnum].PunishmentLength .. " minutes!\n")
					for k, v in pairs(player.GetAll()) do AWSendMessage( v, "AWarn: " .. ply:Nick() .. " " .. AWarn.localizations[loc].sql2 ) end
					local AWarnLimitBan = hook.Call( "AWarnLimitBan", GAMEMODE, ply )
					if resetWarningsOnBan then
						awarn_resetwarningsbyid( uid )
					end
					timer.Simple(1, function() awarn_ban( ply, AWarn.PunishmentSequence[wnum].PunishmentLength, AWarn.PunishmentSequence[wnum].PunishmentMessage ) end )
					return
				end			
			end
		end		
	end,
	function( error, q )
		ServerLog( error )
	end )
end

function awarn_decaywarns( ply )
	if not IsValid( ply ) then return end
	
	if GetConVar("awarn_decay"):GetBool() then
		local dr = GetConVar("awarn_decay_rate"):GetInt()
		
		local uid = ply:SteamID64()
		
		local query = "SELECT lastwarn FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
		MySQLite_AWarn.query( query, 
			function( result, last )
				local last_warn = "NONE"
				if not result then
					last_warn = "NONE"
				else
					last_warn = result[1].lastwarn
					if tonumber(os.time()) >= tonumber(last_warn) + (dr*60) then
						awarn_decwarnings(ply)
					end
					local query2 = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
					MySQLite_AWarn.query( query2, 
						function( result, last )
							if not result then
							else
								timer.Create( ply:SteamID64() .. "_awarn_decay", dr * 60, 1, function() if IsValid(ply) then awarn_decaywarns( ply ) end end )
							end					
						end,
						function( error, q )
							ServerLog( error )
						end )					
				end
			end,
			function( error, q )
				ServerLog( error )
			end )
	end
end
hook.Add( "PlayerInitialSpawn", "awarn_decaywarns", awarn_decaywarns )


function awarn_incwarningsid( uid )	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				wnum = 1
				local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. wnum .. "', '" .. os.time() .."' )"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
			else
				wnum = tonumber(result[1].warnings) + 1
				local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
		
	for k, target_ply in pairs( player.GetAll() ) do
		if target_ply:SteamID64() == uid then
			awarn_checkkickban( target_ply )
			break
		end
	end
end

function awarn_decwarnings( ply, admin )
	if not IsValid( ply ) then return end
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				if admin then AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql3 ) end
			else
				if tonumber(result[1].warnings) > 0 then
					wnum = tonumber(result[1].warnings) - 1
					local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
					MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
					AWSendMessage( admin, AWarn.localizations[loc].sql4 .. ply:Nick() )
				else
					if admin then AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql5 ) end
				end
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_decwarningsid( uid, admin )
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				if admin then AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql3 ) end
			else
				if tonumber(result[1].warnings) > 0 then
					wnum = tonumber(result[1].warnings) - 1
					local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
					MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
					AWSendMessage( admin, AWarn.localizations[loc].sql4 .. ply:Nick() )
				else
					if admin then AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql5 ) end
				end
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_resetwarningsbyid( uid )
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				
			else
				if tonumber(result[1].warnings) > 0 then
					wnum = 0
					local query = "UPDATE awarn_playerdata SET warnings='" .. wnum .. "', lastwarn='" .. os.time() .."' WHERE unique_id='" ..uid.. "'"
					MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
				end
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_setwarnings( ply, num )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				local query = "INSERT INTO awarn_playerdata VALUES ( '" ..uid.. "', '" .. num .. "', '" .. os.time() .."' )"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
			else
				local query = "UPDATE awarn_playerdata SET warnings='" .. num .. "' WHERE unique_id='" ..uid.. "'"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_delwarnings( ply, admin )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql3 )
			else
				local query = "DELETE FROM awarn_playerdata WHERE unique_id='" ..uid.. "'"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )

				local query = "DELETE FROM awarn_warnings WHERE unique_id='" ..uid.. "'"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
				
				AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql6 .. ": " .. ply:Nick() )
				ServerLog( "[AWarn] " .. admin:Nick() .. " cleared all warnings from player: " .. ply:Nick() .. "\n" )
				if GetConVar("awarn_logging"):GetBool() then
					awarn_log( admin:Nick() .. " cleared all warnings from player: " .. ply:Nick() )
				end
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_delwarningsid( uid, admin )
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql3 )
			else
				local query = "DELETE FROM awarn_playerdata WHERE unique_id='" ..uid.. "'"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )

				local query = "DELETE FROM awarn_warnings WHERE unique_id='" ..uid.. "'"
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
				
				AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql6 .. ": " .. tostring(uid) )
				
				ServerLog( "[AWarn] " .. admin:Nick() .. " cleared all warnings from player: " .. tostring(uid) .. "\n" )
				if GetConVar("awarn_logging"):GetBool() then
					awarn_log( admin:Nick() .. " cleared all warnings from player: " .. tostring(uid) )
				end
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_delsinglewarning( admin, warningid )
	local query = "SELECT * FROM awarn_warnings WHERE pid=" .. warningid
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				AWSendMessage(admin, "AWarn: " .. AWarn.localizations[loc].sql7 )
			else
				local query = "DELETE FROM awarn_warnings WHERE pid=" .. warningid
				MySQLite_AWarn.query( query, function() end, function( error, q ) ServerLog( error ) end )
				ServerLog( "[AWarn] " .. admin:Nick() .. " deleted warning from player: " .. tostring(result[1].unique_id) .. " with data ( Warning Admin: " .. tostring(result[1].admin).. " | Date: " .. tostring(result[1].date).. " | Reason: " .. tostring(result[1].reason).. ")\n" )
				if GetConVar("awarn_logging"):GetBool() then
					awarn_log( admin:Nick() .. " deleted warning from player: " .. tostring(result[1].unique_id) .. " with data ( Warning Admin: " .. tostring(result[1].admin).. " | Date: " .. tostring(result[1].date).. " | Reason: " .. tostring(result[1].reason).. ")" )
				end
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_sendwarnings( ply, target_ply )
	local uid = target_ply:SteamID64()

	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				wnum = 0
			else
				wnum = tonumber( result[1].warnings )
			end
			
			local query = "SELECT * FROM awarn_warnings WHERE unique_id='" .. uid .. "'"
			MySQLite_AWarn.query( query, 
				function( result, last )
					if not result then
						result = {}
						net.Start("SendPlayerWarns")
							net.WriteTable( result )
							net.WriteInt( wnum, 32 )
						net.Send( ply )
					else
						net.Start("SendPlayerWarns")
							net.WriteTable( result )
							net.WriteInt( wnum, 32 )
						net.Send( ply )
					end
				end,
				function( error, q )
					ServerLog( error )
				end )
			
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_sendwarnings_id( ply, target_id )
	local uid = util.SteamIDTo64( target_id )

	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				wnum = 0
			else
				wnum = tonumber( result[1].warnings )
			end
			
			local query = "SELECT * FROM awarn_warnings WHERE unique_id='" .. uid .. "'"
			MySQLite_AWarn.query( query, 
				function( result, last )
					if not result then
						result = {}
						net.Start("SendPlayerWarns")
							net.WriteTable( result )
							net.WriteInt( wnum, 32 )
						net.Send( ply )
					else
						net.Start("SendPlayerWarns")
							net.WriteTable( result )
							net.WriteInt( wnum, 32 )
						net.Send( ply )
					end
				end,
				function( error, q )
					ServerLog( error )
				end )
			
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_sendownwarnings( ply )
	local uid = ply:SteamID64()
	
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				wnum = 0
			else
				wnum = tonumber( result[1].warnings )
			end
			
			local query = "SELECT * FROM awarn_warnings WHERE unique_id='" .. uid .. "'"
			MySQLite_AWarn.query( query, 
				function( result, last )
					if not result then
						result = {}
						net.Start("SendOwnWarns")
							net.WriteTable( result )
							net.WriteInt( wnum, 32 )
						net.Send( ply )
					else
						net.Start("SendOwnWarns")
							net.WriteTable( result )
							net.WriteInt( wnum, 32 )
						net.Send( ply )
					end
				end,
				function( error, q )
					ServerLog( error )
				end )
			
		end,
		function( error, q )
			ServerLog( error )
		end )
end

function awarn_welcomebackannounce( ply )

	local uid = ply:SteamID64()
	local query = "SELECT warnings FROM awarn_playerdata WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				wnum = 0
			else
				wnum = tonumber( result[1].warnings )
				local t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), AWarn.localizations[loc].sql8 .. ", " .. ply:Nick() .. "." }
				net.Start("AWarnChatMessage") net.WriteTable(t1) net.Send( ply )
				local t2 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), AWarn.localizations[loc].sql9 .. ": ", Color(255,0,0), tostring(wnum) }
				net.Start("AWarnChatMessage") net.WriteTable(t2) net.Send( ply )
				local t5 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), AWarn.localizations[loc].sv7 }
				net.Start("AWarnChatMessage") net.WriteTable(t5) net.Send( ply )
				
				timer.Simple(1, function()
					if IsValid( ply ) then
						awarn_announceplayerwithwarnings( ply )
					end
				end )
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end
hook.Add( "PlayerInitialSpawn", "awarn_welcomebackannounce", awarn_welcomebackannounce )

function awarn_announceplayerwithwarnings( ply )
	if not IsValid( ply ) then return end
	local uid = ply:SteamID64()
	local query = "SELECT * FROM awarn_warnings WHERE unique_id='" .. uid .. "'"
	MySQLite_AWarn.query( query, 
		function( result, last )
			local wnum
			if not result then
				wnum = 0
			else
				wnum = tonumber( #result )
				local t1 = { Color(60,60,60), "[", Color(30,90,150), "AWarn", Color(60,60,60), "] ", Color(255,255,255), ply, " " .. AWarn.localizations[loc].sql10 .. ". " .. AWarn.localizations[loc].sql11 .. ": ", Color(255,0,0), tostring(wnum) }
				for k, v in pairs( player.GetAll() ) do
					if awarn_checkadmin_view( v ) then
						net.Start("AWarnChatMessage") net.WriteTable(t1) net.Send( v )
					end
				end
			end
		end,
		function( error, q )
			ServerLog( error )
		end )
end