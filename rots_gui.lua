-- init
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Revenge of the Slimes GUI", 5013109572)

-- vars
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()
local changeValue = workspace.ChangeValue
local purchase = workspace.DoShopPurchase

local slimeTheme = {
	Background = Color3.fromRGB(3, 10, 6),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(35, 91, 49),
	LightContrast = Color3.fromRGB(9, 27, 17),
	DarkContrast = Color3.fromRGB(21, 53, 31),  
	TextColor = Color3.fromRGB(255, 255, 255)
}

local darkTheme = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),  
	TextColor = Color3.fromRGB(255, 255, 255)
}

local gear = {
	"GravityCoil",
	"Bloxiade",
	"SoccerBall",
	"Acceleration Coil",
	"AviatorWatch", 
	"Fake Bomb", 
	"GigantoformPotion",
	"AmazingShrinkingElixir",
	"SegwayHoverboard",
	"ROBLOXUMoped", 
	"ROBLOXSkateboard", 
	"TBCSkateboard",
	"BearTrap",
	"Caltrops",
	"MineBomb",
	"R80",
	"SpikeGrenade"
}
local skills = {"No Skill", "Fire", "Explosive", "Lightning", "Ice", "Meteor", "Black Hole", "Plague", "Nuclear"}

local coinsAmount = 1000000

local selectedBow = nil
local selectedSkill = 0
local selectedName = "Owner"
local rapidFire = false
local rapidFireTime = 80

local function reset()
	localPlayer.Character.Humanoid.Name = 1
	local l = localPlayer.Character["1"]:Clone()
	l.Parent = localPlayer.Character
	l.Name = "Humanoid"
	wait()
	localPlayer.Character["1"]:Destroy()
	game.Workspace.CurrentCamera.CameraSubject = localPlayer.Character
	localPlayer.Character.Animate.Disabled = true
	wait()
	localPlayer.Character.Animate.Disabled = false
	localPlayer.Character.Humanoid.DisplayDistanceType = "None"
	wait()
	local prt = Instance.new("Model", workspace);
	Instance.new("Part", prt).Name="Torso";
	Instance.new("Part", prt).Name="Head";
	Instance.new("Humanoid", prt).Name="Humanoid";
	localPlayer.Character=prt
end

local function shootSlimes()
	if workspace:FindFirstChild("Slimes") and localPlayer.Character:FindFirstChild("Bow") then
		for i,v in pairs(workspace.Slimes:GetChildren()) do
			if v:FindFirstChild("Inner") then
				localPlayer.Character.Bow.Shoot.RemoteEvent:FireServer(v.Inner.Position, selectedSkill)
			else
				localPlayer.Character.Bow.Shoot.RemoteEvent:FireServer(v:FindFirstChildOfClass("Part"), selectedSkill)
			end
		end
	end
end

-- new page
local give = venyx:addPage("Give", 5012544092)
local bow = give:addSection("Bows")
local coins = give:addSection("Coins")
local tools = give:addSection("Gears")

--BOW GIVER
bow:addDropdown("Bow Type...", {"Thunder Bow","Meteor Bow","Tornado Bow","Mr.Cube Bow"}, function(text)
	selectedBow = tostring(text)
end)

bow:addButton("Give Bow", function()
	if selectedBow then
		if localPlayer:FindFirstChild(selectedBow) ~= nil then
			changeValue:InvokeServer(localPlayer:FindFirstChild(selectedBow), true)
		end
	end
end)

--COINS GIVER
coins:addSlider("Coins Amount", 1000000, 0, 2^63-1, function(value)
	coinsAmount = tonumber(value)
end)

coins:addButton("Add Coins", function()
	purchase:InvokeServer(localPlayer.leaderstats.Coins, -coinsAmount)
end)

coins:addButton("Set Coins", function()
	purchase:InvokeServer(localPlayer.leaderstats.Coins, (localPlayer.leaderstats.Coins.Value-coinsAmount))
end)

--GEAR GIVER
for i = 1, #gear do
	local selectedGear = gear[i]
	tools:addButton(selectedGear, function()
		local chest
		if table.find(gear, selectedGear) < 9 then
			chest = "Chest1"
		elseif table.find(gear, selectedGear) < 13 then
			chest = "Chest2"
		else
			chest = "Chest3"
		end
		purchase:InvokeServer(localPlayer.leaderstats.Coins, 0, chest, selectedGear)
	end)
end


-- new page
local player = venyx:addPage("Player", 5012544092)
local bowMods = player:addSection("Bow Mods")
local nametag = player:addSection("Nametag")

--BOW MODS
bowMods:addDropdown("Skill Type...", skills, function(text)
	selectedSkill = "skill"..tostring(table.find(skills, tostring(text))-1)
end)

bowMods:addSlider("Rapid Fire Delay (ms)", 80, 30, 1000, function(value)
	rapidFireTime = tonumber(value)
end)

bowMods:addToggle("Rapid Fire", false, function(value)
	rapidFire = value
end)

bowMods:addButton("Shoot All Slimes", function()
	shootSlimes()
end)

--NAMETAG
nametag:addTextbox("Nametag Text", "Owner", function(value, focusLost)
	selectedName = tostring(value)
end)

nametag:addButton("Change Nametag (KILLS YOU!)", function()
	changeValue:InvokeServer(localPlayer.GroupRoll, selectedName)
	reset()
end)



-- new page
local keybinds = venyx:addPage("Keybinds", 5012544372)
local keybindsSection = keybinds:addSection("Keybinds")

keybindsSection:addKeybind("Toggle GUI", Enum.KeyCode.Delete, function()
	venyx:toggle()
end, function()

end)

keybindsSection:addKeybind("Toggle Rapid Fire", Enum.KeyCode.Q, function()
	if rapidFire then
		rapidFire = false
	else
		rapidFire = true
	end
	bowMods:updateToggle("Rapid Fire", "Rapid Fire", rapidFire)
end, function()

end)

keybindsSection:addKeybind("Shoot All Slimes", Enum.KeyCode.E, function()
	shootSlimes()
end, function()

end)



-- new page
local theme = venyx:addPage("Theme", 5012544944)
local colors = theme:addSection("Colors")
local themes = theme:addSection("Themes")

for theme, color in pairs(slimeTheme) do
	colors:addColorPicker(theme, color, function(color3)
		venyx:setTheme(theme, color3)
	end)
end

local function recolor(stheme)
	for theme, color in pairs(stheme) do
		venyx:setTheme(theme, color)
		colors:updateColorPicker(tostring(theme), tostring(theme), color)
	end
end

recolor(slimeTheme)

themes:addButton("Slime Green (Default)", function()
	recolor(slimeTheme)
end)

themes:addButton("Dark", function()
	recolor(darkTheme)
end)

-- new page
local credits = venyx:addPage("Credits", 5012544693)
credits:addSection("Venyx UI Library - Denosaur\nSimpleSpy - TheUNBAnmAn\nGUI MADE BY coolguytri2/MarbleMakerMaster")

local links = credits:addSection("Links")

links:addButton("Venyx UI Link", function()
	setclipboard("https://v3rmillion.net/showthread.php?tid=1026479")
end)

links:addButton("SimpleSpy Link", function()
	setclipboard("https://v3rmillion.net/showthread.php?tid=940660")
end)



-- load
venyx:SelectPage(venyx.pages[1], true)

while wait(rapidFireTime/1000) do
	if rapidFire then
		if localPlayer.Character:FindFirstChild("Bow") then
			if selectedSkill ~= nil then
				localPlayer.Character:FindFirstChild("Bow").Shoot.RemoteEvent:FireServer(mouse.Hit.p, selectedSkill);
			end
		end
	end
end
