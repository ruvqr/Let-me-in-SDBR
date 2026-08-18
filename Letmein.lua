local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- LETMEIN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "LETMEIN"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(370, 500)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(65, 65, 75)
mainStroke.Transparency = 0.2
mainStroke.Thickness = 1
mainStroke.Parent = main

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 65)
header.BackgroundTransparency = 1
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 35)
title.Position = UDim2.fromOffset(18, 7)
title.BackgroundTransparency = 1
title.Text = "LETMEIN"
title.TextColor3 = Color3.fromRGB(245, 245, 250)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -70, 0, 20)
subtitle.Position = UDim2.fromOffset(19, 36)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Map repair utility"
subtitle.TextColor3 = Color3.fromRGB(135, 135, 145)
subtitle.TextSize = 11
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

--==================================================
-- CLOSE BUTTON
--==================================================

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38, 38)
close.Position = UDim2.new(1, -47, 0, 9)
close.BackgroundColor3 = Color3.fromRGB(34, 34, 41)
close.BorderSizePixel = 0
close.Text = "×"
close.TextColor3 = Color3.fromRGB(235, 235, 240)
close.TextSize = 25
close.Font = Enum.Font.GothamBold
close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = close

close.MouseEnter:Connect(function()
	close.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
end)

close.MouseLeave:Connect(function()
	close.BackgroundColor3 = Color3.fromRGB(34, 34, 41)
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then

		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- STATUS
--==================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -36, 0, 24)
status.Position = UDim2.new(0, 18, 1, -32)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(120, 200, 255)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local function setStatus(text, color)
	status.Text = text
	status.TextColor3 = color
end

--==================================================
-- BUTTON CONTAINER
--==================================================

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -36, 1, -125)
container.Position = UDim2.fromOffset(18, 73)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 3
container.ScrollBarImageTransparency = 0.4
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = container

--==================================================
-- BUTTON CREATOR
--==================================================

local function makeButton(text)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1, -2, 0, 56)
	button.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
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
		button.BackgroundColor3 = Color3.fromRGB(47, 47, 57)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	end)

	return button
end

--==================================================
-- RANDOM PART FINDER
--==================================================

local function getRandomPart(folder)

	local parts = {}

	for _, object in ipairs(folder:GetDescendants()) do
		if object:IsA("BasePart") then
			table.insert(parts, object)
		end
	end

	if #parts == 0 then
		return nil
	end

	return parts[math.random(1, #parts)]
end

--==================================================
-- UNIVERSAL FIX
--==================================================

local fixing = false

local function runFix(parentPath, targetName, displayName)

	if fixing then
		setStatus(
			"Another fix is already running...",
			Color3.fromRGB(255, 190, 90)
		)
		return
	end

	fixing = true

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not character or not root then
		setStatus(
			"Character not ready",
			Color3.fromRGB(255, 90, 90)
		)

		fixing = false
		return
	end

	-- Find parent
	local parent = workspace

	for _, name in ipairs(parentPath) do

		parent = parent:FindFirstChild(name)

		if not parent then
			setStatus(
				displayName .. " area not found",
				Color3.fromRGB(255, 90, 90)
			)

			fixing = false
			return
		end
	end

	-- Find target
	local target = parent:FindFirstChild(targetName)

	if not target then
		setStatus(
			targetName .. " not found",
			Color3.fromRGB(255, 90, 90)
		)

		fixing = false
		return
	end

	-- Save current position
	local oldCFrame = root.CFrame

	-- Pick a random physical object
	local randomPart = getRandomPart(target)

	if not randomPart then
		setStatus(
			"No physical objects found",
			Color3.fromRGB(255, 90, 90)
		)

		fixing = false
		return
	end

	setStatus(
		"Loading " .. displayName .. "...",
		Color3.fromRGB(255, 200, 90)
	)

	--==================================================
	-- TELEPORT TO RANDOM ITEM
	--==================================================

	root.CFrame = randomPart.CFrame + Vector3.new(0, 5, 0)

	-- Give streaming time
	task.wait(1)

	--==================================================
	-- RECHECK AFTER LOADING
	--==================================================

	setStatus(
		"Checking " .. targetName .. "...",
		Color3.fromRGB(255, 200, 90)
	)

	parent = workspace

	for _, name in ipairs(parentPath) do

		parent = parent:FindFirstChild(name)

		if not parent then
			setStatus(
				"Area failed to load",
				Color3.fromRGB(255, 90, 90)
			)

			root.CFrame = oldCFrame
			fixing = false
			return
		end
	end

	target = parent:FindFirstChild(targetName)

	-- Retry once
	if not target then

		setStatus(
			"Waiting for objects...",
			Color3.fromRGB(255, 200, 90)
		)

		task.wait(1.5)

		target = parent:FindFirstChild(targetName)
	end

	--==================================================
	-- DELETE TARGET
	--==================================================

	if target then

		target:Destroy()

		setStatus(
			displayName .. " fixed successfully",
			Color3.fromRGB(100, 220, 140)
		)

	else

		setStatus(
			targetName .. " could not be found",
			Color3.fromRGB(255, 90, 90)
		)
	end

	-- Return player
	task.wait(0.35)

	if character.Parent and root.Parent then
		root.CFrame = oldCFrame
	end

	fixing = false
end

--==================================================
-- BORDER FIX
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
-- BANK FIX
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
-- APARTMENT FIX
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
-- JEWELLERY FIX
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

--==================================================
-- REMOVE SPEED LIMIT
-- Workspace > GameRegions > BorderSpeedLimitRegion
--==================================================

local speedButton = makeButton("Remove Speed Limit")

speedButton.MouseButton1Click:Connect(function()

	runFix(
		{"GameRegions"},
		"BorderSpeedLimitRegion",
		"Speed Limit"
	)

end)

--==================================================
-- LOAD ALL AREAS
--
-- This ONLY teleports through GameRegions.
-- It does NOT delete anything.
-- Run this before the other fixes if needed.
--==================================================

local loadAreasButton = makeButton("Load All Areas")

loadAreasButton.MouseButton1Click:Connect(function()

	if fixing then

		setStatus(
			"Another operation is already running...",
			Color3.fromRGB(255, 190, 90)
		)

		return
	end

	fixing = true

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not character or not root then

		setStatus(
			"Character not ready",
			Color3.fromRGB(255, 90, 90)
		)

		fixing = false
		return
	end

	local regions = workspace:FindFirstChild("GameRegions")

	if not regions then

		setStatus(
			"GameRegions not found",
			Color3.fromRGB(255, 90, 90)
		)

		fixing = false
		return
	end

	-- Save starting position
	local oldCFrame = root.CFrame

	setStatus(
		"Preparing map...",
		Color3.fromRGB(255, 200, 90)
	)

	--==================================================
	-- BUILD REGION LIST
	--==================================================

	local regionParts = {}

	for _, region in ipairs(regions:GetChildren()) do

		local part = nil

		if region:IsA("BasePart") then

			part = region

		else

			for _, object in ipairs(region:GetDescendants()) do

				if object:IsA("BasePart") then

					part = object
					break

				end

			end
		end

		if part then

			table.insert(regionParts, {
				name = region.Name,
				part = part
			})

		end
	end

	--==================================================
	-- VISIT EVERY GAME REGION
	--==================================================

	for index, data in ipairs(regionParts) do

		setStatus(
			"Loading area "
				.. index
				.. "/"
				.. #regionParts
				.. " • "
				.. data.name,
			Color3.fromRGB(255, 200, 90)
		)

		if data.part and data.part.Parent then

			root.CFrame = data.part.CFrame + Vector3.new(0, 8, 0)

			task.wait(0.4)

		end
	end

	-- Final streaming wait
	setStatus(
		"Finishing map load...",
		Color3.fromRGB(255, 200, 90)
	)

	task.wait(1.5)

	--==================================================
	-- RETURN TO ORIGINAL LOCATION
	--==================================================

	if character.Parent and root.Parent then
		root.CFrame = oldCFrame
	end

	setStatus(
		"All areas loaded",
		Color3.fromRGB(100, 220, 140)
	)

	fixing = false
end)
