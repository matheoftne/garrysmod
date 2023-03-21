surface.CreateFont("Frame_Font1", {
	font = "comfortaa",
	size = Lib.RespX(40),
	weight = 500,
	antialias = true,
})
surface.CreateFont("Frame_Font2", {
	font = "comfortaa",
	size = Lib.RespX(60),
	weight = 500,
	antialias = true,
	extended = true,
})
surface.CreateFont("Frame_Font3", {
	font = "comfortaa",
	size = Lib.RespX(15),
	weight = 200,
	antialias = true,
})

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
	self:MakePopup()
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	
	self.title = ""
end

function PANEL:SetRPos(x, y)
	self:SetPos(Lib.RespX(x), Lib.RespY(y))
end

function PANEL:SetRSize(x, y)
	self:SetSize(Lib.RespX(x), Lib.RespY(y))
end

function PANEL:SetLibTitle(str)
	self.title = str
end

function PANEL:CloseButton(bool)
	if isbool(bool) && bool then

		local closeButton = vgui.Create("DImageButton", self)
		closeButton:SetSize(Lib.RespX(20), Lib.RespY(20))
		closeButton:SetPos(self:GetWide()-closeButton:GetWide()-Lib.RespX(5), Lib.RespY(5))
		closeButton:SetText("")
		closeButton:SetImage("icon16/cross.png")
		closeButton.DoClick = function()
			if IsValid(self) then
				self:Remove()
			end
		end

	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(69, 69, 69, 255))
	
	surface.SetDrawColor(color_white)
	surface.DrawLine(Lib.RespX(50), Lib.RespY(65), w-Lib.RespX(50), Lib.RespY(65))
	
	draw.SimpleText(self.title, "Frame_Font2", w/2, 0, color_white, 1, 3)
end

derma.DefineControl("AS_DFrame", " AS DFrame", PANEL, "DFrame")