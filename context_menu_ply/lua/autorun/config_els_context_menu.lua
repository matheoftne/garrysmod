ELS_ContextMenu = ELS_ContextMenu or {}
ELS_ContextMenu.Buttons ={}

---NE PAS TOUCHER---------

function ELS_ContextMenu.Remplace(str, ply)

  str = string.Replace(str, "%name%", ply:Nick())
  str = string.Replace(str, "%steamid%", ply:SteamID())
  str = string.Replace(str, "%steamid64%", ply:SteamID64())
  str = string.Replace(str, "%uniqueid%", ply:UniqueID())

  return str

end

local function AddButton(ent, name, couleur, hovered, longueur, hauteur, gd, type, func)

    local button = {}
    button.ent = ent
    button.name = name
    button.couleur = couleur
    button.hovered = hovered
    button.longueur = longueur
    button.hauteur = hauteur
    button.gd = gd

    if type == "commande" then

      button.func = function(ply)

        RunConsoleCommand(ELS_ContextMenu.Remplace(func, ply))

      end

    elseif type == "chat" then

      button.func = function(ply)

        RunConsoleCommand("say "..ELS_ContextMenu.Remplace(func, ply))

      end

    elseif type == "custom" then

      button.func = func

    end

    table.insert(ELS_ContextMenu.Buttons, button)

end

-------DEBUT DE LA CONFIGURATION----------

----GENERAL------
ELS_ContextMenu.Staffs = { "helpeur", "admin", "Gérant Staff", "superadmin", "Modérateur-Test", "Modérateur"} --Groupe staffs qui ont accès au menu
ELS_ContextMenu.Espacement = 40 --Espacement entre les boutons
ELS_ContextMenu.RenderDistance = 300 --Distance d'affichage des boutons

------BOUTONS-----------

---AddButton(ent, nom, couleur, couleur survolé, longueur, hauteur, gauche ou droite, type : commande/chat/custom, action)

AddButton("Player", "Kick", Color(20, 111, 255), Color(255,0,0), 100, 30, "gauche", "custom", function(ply)

  RunConsoleCommand("ulx","kick",ply:Nick())

end)

AddButton("Player", "Jail", Color(20, 111, 255), Color(255,0,0), 100, 30, "gauche", "custom", function(ply)

    if ply:FAdmin_GetGlobal("fadmin_jailed") then

      RunConsoleCommand("fadmin","unjail",ply:Nick())

    else

      RunConsoleCommand("fadmin","jail", ply:Nick())

    end

end)


AddButton("Player", "Warns", Color(20, 111, 255), Color(255,0,0), 100, 30, "gauche", "custom", function(ply)
      
   awarn_menu(ply:Nick())

end)

--AddButton("Player", "Salle Admin", Color(20, 111, 255), Color(255,0,0), 100, 30, "droite", "custom", function(ply)
--  net.Start("ELS_ContextMenu::TPAdmin")
--  net.WriteEntity(ply)
--  net.SendToServer()
--end)

AddButton("prop_vehicle_jeep", "Supprimer", Color(0, 76, 153), Color(0, 76, 200), 150, 30, "droite", "custom", function(ent)
  net.Start("ELS_ContextMenu::DeleteVehicule")
  net.WriteEntity(ent)
  net.SendToServer()
end)

AddButton("prop_vehicle_jeep", "Réparer", Color(0, 76, 153), Color(0, 76, 200), 150, 30, "droite", "custom", function(ent)
  net.Start("ELS_ContextMenu::RepareVehicule")
  net.WriteEntity(ent)
  net.SendToServer()
end)

AddButton("prop_ragdoll", "Respawn", Color(0, 76, 153), Color(0, 76, 200), 200, 30, "droite", "custom", function(ent)
  net.Start("medicalrespawn")
  net.WriteEntity(ent)
  net.SendToServer()
end)
