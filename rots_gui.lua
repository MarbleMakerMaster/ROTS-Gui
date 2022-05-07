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
local skills = {"No Skill", "Fire", "Explosive", "Lightning", "Ice", "Meteor", "Black Hole", "Plague", "Nuclear", "Random"}

local coinsAmount = 1000000

local rapidFire, keepBtool = false, false
local selectedBow = nil
local selectedSkill = 0
local selectedName = "Owner"
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
			local random = false

			if selectedSkill == "skill9" then
				selectedSkill = "skill"..tostring(math.random(1,8))
				random = true
			end

			if v:FindFirstChild("Inner") then
				localPlayer.Character.Bow.Shoot.RemoteEvent:FireServer(v.Inner.Position, selectedSkill)
			else
				localPlayer.Character.Bow.Shoot.RemoteEvent:FireServer(v:FindFirstChildOfClass("Part"), selectedSkill)
			end
			
			if random then
				selectedSkill = "skill9"
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
local build = player:addSection("Building")

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

build:addToggle("Keep Clone Tool", false, function(value)

end)

build:addToggle("Delete Anything (WIP)", false, function(value)

end)

build:addButton("Build Wall (WIP)", function()

end)

build:addButton("Build Turrets (WIP)", function()

end)

build:addButton("Trap Spawn (WIP)", function()

end)

-- new page
local keybinds = venyx:addPage("Keybinds", 5012544372)
local keybindsSection = keybinds:addSection("Keybinds")

keybindsSection:addKeybind("Toggle GUI", Enum.KeyCode.LeftControl, function()
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

local bbp = Instance.new("BodyPosition")
bbp.P = 100000

local function gettool(build)
	firetouchinterest(build.Handle, localPlayer.Character.Head, 0)
	firetouchinterest(build.Handle, localPlayer.Character.Head, 1)
	bbp.Parent = nil
end

local function droptool(build)
	bbp.Position = Vector3.new(build.Handle.Position.X, 20000, build.Handle.Position.Z)
	bbp.Parent = build.Handle

	build.Parent = localPlayer.Character
	wait()
	build.Parent = workspace
end

workspace.GameScript.Time.Changed:Connect(function()
	if keepBtool then
		if workspace.GameScript.Time.Value < 1 then
			local build = localPlayer.Backpack:FindFirstChild("Build") or localPlayer.Character:FindFirstChild("Build")

			if build then 	
				droptool(build)
				
				repeat wait() until workspace.GameScript.Time.Value > 1

				if localPlayer.Character.Head then
					gettool(build)
				else
					localPlayer.Character:WaitForChild("Head", math.huge)
					gettool(build)
				end
			end
		end
	end
end)

local function keepBtoolonDeath()
	localPlayer.Character:WaitForChild("Head")

	if keepBtool then
		local build = workspace:WaitForChild("Build")
		
		print(build)
		if build then
			gettool(build)
		end
	end

	localPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
		if keepBtool then
			local build = localPlayer.Backpack:FindFirstChild("Build") or localPlayer.Character:FindFirstChild("Build")

			if build then 
				droptool(build)
			end
		end
	end)
end

localPlayer.CharacterAdded:Connect(function()
	keepBtoolonDeath()
end)

keepBtoolonDeath()

spawn(function()
	while wait(rapidFireTime/1000) do
		if rapidFire then
			if localPlayer.Character:FindFirstChild("Bow") then
				if selectedSkill ~= nil then
					local random = false
					
					if selectedSkill == "skill9" then
						selectedSkill = "skill"..tostring(math.random(1,8))
						random = true
					end
					
					localPlayer.Character:FindFirstChild("Bow").Shoot.RemoteEvent:FireServer(mouse.Hit.p, selectedSkill);
					
					if random then
						selectedSkill = "skill9"
					end
				end
			end
		end
	end
end)
