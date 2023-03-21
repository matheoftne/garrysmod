--[[----------------------------]]--
--[[-- CONFIGURATION GÉNÉRALE --]]--
--[[----------------------------]]--

-- Nom de votre communauté
AdminSystem.Config.ServerName = "Nom Serveur"

-- Cacher les commandes dans le chat (exemple : !staff) ?
AdminSystem.Config.HideCommands = true

-- Est-ce que les actions du staff doivent-être affichées dans le chat des hauts-gradés ?
AdminSystem.Config.ShowStaffActions = true

-- Les grades autorisés à utiliser le système administratif
AdminSystem.Config.RanksAllowed = {
    ["superadmin"] = true,
    ["admin"] = true,
    ["moderator"] = true,
    ["helper"] = true,
}

-- Les grades supérieurs/hauts-gradés
AdminSystem.Config.HighRanks = {
    ["superadmin"] = true,
    ["admin"] = true,
}

--[[-----------------------------------------]]--
--[[-- CONFIGURATION DU MENU ADMINISTRATIF --]]--
--[[-----------------------------------------]]--

-- Est-ce que ce module doit être activé ?
AdminSystem.Config.AdminMenuEnabled = true

-- Commande à envoyer pour ouvrir le menu administratif
AdminSystem.Config.AdminMenuCommand = "!amenu"

-- Commande utilisée par VOTRE système de logs (pour ouvrir le menu)
AdminSystem.Config.LogsCommand = "!logs"

-- Commande utilisée par VOTRE système de warns (pour ouvrir le menu)
AdminSystem.Config.WarnsCommand = "!warns"

--[[-----------------------------------------]]--
--[[-- CONFIGURATION DU MODE ADMINISTRATIF --]]--
--[[-----------------------------------------]]--

-- Est-ce que ce module doit être activé ?
-- Si désactivé, uniquement le système d'informations HUD reste actif avec la commande ci-dessous
AdminSystem.Config.AdminSystemEnabled = false

-- Commande à envoyer pour passer en mode administratif
AdminSystem.Config.AdminModeCommand = "!staff"

-- Le staff est-il automatiquement défini en mode admin lorsqu'il noclip ?
AdminSystem.Config.AdminOnNoclip = true

-- Devons-nous utiliser ULX ou FAdmin pour le système de cloak ?
AdminSystem.Config.ULXorFAdmin = "ulx" -- /!\ "ulx" ou "fadmin" seulement

-- Est-ce qu'un joueur doit être automatiquement cloak lorsqu'un admin le prend au physicgun ?
AdminSystem.Config.AutoCloakPhys = false

--[[-------------------------------------------]]--
--[[-- CONFIGURATION DU CHANGEMENT DE METIER --]]--
--[[-------------------------------------------]]--

-- Activer le changement de team lors de l'activation du mode staff
AdminSystem.Config.EnabledChangeTeam = false

-- Lorsque tu actives le mode staff, tu changes de métier, choisir le métier dans lequel tu switch
AdminSystem.Config.AllowedTeam = TEAM_STAFF

-- Lorsque tu désactives le mode staff, tu changes de métier, choisir le métier dans lequel tu switch
AdminSystem.Config.ReturnTeam = TEAM_CITOYEN

-- Lorsque tu actives le mode staff, cacher la notif du changement de ce métier ?
AdminSystem.Config.HideNotifOnChangeTeam = true

--[[----------------------------------------]]--
--[[-- CONFIGURATION DES INFORMATIONS HUD --]]--
--[[----------------------------------------]]--

-- Est-ce que le staff voit des informations en mode admin ?
AdminSystem.Config.ShowBasicsInfos = true

-- Est-ce que le staff voit des informations avancées en mode admin ?
-- (/!\ false = les informations avancées seront affichées lors de l'ouverture du menu contexutel)
AdminSystem.Config.ShowExtraInfos = false

-- Est-ce que le staff doit avoir des informations sur tous les véhicules en ville ?
AdminSystem.Config.ShowVehiclesInfos = true

-- À partir de quelle distance du staff les informations du joueur disparaissent ?
AdminSystem.Config.DistToShow = 12500

-- À partir de quelle distance du staff les informations avancées du joueur disparaissent ?
AdminSystem.Config.DistToShowExtra = 1500

--[[-------------------------------]]--
--[[-- CONFIGURATION DES TICKETS --]]--
--[[-------------------------------]]--

-- Est-ce que ce module doit être activé ?
AdminSystem.Config.TicketEnabled = true

-- Commande à envoyer pour ouvrir le menu des tickets
AdminSystem.Config.TicketMenuCommand = "!ticket"

-- Le temps en secondes que le joueur doit attendre entre 2 tickets
AdminSystem.Config.TicketTimer = 30

-- Le nombre maximum de joueurs que l'on peut choisir pour un ticket (/!\ 3 maximum)
AdminSystem.Config.TicketMaxPlayers = 3

-- Le nombre minimum de caractères que le joueur doit inscrire dans le ticket pour pouvoir l'envoyer
AdminSystem.Config.MinDescriptionLen = 5

-- Liste des raisons de ticket pour le menu
AdminSystem.Config.TicketsLevel = {
    "5 - Extrême",
    "4 - Important",
    "3 - Moyen",
    "2 - Normal",
    "1 - Léger",
}

-- Le temps en secondes après lequel le ticket se supprime automatiquement s'il n'a pas été pris en charge
AdminSystem.Config.DeleteTicketTime = 60*10 -- 60*10 = 10 minutes

-- Est-ce que les tickets apparaissent aux administrateurs lorsqu'ils ne sont pas en mode admin ?
AdminSystem.Config.TicketOnlyAdmin = true -- False : Uniquement en mode admin

--[[-------------------------------------------------]]--
--[[-- CONFIGURATION DU MENU DE GESTION DE JOUEURS --]]--
--[[-------------------------------------------------]]--

-- Est-ce que ce module doit être activé ?
AdminSystem.Config.PlayerManagmentEnabled = false

-- Commande à envoyer pour ouvrir le menu de gestion de joueurs
AdminSystem.Config.PlayerManagMenuCommand = "!pmenu"

-- Le nombre maximum de caractères que peut contenir une raison de ban/kick/etc...
AdminSystem.Config.PlayerManagMaxLen = 100

-- Pour ceux qui s'y connaissent et qui désirent modifier les commandes du menu, rendez-vous dans client/cl_player_managment.lua --

--[[--------------------------------------------]]--
--[[-- CONFIGURATION DU MENU DE REMBOURSEMENT --]]--
--[[--------------------------------------------]]--

-- Est-ce que ce module doit être activé ?
AdminSystem.Config.RefundMenuEnabled = true

-- Commande à envoyer pour ouvrir le menu de gestion des joueurs
AdminSystem.Config.RefundMenuCommand = "!rmenu"

-- Est-ce que le système prend en compte les armes lors de la mort ?
AdminSystem.Config.RefundWeapons = true

-- Est-ce que le système prend en compte l'argent lors de la mort ?
AdminSystem.Config.RefundMoney = true

-- Est-ce que le système prend en compte le modèle du joueur lors de la mort ?
AdminSystem.Config.RefundPM = true

-- Est-ce que le système prend en compte le job du métier lors de la mort ?
AdminSystem.Config.RefundJob = true

--[[------------------------------]]--
--[[-- CONFIGURATION DU LANGAGE --]]--
--[[------------------------------]]--

-- Mode administratif
AdminSystem.Language.ModeAdmin = "Mode Admin"
AdminSystem.Language.AdminModeEnabled = "Vous avez activé votre mode administratif !"
AdminSystem.Language.AdminModeDisabled = "Vous avez désactivé votre mode administratif !"

-- Menu administratif
AdminSystem.Language.AdminMenuTitle = "Menu Admin"

-- Menu de gestions de joueurs
AdminSystem.Language.PlayerManagTitle = "Gestion des joueurs"

-- Menu de remboursement
AdminSystem.Language.RefundMenuTitle = "Menu de remboursement"

-- Menu des tickets
AdminSystem.Language.TicketMenuTitle = "Menu Ticket"
AdminSystem.Language.DefaultText = "Cliquez ici pour choisir la raison du ticket..."
AdminSystem.Language.SuccessTicketMsg = "Votre ticket a été envoyé avec succès !"
AdminSystem.Language.TicketExpires = "Votre ticket a expiré car aucun staff ne s'en est occupé, veuillez en refaire un !"
AdminSystem.Language.TakeTicket = "Votre ticket a été pris par un staff !"