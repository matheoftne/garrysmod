AddCSLuaFile()

CreateConVar( "awarn_kick", "1", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "Allow AWarn to kick players who reach the kick threshold. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_ban", "1", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "Allow AWarn to ban players who reach the ban threshold. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_decay", "1", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "If enabled, active warning acount will decay over time. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_reasonrequired", "1", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "If enabled, admins must supply a reason when warning someone. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_decay_rate", "30", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "Time (in minutes) a player needs to play for an active warning to decay." )
CreateConVar( "awarn_reset_warnings_after_ban", "0", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "If enabled, active warning count is cleared after a player is banned by awarn. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_logging", "0", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "If enabled, AWarn will log actions to a data file. 1=Enabled 0=Disabled" )
CreateConVar( "awarn_allow_warnadmin", "1", bit.bxor( FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED ), "Disable to disallow the warning of other admins. 1=Enabled 0=Disabled" )

AWarn = {}
AWarn.Version = "Casier"

local PlayerMeta = FindMetaTable("Player")

function awarn_ULXCompatability()
	if CLIENT then return end
	if ulx then
		ULib.ucl.registerAccess( "awarn_view", ULib.ACCESS_ADMIN, "Ability to view other players' warnings.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_warn", ULib.ACCESS_ADMIN, "Ability to warn players.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_remove", ULib.ACCESS_ADMIN, "Ability to reduce a player's active warnings.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_delete", ULib.ACCESS_SUPERADMIN, "Ability to delete a player's warning data entirely.", "AWarn" )
		ULib.ucl.registerAccess( "awarn_options", ULib.ACCESS_SUPERADMIN, "Ability to view and change AWarn settings.", "AWarn" )
	end
	if serverguard then
		serverguard.permission:Add("awarn_view")
		serverguard.permission:Add("awarn_warn")
		serverguard.permission:Add("awarn_remove")
		serverguard.permission:Add("awarn_delete")
		serverguard.permission:Add("awarn_options")
	end
end
hook.Add( "InitPostEntity", "awarn_ULXCompatability", awarn_ULXCompatability )

function awarn_checkadmin_view( self )
	if not IsValid( self ) then return true end

	if ulx then
		if ULib.ucl.query( self, "awarn_view" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_view" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif maestro then
		if maestro.rankget(maestro.userrank(self)).flags.awarn_view then return true end
		if self:IsSuperAdmin() then return true end
	elseif serverguard then
		if serverguard.player:HasPermission(self, "awarn_view") then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	end
end

function awarn_checkadmin_warn( self )
	if not IsValid( self ) then return true end

	if ulx then
		if ULib.ucl.query( self, "awarn_warn" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_warn" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif maestro then
		if maestro.rankget(maestro.userrank(self)).flags.awarn_warn then return true end
		if self:IsSuperAdmin() then return true end
	elseif serverguard then
		if serverguard.player:HasPermission(self, "awarn_warn") then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	end
end

function awarn_checkadmin_remove( self )
	if not IsValid( self ) then return true end

	if ulx then
		if ULib.ucl.query( self, "awarn_remove" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_remove" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif maestro then
		if maestro.rankget(maestro.userrank(self)).flags.awarn_remove then return true end
		if self:IsSuperAdmin() then return true end
	elseif serverguard then
		if serverguard.player:HasPermission(self, "awarn_remove") then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	end
end

function awarn_checkadmin_delete( self )
	if not IsValid( self ) then return true end

	if ulx then
		if ULib.ucl.query( self, "awarn_delete" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_delete" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif maestro then
		if maestro.rankget(maestro.userrank(self)).flags.awarn_delete then return true end
		if self:IsSuperAdmin() then return true end
	elseif serverguard then
		if serverguard.player:HasPermission(self, "awarn_delete") then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	end
end

function awarn_checkadmin_options( self )
	if not IsValid( self ) then return true end

	if ulx then
		if ULib.ucl.query( self, "awarn_options" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif evolve then
		if self:EV_HasPrivilege( "awarn_options" ) then return true end
		if self:IsSuperAdmin() then return true end
	elseif maestro then
		if maestro.rankget(maestro.userrank(self)).flags.awarn_options then return true end
		if self:IsSuperAdmin() then return true end
	elseif serverguard then
		if serverguard.player:HasPermission(self, "awarn_options") then return true end
		if self:IsSuperAdmin() then return true end
	else
		if self:IsAdmin() then return true end
		if self:IsSuperAdmin() then return true end
	end
end


--ALL CREDIT FOR THIS COMMAND GOES TO THE ULX TEAM. I PULLED THIS OUT SO THAT I COULD NOT HAVE TO RELY ON ULIB FOR A SINGLE FUNCTION.
function awarn_getUser( target )
	if not target then return false end

	local players = player.GetAll()
	target = target:lower()

	local plyMatch

	-- First, do a full name match in case someone's trying to exploit our target system
	for _, player in ipairs( players ) do
		if target == player:Nick():lower() then
			if not plyMatch then
				return player
			else
				return false
			end
		end
	end

	for _, player in ipairs( players ) do
		local nameMatch
		if player:Nick():lower():find( target, 1, true ) then -- No patterns
			nameMatch = player
		end

		if plyMatch and nameMatch then -- Already have one
			return false
		end
		if nameMatch then
			plyMatch = nameMatch
		end
	end

	if not plyMatch then
		return false
	end

	return plyMatch
end

---------------------------------END OF CREDITED CODE------------------------------------------

function AWarn_ConvertSteamID( id )
	id = string.upper(string.Trim( id ))
	if string.sub( id, 1, 6 ) == 'STEAM_' then
		local parts = string.Explode( ':', string.sub(id,7) )
		local id_64 = (1197960265728 + tonumber(parts[2])) + (tonumber(parts[3]) * 2)
		local str = string.format('%f',id_64)
		return '7656'..string.sub( str, 1, string.find(str,'.',1,true)-1 )
	else
		if tonumber( id ) ~= nil then
		  local id_64 = tonumber( id:sub(2) )
		  local a = id_64 % 2 == 0 and 0 or  1
		  local b = math.abs(6561197960265728 - id_64 - a) / 2
		  local sid = "STEAM_0:" .. a .. ":" .. (a == 1 and b -1 or b)
		  return sid
		end
	end
end

AWarn.Command = "!panel"

AWarn.Raisons = {}

AWarn.Raisons["freepunch"] = {nom = "Freepunch un joueur", message = "[Ban] Free-punch", sanction = "awarn_ban", temps = 60 }
AWarn.Raisons["faid"] = {nom = "Ouvrir une porte à distance sans utiliser de bouton", message = "[Ban] Vous avez ouvert une porte à distance sans bouton, c'est interdit sur le serveur", sanction = "ban", temps = 20 }
AWarn.Raisons["freekillvonlontaire"] = {nom = "FreeKill Volontaire", message = "[Ban] Vous avez FreeKill, c'est interdit sur le serveur.", sanction = "ban", temps = 4320 }
AWarn.Raisons["norpr"] = {nom = "Action non roleplay", message = "[Ban] Action Non RolePlay.", sanction = "ban", temps = 300 }
AWarn.Raisons["propsblo"] = {nom = "Props-Block", message = "[Ban] Props block", sanction = "ban", temps = 300 }
AWarn.Raisons["insulte"] = {nom = "Insulte hors roleplay", message = "[Ban] Vous avez insulté, c'est interdit sur le serveur", sanction = "ban", temps = 120 }
AWarn.Raisons["menace"] = {nom = "Menace sur le serveur ou joueur", message = "[Ban] Menace grave sur le serveur", sanction = "ban", temps = 0 }
AWarn.Raisons["useticket"] = {nom = "Abus de ticket admin", message = "[Kick] Vous spam les admin de ticket", sanction = "kick"}
AWarn.Raisons["voler"] = {nom = "Vole un objet qui a été acheter ou jeter au sol", message = "[Ban] Vous avez volé un objet qui a été acheté ou jeté par terre", sanction = "ban", temps = 20 }
AWarn.Raisons["matnon"] = {nom = "Utilisation de matériaux non roleplay ou non adapté a la situation roleplay", message = "[Ban] Vous avez utilisé un matériau non adapté à votre situation roleplay", sanction = "ban", temps = 5 }
AWarn.Raisons["nominterdit"] = {nom = "Utiliser un nom incitant a la haine ou au racisme", message = "[Ban] Vous avez utilisé un nom interdit sur le serveur", sanction = "ban", temps = 120 }
AWarn.Raisons["streamst"] = {nom = "StreamStalk sur le serveur", message = "[Ban] Vous avez streamstalk", sanction = "ban", temps = 300 }
AWarn.Raisons["abusticket"] = {nom = "Abus/Insulte de ticket admin", message = "[Ban] Abus des tickets administrateur", sanction = "ban", temps = 60 }
AWarn.Raisons["actionorp"] = {nom = "Action No RP", message = "[Ban] Action non RolePlay", sanction = "ban", temps = 600 }
AWarn.Raisons["armejob"] = {nom = "Arme non autorisée pour ce job", message = "Il est interdit d'avoir d'armes avec ce métier", sanction = "kick" }
AWarn.Raisons["arnaque"] = {nom = "Arnaque en vendeur d'armes/quincailler", message = "[Ban] Il est interdit d'arnaquer les joueurs avec ce métier", sanction = "ban", temps = 180 }
AWarn.Raisons["braquagelp"] = {nom = "Braquage en lieu public", message = "[Ban] Il est interdit d'effectuer un braquage en public", sanction = "ban", temps = 180 }
AWarn.Raisons["conduitenorp"] = {nom = "Conduite no RP", message = "[Ban] Il est interdit de conduire de façon non RolePlay", sanction = "ban", temps = 60 }
AWarn.Raisons["freekill"] = {nom = "Freekill", message = "[Ban] Il est interdit de tuer une personne sans raison", sanction = "ban", temps = 210 }
AWarn.Raisons["freeshoot"] = {nom = "Freeshot", message = "[Ban] Il est interdit de tirer sur une personne sans raison", sanction = "ban", temps = 120 }
AWarn.Raisons["freetazz"] = {nom = "FreeTazz un joueur", message = "[Ban] Il est interdit de Tazzer quelqu'un sans raison", sanction = "ban", temps = 60 }
AWarn.Raisons["hrpvocal"] = {nom = "HRP Vocal", message = "[Kick] Il est interdit de parler dans un contexte hors RolePlay à l'oral", sanction = "kick" }
AWarn.Raisons["insulteshrp"] = {nom = "Manque de respect/Insulte HRP", message = "[Ban] Il est interdit de manquer de respect ou d'insulter dans un contexte hors RolePlay", sanction = "ban", temps = 120 }
AWarn.Raisons["metagaming"] = {nom = "Métagaming", message = "[Ban] Il est interdit d'utiliser des informations hors RolePlay en scène RolePlay", sanction = "ban", temps = 180 }
AWarn.Raisons["nlr"] = {nom = "NLR", message = "[Ban] Il est interdit de revenir sur une scène RP lorsque vous êtes mort", sanction = "ban", temps = 180 }
AWarn.Raisons["fearrpoupainrp"] = {nom = "FearRP/PainRP", message = "[Ban] Il faut respecter la peur et la douleur en RolePlay", sanction = "ban", temps = 180 }
AWarn.Raisons["physiquegun"] = {nom = "PhysicGun/GravityGun en main abusivement", message = "Il est interdit de se promener avec son PhysicGun/GravityGun en main en pleine rue", sanction = "kick" }
AWarn.Raisons["propsblock"] = {nom = "Props-Block", message = "[Ban] Il est interdit de bloquer un lieu sans utilisation de Bouton/Keypad", sanction = "ban", temps = 300 }
AWarn.Raisons["propskill"] = {nom = "Propskill", message = "[Ban] Propskill", sanction = "ban", temps = 0 }
AWarn.Raisons["spammicro"] = {nom = "Spam Micro/SoundBoard", message = "[Ban] Il est interdit de spam micro ou d'utiliser le logiciel SoundBoard", sanction = "ban", temps = 60 }
AWarn.Raisons["spawnkill"] = {nom = "Spawnkill", message = "[Ban] Il est interdit de tuer un joueur au Spawn", sanction = "ban", temps = 1440 }
AWarn.Raisons["troll"] = {nom = "Troll", message = "[Ban] Troll", sanction = "ban", temps = 0 }
AWarn.Raisons["glitch"] = {nom = "Utilisation de glitch/hack en rapport avec l'économie", message = "[Ban] Il est interdit d'utiliser un glitch/hack sur le serveur", sanction = "ban", temps = 0 }
AWarn.Raisons["materiaunorp"] = {nom = "Materiaux No RP", message = "Il est interdit d'utiliser des materiaux non-RolePlay (qui bouge, clignote, ...)", sanction = "kick" }
AWarn.Raisons["voldrop"] = {nom = "Vol d'un objet/argent/arme qui a été jeté au sol à l'instant", message = "[Ban] Il est interdit de voler un objet/argent/arme qui a été jeté au sol à l'instant", sanction = "ban", temps = 60 }
AWarn.Raisons["avert"] = {nom = "Avertissement ( préciser )", message = "", sanction = "avert", temps = 0 }