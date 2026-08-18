local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "MapFixesGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(360, 360)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(65, 65, 75)
mainStroke.Transparency = 0.25
mainStroke.Parent = main

--==================================================
-- Header
--==================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 40)
title.Position = UDim2.fromOffset(18, 7)
title.BackgroundTransparency = 1
title.Text = "Let me in"
title.TextColor3 = Color3.fromRGB(245, 245, 250)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -36, 0, 20)
subtitle.Position = UDim2.fromOffset(18, 42)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Select a repair to load and fix the area"
subtitle.TextColor3 = Color3.fromRGB(145, 145, 155)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

--==================================================
-- Close button
--==================================================

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38, 38)
close.Position = UDim2.new(1, -46, 0, 6)
close.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
close.BorderSizePixel = 0
close.Text = "×"
close.TextColor3 = Color3.fromRGB(235, 235, 240)
close.TextSize = 25
close.Font = Enum.Font.GothamBold
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = close

close.MouseEnter:Connect(function()
	close.BackgroundColor3 = Color3.fromRGB(175, 55, 55)
end)

close.MouseLeave:Connect(function()
	close.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--==================================================
-- Status
--==================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -36, 0, 25)
status.Position = UDim2.new(0, 18, 1, -34)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(130, 200, 255)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local function setStatus(text, color)
	status.Text = text
	status.TextColor3 = color
end

--==================================================
-- Button container
--==================================================

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -36, 0, 275)
container.Position = UDim2.fromOffset(18, 72)
container.BackgroundTransparency = 1
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = container

--==================================================
-- Button creator
--==================================================

local function makeButton(text)
	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1, 0, 0, 54)
	button.BackgroundColor3 = Color3.fromRGB(34, 34, 42)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(235, 235, 240)
	button.TextSize = 15
	button.Font = Enum.Font.GothamMedium
	button.AutoButtonColor = false
	button.Parent = container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(60, 60, 70)
	stroke.Transparency = 0.35
	stroke.Parent = button

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(34, 34, 42)
	end)

	return button
end

--==================================================
-- Universal failsafe
--==================================================

local fixing = false

local function runFix(areaPath, folderName, displayName)
	if fixing then
		setStatus("A fix is already running...", Color3.fromRGB(255, 190, 90))
		return
	end

	fixing = true

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not character or not root then
		setStatus("Character not ready", Color3.fromRGB(255, 90, 90))
		fixing = false
		return
	end

	-- Find the area
	local area = workspace

	for _, name in ipairs(areaPath) do
		area = area:FindFirstChild(name)

		if not area then
			setStatus(displayName .. " area not found", Color3.fromRGB(255, 90, 90))
			fixing = false
			return
		end
	end

	-- Save position
	local oldCFrame = root.CFrame

	setStatus("Loading " .. displayName .. "...", Color3.fromRGB(255, 200, 90))

	-- Get the area position
	local success, areaCFrame = pcall(function()
		local cf = area:GetBoundingBox()
		return cf
	end)

	if not success or not areaCFrame then
		setStatus("Couldn't locate " .. displayName, Color3.fromRGB(255, 90, 90))
		fixing = false
		return
	end

	--==================================================
	-- FAILSAFE TELEPORT
	--==================================================

	root.CFrame = areaCFrame + Vector3.new(0, 8, 0)

	-- Allow StreamingEnabled objects to load
	task.wait(1)

	-- Check again
	local target = area:FindFirstChild(folderName)

	if not target then
		setStatus("Waiting for objects to load...", Color3.fromRGB(255, 200, 90))

		-- Extra loading time
		task.wait(1.5)

		target = area:FindFirstChild(folderName)
	end

	-- One final check
	if target then
		target:Destroy()

		setStatus(displayName .. " fixed successfully", Color3.fromRGB(100, 220, 140))
	else
		setStatus(folderName .. " wasn't loaded/found", Color3.fromRGB(255, 90, 90))
	end

	-- Return player
	task.wait(0.35)

	if character.Parent and root.Parent then
		root.CFrame = oldCFrame
	end

	fixing = false
end

--==================================================
-- Border Fix
-- Workspace > Map > Static > Global > Gates
--==================================================

local borderButton = makeButton("Border Fixes")

borderButton.MouseButton1Click:Connect(function()
	runFix(
		{"Map", "Static", "Global"},
		"Gates",
		"Border"
	)
end)

--==================================================
-- Bank Fix
-- Workspace > Bank > Building > Doors
--==================================================

local bankButton = makeButton("Bank Fixes")

bankButton.MouseButton1Click:Connect(function()
	runFix(
		{"Bank", "Building"},
		"Doors",
		"Bank"
	)
end)

--==================================================
-- Apartment Fix
-- Workspace > Apartments > Doors
--==================================================

local apartmentButton = makeButton("Apartment Fix")

apartmentButton.MouseButton1Click:Connect(function()
	runFix(
		{"Apartments"},
		"Doors",
		"Apartment"
	)
end)

--==================================================
-- Jewellery Fix
-- Workspace > JewelleryStore > Doors
--==================================================

local jewelleryButton = makeButton("Jewellery Fix")

jewelleryButton.MouseButton1Click:Connect(function()
	runFix(
		{"JewelleryStore"},
		"Doors",
		"Jewellery"
	)
end)