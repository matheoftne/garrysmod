AddCSLuaFile()

local loc = AWarn.localizations.localLang

surface.CreateFont( "AWarnFont1",
{
	font      = "Arial",
	size      = 18,
	weight    = 700,
})

surface.CreateFont( "AWarnFont3",
{
	font      = "Arial",
	size      = 24,
	weight    = 700,
})

surface.CreateFont( "Casier:AWarn:Font:Arial:45",
{
	font      = "Arial",
	size      = 45,
	weight    = 700,
})

surface.CreateFont( "Casier:AWarn:Font:Arial:19",
{
	font      = "Arial",
	size      = 19,
	weight    = 700,
})

function awarn_menu()

	local intHeaderH = 30
	AWarn.MenuFrame = vgui.Create( "DFrame" )
	AWarn.MenuFrame:SetSize( ScrW() - 100, 595 + intHeaderH )
	AWarn.MenuFrame:SetTitle( "" )
	AWarn.MenuFrame:SetVisible( true )
	AWarn.MenuFrame:SetDraggable( true )
	AWarn.MenuFrame:ShowCloseButton( true )
	AWarn.MenuFrame:MakePopup()
	AWarn.MenuFrame:Center()
	function AWarn.MenuFrame:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 89, 125, 195, 200 ) )

		draw.SimpleText( "Casier Administratif", "Casier:AWarn:Font:Arial:45", 15, 5, color_white )
	end

	local MenuPanel = vgui.Create( "DPanel", AWarn.MenuFrame )
	MenuPanel:Dock( FILL )
	MenuPanel:DockMargin( 0, intHeaderH, 0, 0 )
	MenuPanel.Paint = function() -- Paint function
		surface.SetDrawColor( Color( 15, 76, 180, 225 ) )
		surface.DrawRect( 0, 0, MenuPanel:GetWide(), MenuPanel:GetTall() ) -- Draw the rect
	end

	local MenuPanel2 = vgui.Create( "DPanel", AWarn.MenuFrame )
	MenuPanel2:Dock( BOTTOM )
	MenuPanel2:DockMargin( 0, 5, 0, 0 )
	MenuPanel2:SetHeight( 35 )
	MenuPanel2.Paint = function() -- Paint function
		surface.SetDrawColor( Color( 15, 76, 180, 225 ) )
		surface.DrawRect( 0, 0, MenuPanel2:GetWide(), MenuPanel2:GetTall() ) -- Draw the rect
	end

	local MenuPanel2Text1 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text1:SetPos( 5, 2 )
	MenuPanel2Text1:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text1:SetFont( "AWarnFont1" )
	MenuPanel2Text1:SetText( AWarn.localizations[loc].cl4 .. ": " )
	MenuPanel2Text1:SizeToContents()

	AWarn.MenuFrame.MenuPanel2Text2 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.MenuFrame.MenuPanel2Text2:SetPos( 255, 2 )
	AWarn.MenuFrame.MenuPanel2Text2:SetColor( Color(255, 200, 200, 255) )
	AWarn.MenuFrame.MenuPanel2Text2:SetFont( "AWarnFont1" )
	AWarn.MenuFrame.MenuPanel2Text2:SetText( "0" )
	AWarn.MenuFrame.MenuPanel2Text2:SizeToContents()

	local MenuPanel2Text3 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text3:SetPos( 5, 17 )
	MenuPanel2Text3:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text3:SetFont( "AWarnFont1" )
	MenuPanel2Text3:SetText( AWarn.localizations[loc].cl5 .. ": " )
	MenuPanel2Text3:SizeToContents()

	AWarn.MenuFrame.MenuPanel2Text4 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.MenuFrame.MenuPanel2Text4:SetPos( 255, 17 )
	AWarn.MenuFrame.MenuPanel2Text4:SetColor( Color(255, 200, 200, 255) )
	AWarn.MenuFrame.MenuPanel2Text4:SetFont( "AWarnFont1" )
	AWarn.MenuFrame.MenuPanel2Text4:SetText( "0" )
	AWarn.MenuFrame.MenuPanel2Text4:SizeToContents()

	AWarn.MenuFrame.MenuPanel2Text5 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.MenuFrame.MenuPanel2Text5:SetPos( 280, 6 )
	AWarn.MenuFrame.MenuPanel2Text5:SetColor( Color(255, 255, 255, 255) )
	AWarn.MenuFrame.MenuPanel2Text5:SetFont( "AWarnFont3" )
	AWarn.MenuFrame.MenuPanel2Text5:SetText( "" )
	AWarn.MenuFrame.MenuPanel2Text5:SizeToContents()

	local MenuPanel2Button1 = vgui.Create( "DButton", MenuPanel2 )
	MenuPanel2Button1:SetSize( 210, 25 )
	MenuPanel2Button1:Dock( RIGHT )
	MenuPanel2Button1:DockMargin( 0, 5, 5, 5 )
	MenuPanel2Button1:SetText( AWarn.localizations[loc].cl6 )
	MenuPanel2Button1:SetTextColor( color_white )
	MenuPanel2Button1:SetFont( 'Trebuchet24' )
	MenuPanel2Button1.DoClick = function( MenuPanel2Button1 )
		awarn_offlineplayerprompt()
	end
	function MenuPanel2Button1:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 10, 130, 255, 255 ) )
	end

	AWarn.MenuFrame.WarningsList = vgui.Create( "DListView", MenuPanel )
	AWarn.MenuFrame.WarningsList:Dock( FILL )
	AWarn.MenuFrame.WarningsList:DockMargin( 5, 5, 5, 5 )
	AWarn.MenuFrame.WarningsList:SetWidth( 565 )
	AWarn.MenuFrame.WarningsList:SetMultiSelect(false)
	AWarn.MenuFrame.WarningsList:AddColumn("ID"):SetFixedWidth( 40 )
	AWarn.MenuFrame.WarningsList:AddColumn(AWarn.localizations[loc].cl7):SetFixedWidth( 200 )
	AWarn.MenuFrame.WarningsList:AddColumn(AWarn.localizations[loc].cl8)
	AWarn.MenuFrame.WarningsList:AddColumn(AWarn.localizations[loc].cl9):SetFixedWidth( 120 )
	AWarn.MenuFrame.WarningsList:AddColumn(AWarn.localizations[loc].cl10):SetFixedWidth( 100 )
	AWarn.MenuFrame.WarningsList.OnRowRightClick = function( PlayerList, line )
		local DropDown = DermaMenu()
		DropDown:AddOption(AWarn.localizations[loc].cl11, function()
			warning = AWarn.MenuFrame.WarningsList:GetLine( line ):GetValue( 1 )
			net.Start("awarn_deletesinglewarn")
				net.WriteInt( warning, 16 )
			net.SendToServer()

			AWarn.MenuFrame.WarningsList:Clear()
			net.Start("awarn_fetchwarnings")
				net.WriteString( AWarn.lastselectedtype )
				net.WriteString( AWarn.lastselected )
			net.SendToServer()
		end )
		DropDown:AddOption(AWarn.localizations[loc].cl12, function()
			SetClipboardText( AWarn.MenuFrame.WarningsList:GetLine( line ):GetValue( 3 ) )
			MsgC( Color(255,0,0), "AWarn2: ", Color(255,255,255), AWarn.localizations[loc].cl13)
		end )
		DropDown:Open()
	end

	local MenuPanel3 = vgui.Create( "DPanel", AWarn.MenuFrame )
	MenuPanel3:Dock( RIGHT )
	MenuPanel3:DockMargin( 0, intHeaderH, 0, 0 )
	MenuPanel3:SetWidth( 200 )
	MenuPanel3.Paint = function() -- Paint function
		surface.SetDrawColor( Color( 15, 76, 180, 225 ) )
		surface.DrawRect( 0, 0, MenuPanel3:GetWide(), MenuPanel3:GetTall() ) -- Draw the rect
	end

	AWarn.MenuFrame.PlayerList = vgui.Create( "DListView", MenuPanel3 )
	AWarn.MenuFrame.PlayerList:Dock( FILL )
	AWarn.MenuFrame.PlayerList:DockMargin( 0, 5, 5, 5 )
	AWarn.MenuFrame.PlayerList:SetWidth( 200 )
	AWarn.MenuFrame.PlayerList:SetMultiSelect(false)
	AWarn.MenuFrame.PlayerList:AddColumn(AWarn.localizations[loc].cl14)
	AWarn.MenuFrame.PlayerList.OnRowSelected = function( PlayerList, line )
		AWarn.MenuFrame.WarningsList:Clear()
		net.Start("awarn_fetchwarnings")
			net.WriteString( "playername" )
			net.WriteString( tostring(AWarn.MenuFrame.PlayerList:GetLine( line ):GetValue( 1 )) )
		net.SendToServer()
		AWarn.lastselected = tostring(AWarn.MenuFrame.PlayerList:GetLine( line ):GetValue( 1 ))
		AWarn.lastselectedtype = "playername"
		AWarn.MenuFrame.MenuPanel2Text5:SetText("")
	end
	AWarn.MenuFrame.PlayerList.OnRowRightClick = function( PlayerList, line )
		local DropDown = DermaMenu()
		DropDown:AddOption(AWarn.localizations[loc].cl15, function()
			AWarn.activeplayer = AWarn.MenuFrame.PlayerList:GetLine( line ):GetValue( 1 )
			awarn_playerwarnmenu()
		end )
		DropDown:AddOption(AWarn.localizations[loc].cl16, function()
			AWarn.MenuFrame.WarningsList:Clear()
			AWarn.playerinfo = {}
			awarn_deletewarnings( AWarn.MenuFrame.PlayerList:GetLine( line ):GetValue( 1 ) )
		end )
		DropDown:AddOption(AWarn.localizations[loc].cl17, function()
		awarn_removewarn( AWarn.MenuFrame.PlayerList:GetLine( line ):GetValue( 1 ) )
		end )
		DropDown:AddSpacer()

		DropDown:Open()
	end

	for _, v in pairs( player.GetAll() ) do
		AWarn.MenuFrame.PlayerList:AddLine( v:Nick() )
	end
end

function awarn_offlineplayerprompt()
	local MenuFrame = vgui.Create( "DFrame" )
	MenuFrame:SetPos( ScrW() / 2 - 190, ScrH() / 2 - 85 )
	MenuFrame:SetSize( 290, 120 )
	MenuFrame:SetVisible( true )
	MenuFrame:SetDraggable( true )
	MenuFrame:ShowCloseButton( true )
	MenuFrame:MakePopup()
	MenuFrame:SetTitle('')
	function MenuFrame:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 15, 76, 180, 240 ) )
		draw.SimpleText( "Rechercher un joueur", "Casier:AWarn:Font:Arial:19", 8, 5, color_white )
	end

	local MenuPanel = vgui.Create( "DPanel", MenuFrame )
	MenuPanel:SetPos( 5, 30 )
	MenuPanel:SetSize( MenuFrame:GetWide() - 10, MenuFrame:GetTall() - 10 )
	MenuPanel.Paint = nil

	local MenuPanelLabel1 = vgui.Create( "DLabel", MenuPanel )
	MenuPanelLabel1:SetPos( 5, 5 )
	MenuPanelLabel1:SetColor( Color(255, 255, 255, 255) )
	MenuPanelLabel1:SetFont( "AWarnFont1" )
	MenuPanelLabel1:SetText( "SteamID..." )
	MenuPanelLabel1:SizeToContents()

	local MenuPanelTextEntry1 = vgui.Create( "DTextEntry", MenuPanel )
	MenuPanelTextEntry1:SetSize( MenuPanel:GetWide() - 10, 20 )
	MenuPanelTextEntry1:SetPos( 5, 30 )
	MenuPanelTextEntry1:SetMultiline( false )

	local MenuPanelButton1 = vgui.Create( "DButton", MenuPanel )
	MenuPanelButton1:SetSize( 80, 30 )
	MenuPanelButton1:SetPos( MenuFrame:GetWide() / 2 - MenuPanelButton1:GetWide() / 2 - MenuPanelButton1:GetWide() / 2 - 10, 55 )
	MenuPanelButton1.DoClick = function( MenuPanelButton1 )
		awarn_sendwarning( HiddenLabel:GetText(), MenuPanelTextEntry1:GetValue() )
		MenuFrame:Close()
	end
	MenuPanelButton1:SetText( AWarn.localizations[loc].cl23 )
	MenuPanelButton1:SetTextColor( color_white )
	MenuPanelButton1:SetFont( 'Trebuchet24' )
	function MenuPanelButton1:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 10, 130, 255, 255 ) )
	end
	function MenuPanelButton1:DoClick()
		AWarn.MenuFrame.WarningsList:Clear()
		AWarn.MenuFrame.PlayerList:ClearSelection()
		net.Start("awarn_fetchwarnings")
			net.WriteString( "playerid" )
			net.WriteString( MenuPanelTextEntry1:GetValue() )
		net.SendToServer()
		AWarn.lastselectedtype = "playerid"
		AWarn.lastselected = MenuPanelTextEntry1:GetValue()
		AWarn.MenuFrame.MenuPanel2Text5:SetText( "Vérification des infractions du joueur : " .. MenuPanelTextEntry1:GetValue() )
		AWarn.MenuFrame.MenuPanel2Text5:SizeToContents()
		MenuFrame:Close()
	end

	local MenuPanelButton2 = vgui.Create( "DButton", MenuPanel )
	MenuPanelButton2:SetSize( 80, 30 )
	MenuPanelButton2:SetPos( MenuFrame:GetWide() / 2 - MenuPanelButton1:GetWide() / 2 + MenuPanelButton1:GetWide() / 2 + 5, 55 )
	MenuPanelButton2.DoClick = function( MenuPanelButton2 )
		MenuFrame:Close()
	end
	MenuPanelButton2:SetText( AWarn.localizations[loc].cl24 )
	MenuPanelButton2:SetTextColor( color_white )
	MenuPanelButton2:SetFont( 'Trebuchet24' )
	function MenuPanelButton2:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 10, 130, 255, 255 ) )
	end
end

function awarn_clientmenu()
	local intHeaderH = 30

	AWarn.ClientMenuFrame = vgui.Create( "DFrame" )
	AWarn.ClientMenuFrame:SetPos( ScrW() / 2 - 400, ScrH() / 2 - 300 )
	AWarn.ClientMenuFrame:SetSize( 800, 595 + intHeaderH )
	AWarn.ClientMenuFrame:SetTitle( "" )
	AWarn.ClientMenuFrame:SetVisible( true )
	AWarn.ClientMenuFrame:SetDraggable( true )
	AWarn.ClientMenuFrame:ShowCloseButton( true )
	AWarn.ClientMenuFrame:MakePopup()
	function AWarn.ClientMenuFrame:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 89, 125, 195, 200 ) )

		draw.SimpleText( "Casier Administratif", "Casier:AWarn:Font:Arial:45", 15, 5, color_white )
	end

	local MenuPanel = vgui.Create( "DPanel", AWarn.ClientMenuFrame )
	MenuPanel:SetPos( 10, 35 + intHeaderH )
	MenuPanel:SetSize( 780, 510 )
	MenuPanel.Paint = function() -- Paint function
		surface.SetDrawColor( Color( 15, 76, 180, 225 ) )
		surface.DrawRect( 0, 0, MenuPanel:GetWide(), MenuPanel:GetTall() ) -- Draw the rect
	end

	local MenuPanel2 = vgui.Create( "DPanel", AWarn.ClientMenuFrame )
	MenuPanel2:SetPos( 10, 550 + intHeaderH )
	MenuPanel2:SetSize( 780, 35 )
	MenuPanel2.Paint = function() -- Paint function
		surface.SetDrawColor( Color( 15, 76, 180, 225 ) )
		surface.DrawRect( 0, 0, MenuPanel2:GetWide(), MenuPanel2:GetTall() ) -- Draw the rect
	end

	local MenuPanel2Text1 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text1:SetPos( 5, 2 )
	MenuPanel2Text1:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text1:SetFont( "AWarnFont1" )
	MenuPanel2Text1:SetText( AWarn.localizations[loc].cl19 )
	MenuPanel2Text1:SizeToContents()

	AWarn.ClientMenuFrame.MenuPanel2Text2 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetPos( 180, 2 )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetColor( Color(255, 200, 200, 255) )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetFont( "AWarnFont1" )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SetText( "0" )
	AWarn.ClientMenuFrame.MenuPanel2Text2:SizeToContents()

	local MenuPanel2Text3 = vgui.Create( "DLabel", MenuPanel2 )
	MenuPanel2Text3:SetPos( 5, 17 )
	MenuPanel2Text3:SetColor( Color(255, 50, 50, 255) )
	MenuPanel2Text3:SetFont( "AWarnFont1" )
	MenuPanel2Text3:SetText( AWarn.localizations[loc].cl20 )
	MenuPanel2Text3:SizeToContents()

	AWarn.ClientMenuFrame.MenuPanel2Text4 = vgui.Create( "DLabel", MenuPanel2 )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetPos( 180, 17 )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetColor( Color(255, 200, 200, 255) )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetFont( "AWarnFont1" )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SetText( "0" )
	AWarn.ClientMenuFrame.MenuPanel2Text4:SizeToContents()

	AWarn.ClientMenuFrame.WarningsList = vgui.Create( "DListView", MenuPanel )
	AWarn.ClientMenuFrame.WarningsList:SetPos( 5, 5 )
	AWarn.ClientMenuFrame.WarningsList:SetSize( 770, 500 )
	AWarn.ClientMenuFrame.WarningsList:SetMultiSelect(false)
	AWarn.ClientMenuFrame.WarningsList:AddColumn(AWarn.localizations[loc].cl7):SetFixedWidth( 140 )
	AWarn.ClientMenuFrame.WarningsList:AddColumn(AWarn.localizations[loc].cl8)
	AWarn.ClientMenuFrame.WarningsList:AddColumn(AWarn.localizations[loc].cl10):SetFixedWidth( 100 )

	net.Start("awarn_fetchownwarnings")
	net.SendToServer()
end

function awarn_playerwarnmenu()
	local strSanction = ""

	local MenuFrame = vgui.Create( "DFrame" )
	MenuFrame:SetPos( ScrW() / 2 - 190, ScrH() / 2 - 85 )
	MenuFrame:SetSize( 380, 200 )
	MenuFrame:SetVisible( true )
	MenuFrame:SetDraggable( true )
	MenuFrame:ShowCloseButton( true )
	MenuFrame:MakePopup()
	MenuFrame:SetTitle( "" )
	function MenuFrame:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 15, 76, 180, 240 ) )
		draw.SimpleText( "Ajouter une entrée à : " .. AWarn.activeplayer, "Casier:AWarn:Font:Arial:19", 8, 5, color_white )
	end

	local MenuPanel = vgui.Create( "DPanel", MenuFrame )
	MenuPanel:SetPos( 5, 30 )
	MenuPanel:SetSize( 370, MenuFrame:GetTall() - 10 )
	MenuPanel.Paint = nil

	local HiddenLabel = vgui.Create( "DLabel", MenuPanel )
	HiddenLabel:SetPos( 0, 0 )
	HiddenLabel:SetColor( Color(255, 255, 255, 0) )
	HiddenLabel:SetFont( "AWarnFont1" )
	HiddenLabel:SetText( AWarn.activeplayer )
	HiddenLabel:SizeToContents()

	local MenuPanelLabel1 = vgui.Create( "DLabel", MenuPanel )
	MenuPanelLabel1:SetPos( 5, 5 )
	MenuPanelLabel1:SetColor( Color(255, 255, 255, 255) )
	MenuPanelLabel1:SetFont( "AWarnFont1" )
	MenuPanelLabel1:SetText( AWarn.localizations[loc].cl22 )
	MenuPanelLabel1:SizeToContents()

	local MenuPanelLabel2 = vgui.Create( "DLabel", MenuPanel )
	MenuPanelLabel2:SetPos( 120, 5 )
	MenuPanelLabel2:SetColor( Color(255, 20, 20, 255) )
	MenuPanelLabel2:SetFont( "AWarnFont1" )
	MenuPanelLabel2:SetText( HiddenLabel:GetText() )
	MenuPanelLabel2:SizeToContents()

	local MenuPanelLabel3 = vgui.Create( "DLabel", MenuPanel )
	MenuPanelLabel3:SetPos( 5, 25 )
	MenuPanelLabel3:SetColor( Color(255, 255, 255, 255) )
	MenuPanelLabel3:SetFont( "AWarnFont1" )
	MenuPanelLabel3:SetText( AWarn.localizations[loc].cl8 .. ":" )
	MenuPanelLabel3:SizeToContents()

	local MenuPanelTextEntry1 = vgui.Create( "DTextEntry", MenuPanel )
	MenuPanelTextEntry1:SetPos( 5, 80 )
	MenuPanelTextEntry1:SetMultiline( true )
	MenuPanelTextEntry1:SetSize( 360, 30 )

	local MenuPanelTextEntry1 = vgui.Create( "DComboBox", MenuPanel )
	MenuPanelTextEntry1:SetPos( 5, 45 )
	MenuPanelTextEntry1:SetSize( 360, 30 )
	for k,v in pairs( AWarn.Raisons or {} ) do
		if v['sanction'] == "ban" then
			MenuPanelTextEntry1:AddChoice( v['nom'] .. " ( " .. v['sanction'] .. " de " .. v['temps'] .. " minute(s) )", k )
		elseif v['sanction'] == "kick" then
			MenuPanelTextEntry1:AddChoice( v['nom'] .. " ( " .. v['sanction'] .. " )", k )
		else
			MenuPanelTextEntry1:AddChoice( v['nom'] .. " ( Avertissement )", k )
		end
	end
	MenuPanelTextEntry1.OnSelect = function( index, value, data )
		strSanction = MenuPanelTextEntry1:GetOptionData( value )
	end

	local MenuPanelButton1 = vgui.Create( "DButton", MenuPanel )
	MenuPanelButton1:SetSize( 80, 30 )
	MenuPanelButton1:SetPos( MenuFrame:GetWide() / 2 - MenuPanelButton1:GetWide() / 2 - MenuPanelButton1:GetWide() / 2 - 10, 125 )
	MenuPanelButton1.DoClick = function( MenuPanelButton1 )
		awarn_sendwarning( HiddenLabel:GetText(), MenuPanelTextEntry1:GetValue() )
		MenuFrame:Close()
	end
	MenuPanelButton1:SetText( AWarn.localizations[loc].cl23 )
	MenuPanelButton1:SetTextColor( color_white )
	MenuPanelButton1:SetFont( 'Trebuchet24' )
	function MenuPanelButton1:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 10, 130, 255, 255 ) )
	end
	function MenuPanelButton1:DoClick()
		net.Start( "Casier:Warn:Sanction" )
		net.WriteString( AWarn.activeplayer )
		net.WriteString( strSanction )
		net.WriteString( MenuPanelTextEntry1:GetValue() or "" )
		net.SendToServer()

		if IsValid( AWarn.MenuFrame ) then AWarn.MenuFrame:Remove() end
		MenuFrame:Remove()
	end

	local MenuPanelButton2 = vgui.Create( "DButton", MenuPanel )
	MenuPanelButton2:SetSize( 80, 30 )
	MenuPanelButton2:SetPos( MenuFrame:GetWide() / 2 - MenuPanelButton1:GetWide() / 2 + MenuPanelButton1:GetWide() / 2 + 5, 125 )
	MenuPanelButton2.DoClick = function( MenuPanelButton2 )
		MenuFrame:Close()
	end
	MenuPanelButton2:SetText( AWarn.localizations[loc].cl24 )
	MenuPanelButton2:SetTextColor( color_white )
	MenuPanelButton2:SetFont( 'Trebuchet24' )
	function MenuPanelButton2:Paint( w, h )
		draw.RoundedBox( 6, 0, 0, w, h, Color( 10, 130, 255, 255 ) )
	end
end

function awarn_optionsmenu()
	local MenuFrame = vgui.Create( "DFrame" )
	MenuFrame:SetPos( ScrW() / 2 - 205, ScrH() / 2 - 125 )
	MenuFrame:SetSize( 410, 225 )
	MenuFrame:SetVisible( true )
	MenuFrame:SetDraggable( true )
	MenuFrame:ShowCloseButton( true )
	MenuFrame:SetTitle( AWarn.localizations[loc].cl25 )
	MenuFrame:MakePopup()

	local MenuPanel = vgui.Create( "DPanel", MenuFrame )
	MenuPanel:SetPos( 5, 30 )
	MenuPanel:SetSize( 400, 190 )
	MenuPanel.Paint = function() -- Paint function
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.DrawRect( 0, 0, MenuPanel:GetWide(), MenuPanel:GetTall() ) -- Draw the rect
	end

	local MenuPanelCheckBox1 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox1:SetPos( 5, 5 )
	MenuPanelCheckBox1:SetText( AWarn.localizations[loc].cl26 )
	MenuPanelCheckBox1.Button.DoClick = function( MenuPanelCheckBox1 )
		local val = tostring(MenuPanelCheckBox1:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_kick")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox1.Think = function( MenuPanelCheckBox1 )
		if GetConVar("awarn_kick"):GetBool() ~= MenuPanelCheckBox1:GetChecked() then
			MenuPanelCheckBox1:SetValue( GetConVar("awarn_kick"):GetBool() )
		end
	end
	MenuPanelCheckBox1:SizeToContents()


	local MenuPanelCheckBox2 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox2:SetPos( 5, 25 )
	MenuPanelCheckBox2:SetText( AWarn.localizations[loc].cl27 )
	MenuPanelCheckBox2.Button.DoClick = function( MenuPanelCheckBox2 )
		local val = tostring(MenuPanelCheckBox2:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_ban")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox2.Think = function( MenuPanelCheckBox2 )
		if GetConVar("awarn_ban"):GetBool() ~= MenuPanelCheckBox2:GetChecked() then
			MenuPanelCheckBox2:SetValue( GetConVar("awarn_ban"):GetBool() )
		end
	end
	MenuPanelCheckBox2:SizeToContents()

	local MenuPanelCheckBox3 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox3:SetPos( 5, 45 )
	MenuPanelCheckBox3:SetText( AWarn.localizations[loc].cl28 )
	MenuPanelCheckBox3.Button.DoClick = function( MenuPanelCheckBox3 )
		local val = tostring(MenuPanelCheckBox3:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_decay")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox3.Think = function( MenuPanelCheckBox3 )
		if GetConVar("awarn_decay"):GetBool() ~= MenuPanelCheckBox3:GetChecked() then
			MenuPanelCheckBox3:SetValue( GetConVar("awarn_decay"):GetBool() )
		end
	end
	MenuPanelCheckBox3:SizeToContents()

	local MenuPanelCheckBox4 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox4:SetPos( 5, 65 )
	MenuPanelCheckBox4:SetText( AWarn.localizations[loc].cl29 )
	MenuPanelCheckBox4.Button.DoClick = function( MenuPanelCheckBox4 )
		local val = tostring(MenuPanelCheckBox4:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_reasonrequired")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox4.Think = function( MenuPanelCheckBox4 )
		if GetConVar("awarn_reasonrequired"):GetBool() ~= MenuPanelCheckBox4:GetChecked() then
			MenuPanelCheckBox4:SetValue( GetConVar("awarn_reasonrequired"):GetBool() )
		end
	end
	MenuPanelCheckBox4:SizeToContents()

	local MenuPanelCheckBox5 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox5:SetPos( 5, 85)
	MenuPanelCheckBox5:SetText( AWarn.localizations[loc].cl30 )
	MenuPanelCheckBox5.Button.DoClick = function( MenuPanelCheckBox5 )
		local val = tostring(MenuPanelCheckBox5:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_reset_warnings_after_ban")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox5.Think = function( MenuPanelCheckBox5 )
		if GetConVar("awarn_reset_warnings_after_ban"):GetBool() ~= MenuPanelCheckBox5:GetChecked() then
			MenuPanelCheckBox5:SetValue( GetConVar("awarn_reset_warnings_after_ban"):GetBool() )
		end
	end
	MenuPanelCheckBox5:SizeToContents()

	local MenuPanelCheckBox6 = vgui.Create( "DCheckBoxLabel", MenuPanel )
	MenuPanelCheckBox6:SetPos( 5, 105)
	MenuPanelCheckBox6:SetText( AWarn.localizations[loc].cl31 .. " (garrysmod/data/awarn2)" )
	MenuPanelCheckBox6.Button.DoClick = function( MenuPanelCheckBox6 )
		local val = tostring(MenuPanelCheckBox6:GetChecked())
		net.Start("awarn_changeconvarbool")
			net.WriteString("awarn_logging")
			net.WriteString( val )
		net.SendToServer()
	end
	MenuPanelCheckBox6.Think = function( MenuPanelCheckBox6 )
		if GetConVar("awarn_logging"):GetBool() ~= MenuPanelCheckBox6:GetChecked() then
			MenuPanelCheckBox6:SetValue( GetConVar("awarn_logging"):GetBool() )
		end
	end
	MenuPanelCheckBox6:SizeToContents()

	local MenuPanelSlider4 = vgui.Create( "DNumSlider", MenuPanel )
	MenuPanelSlider4:SetPos( 5, 130 )
	MenuPanelSlider4:SetSize( 390, 30 )
	MenuPanelSlider4:SetText( AWarn.localizations[loc].cl32 .. ": " )
	MenuPanelSlider4:SetMin( 0 )
	MenuPanelSlider4:SetMax( 43200 )
	MenuPanelSlider4:SetDark( false )
	MenuPanelSlider4:SetDecimals( 0 )
	MenuPanelSlider4.TextArea:SetDrawBackground( true )
	MenuPanelSlider4.TextArea:SetWide( 30 )
	MenuPanelSlider4.Label:SetWide(150)
	MenuPanelSlider4:SetValue( GetConVar("awarn_decay_rate"):GetInt() )
	MenuPanelSlider4.Think = function( MenuPanelSlider4 )

		if MenuPanelSlider4.Slider:GetDragging() then return end
		if ( AWarn.MenuThink or CurTime() ) > CurTime() then return end

		if MenuPanelSlider4.TextArea:GetValue() == "" then return end
		if tonumber(MenuPanelSlider4.TextArea:GetValue()) ~= GetConVar("awarn_decay_rate"):GetInt() then
			net.Start("awarn_changeconvar")
				net.WriteString("awarn_decay_rate")
				net.WriteInt( MenuPanelSlider4.TextArea:GetValue(), 32 )
			net.SendToServer()
			AWarn.MenuThink = CurTime() + 1
			return
		end
		if GetConVar("awarn_decay_rate"):GetInt() ~= MenuPanelSlider4:GetValue() then
			MenuPanelSlider4:SetValue( GetConVar("awarn_decay_rate"):GetInt() )
		end
	end

	local punishment_text = vgui.Create( "DLabel", MenuPanel )
	punishment_text:SetPos( 5, 160 )
	punishment_text:SetColor(Color(255,50,50,255))
	punishment_text:SetText(AWarn.localizations[loc].cl33)
	punishment_text:SizeToContents()

	local punishment_text2 = vgui.Create( "DLabel", MenuPanel )
	punishment_text2:SetPos( 5, 173 )
	punishment_text2:SetColor(Color(255,50,50,255))
	punishment_text2:SetText("addons/awarn2/lua/awarn/modules/awarn_settings.lua")
	punishment_text2:SizeToContents()


end


net.Receive("SendPlayerWarns", function(length )
	AWarn.playerinfo = net.ReadTable()
	AWarn.playerwarns = net.ReadInt( 32 )

	if ValidPanel( AWarn.MenuFrame ) then
		if AWarn.playerinfo then
			AWarn.MenuFrame.WarningsList:Clear()
			for k, v in pairs(AWarn.playerinfo) do
				if v.server == "NULL" then v.server = "UNKNOWN" end
				AWarn.MenuFrame.WarningsList:AddLine(v.pid, v.admin, v.reason, v.server, v.date)
			end
			AWarn.MenuFrame.WarningsList:SortByColumn( 3, true )
			AWarn.MenuFrame.MenuPanel2Text4:SetText( #AWarn.playerinfo )
			AWarn.MenuFrame.MenuPanel2Text4:SizeToContents()
		end

		if AWarn.playerwarns then
			AWarn.MenuFrame.MenuPanel2Text2:SetText( AWarn.playerwarns )
			AWarn.MenuFrame.MenuPanel2Text2:SizeToContents()
		end
	end
end)

net.Receive("SendOwnWarns", function(length )
	AWarn.ownplayerinfo = net.ReadTable()
	AWarn.ownplayerwarns = net.ReadInt( 32 )

	if ValidPanel( AWarn.ClientMenuFrame ) then
		if AWarn.ownplayerinfo then
			AWarn.ClientMenuFrame.WarningsList:Clear()
			for k, v in pairs(AWarn.ownplayerinfo) do
				AWarn.ClientMenuFrame.WarningsList:AddLine(v.admin, v.reason, v.date)
			end
			AWarn.ClientMenuFrame.WarningsList:SortByColumn( 3, true )
			AWarn.ClientMenuFrame.MenuPanel2Text4:SetText( #AWarn.ownplayerinfo )
			AWarn.ClientMenuFrame.MenuPanel2Text4:SizeToContents()
		end

		if AWarn.ownplayerwarns then
			AWarn.ClientMenuFrame.MenuPanel2Text2:SetText( AWarn.ownplayerwarns )
			AWarn.ClientMenuFrame.MenuPanel2Text2:SizeToContents()
		end
	end
end)

net.Receive("AWarnMenu", function(length )
	if not ValidPanel(AWarn.MenuFrame) then
		awarn_menu()
	end
end)

net.Receive("AWarnClientMenu", function(length )
	if not ValidPanel(AWarn.ClientMenuFrame) then
		awarn_clientmenu()
	end
end)

net.Receive("AWarnOptionsMenu", function(length )
	awarn_optionsmenu()
end)

net.Receive("AWarnNotification", function(length )
	local admin = net.ReadEntity()
	local target = net.ReadEntity()
	local reason = net.ReadString()
	local tarid = ""
	if target == game.GetWorld() then
		tarid = net.ReadString()
		if admin:EntIndex() == 0 then
			chat.AddText( Color(60,60,60), "[", Color(30,90,150), "Casier", Color(60,60,60), "] ", Color(255,255,255), "steamid ", Color(255,0,0), tarid,  Color(255,255,255), " " .. AWarn.localizations[loc].cl34 .. " ", Color(100,100,100), "[CONSOLE]", Color(255,255,255), ": ", Color(150,40,40), reason )
		else
			chat.AddText( Color(60,60,60), "[", Color(30,90,150), "Casier", Color(60,60,60), "] ", Color(255,255,255), "steamid ", Color(255,0,0), tarid,  Color(255,255,255), " " .. AWarn.localizations[loc].cl34 .. " ", admin, Color(255,255,255), ": ", Color(150,40,40), reason )
		end
	else
		if admin:EntIndex() == 0 then
			chat.AddText( Color(60,60,60), "[", Color(30,90,150), "Casier", Color(60,60,60), "] ", target, Color(255,255,255), " " .. AWarn.localizations[loc].cl34 .. " ", Color(100,100,100), "[CONSOLE]", Color(255,255,255), ": ", Color(150,40,40), reason )
		else
			chat.AddText( Color(60,60,60), "[", Color(30,90,150), "Casier", Color(60,60,60), "] ", target, Color(255,255,255), " " .. AWarn.localizations[loc].cl34 .. " ", admin, Color(255,255,255), ": ", Color(150,40,40), reason )
		end
	end
end)

net.Receive("AWarnNotification2", function(length )
	local admin = net.ReadEntity()
	local target = net.ReadString()
	local reason = net.ReadString()

    if admin:EntIndex() == 0 then
        chat.AddText( Color(60,60,60), "[", Color(30,90,150), "Casier", Color(60,60,60), "] ", Color(100,100,100), "[CONSOLE]", Color(255,255,255), " " .. AWarn.localizations[loc].cl35 .. " ", Color(255,0,0), target, Color(255,255,255), ": ", Color(150,40,40), reason )
    else
        chat.AddText( Color(60,60,60), "[", Color(30,90,150), "Casier", Color(60,60,60), "] ", admin, Color(255,255,255), " " .. AWarn.localizations[loc].cl35 .. " ", Color(255,0,0), target, Color(255,255,255), ": ", Color(150,40,40), reason )
    end
end)

net.Receive("AWarnChatMessage", function(length )
	local message = net.ReadTable()

	chat.AddText( unpack( message ) )
end)

function awarn_con_warn( ply, _, args )
    if #args < 1 then return end

	awarn_sendwarning( args[1], args[2] or nil )

end
concommand.Add( "awarn_warn", awarn_con_warn )

function awarn_sendwarning( tar, reason )

	if (string.sub(string.lower( tar ), 1, 5) == "steam") then
		if string.len( tar ) == 7 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: " .. AWarn.localizations[loc].cl36 )
		end
		tid = AWarn_ConvertSteamID( tar )
		net.Start( "awarn_warnid" )
			net.WriteString( tid )
			net.WriteString( reason )
		net.SendToServer()
		return
	end


	if awarn_getUser( tar ) then
		tar = awarn_getUser( tar )
		net.Start( "awarn_warn" )
			net.WriteEntity( tar )
			net.WriteString( reason )
		net.SendToServer()
	else
		LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: " .. AWarn.localizations[loc].cl37 )
	end
end

function awarn_removewarn( pl )
	print(pl)
	if (string.sub(string.lower( pl ), 1, 5) == "steam") then
		if string.len( pl ) == 7 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: " .. AWarn.localizations[loc].cl36 )
		end
		pl = AWarn_ConvertSteamID( pl )
		net.Start( "awarn_removewarnid" )
			net.WriteString( pl )
		net.SendToServer()
		return
	end

	net.Start( "awarn_removewarn" )
		net.WriteString( pl )
	net.SendToServer()
end

function awarn_con_delwarn( ply, _, args )
	if not (#args == 1) then return end
	awarn_deletewarnings( args[1] )
end
concommand.Add( "awarn_deletewarnings", awarn_con_delwarn )

function awarn_deletewarnings( pl )
	if (string.sub(string.lower( pl ), 1, 5) == "steam") then
		if string.len(pl) == 7 then
			LocalPlayer():PrintMessage( HUD_PRINTTALK, "AWarn: " .. AWarn.localizations[loc].cl36  )
		end
		pl = AWarn_ConvertSteamID( pl )
		net.Start( "awarn_deletewarningsid" )
			net.WriteString( pl )
		net.SendToServer()
		return
	end
	net.Start( "awarn_deletewarnings" )
		net.WriteString( pl )
	net.SendToServer()
end

function awarn_con_openmenu( ply, _, args )
	net.Start( "awarn_openmenu" )
	net.SendToServer()
end
concommand.Add( "awarn_menu", awarn_con_openmenu )

function awarn_con_openoptionsmenu( ply, _, args )
	net.Start( "awarn_openoptions" )
	net.SendToServer()
end
concommand.Add( "awarn_options", awarn_con_openoptionsmenu )

net.Receive( "Casier:Warn:Msg", function()
	local ent = net.ReadEntity()

	chat.AddText( Color( 255, 0, 0 ), "[NOTIFICATION] ", Color( 10, 130, 255, 255 ), "La Sanction sur le Joueur : ", Color( 255, 0, 0 ), ent:Nick(), Color( 10, 130, 255, 255 ), ", a bien été effectué" )
end)
