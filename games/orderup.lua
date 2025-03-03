local hwiduserlist = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/HWID/refs/heads/main/91722389y2189hikoasu9e2e0109238912y38921891289178931289218942894289423894729856893215892135893168568915893465986589235.lua"))()
local clientId = game:GetService("RbxAnalyticsService"):GetClientId()

-- Check if the client ID is in the whitelist
local isAuthorized = false
for _, hwid in pairs(hwiduserlist) do
    if clientId == hwid then
        isAuthorized = true
        break
    end
end

if isAuthorized then
    
local player = game:GetService("Players").LocalPlayer
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local debris = game:GetService("Debris")

-- ✨ Visual Enhancement Settings ✨
local COLORS = {
    BACKGROUND = Color3.fromRGB(20, 20, 32),
    HEADER = Color3.fromRGB(30, 30, 55),
    ACCENT1 = Color3.fromRGB(140, 90, 255), -- Vibrant Purple
    ACCENT2 = Color3.fromRGB(90, 210, 255), -- Bright Cyan
    GOLD = Color3.fromRGB(255, 230, 30),
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
    TEXT_SECONDARY = Color3.fromRGB(200, 200, 240),
    LEVEL_COLOR = Color3.fromRGB(255, 235, 70),
    MONEY_COLOR = Color3.fromRGB(70, 255, 140),
}

-- Create the main ScreenGui with enhanced properties
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodlyStatsUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Enabled = false

-- Create the main frame with enhanced styling
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 140)
mainFrame.Position = UDim2.new(0.02, 0, 0.08, 0)
mainFrame.BackgroundColor3 = COLORS.BACKGROUND
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add stylized rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = mainFrame

-- Add animated gradient with enhanced colors
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.BACKGROUND),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 65)),
    ColorSequenceKeypoint.new(1, COLORS.BACKGROUND)
})
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Add outer glow effect
local outerGlow = Instance.new("UIStroke")
outerGlow.Color = COLORS.ACCENT1
outerGlow.Thickness = 3
outerGlow.Transparency = 0.6
outerGlow.Parent = mainFrame

-- Create header with cosmic design
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 36)
headerFrame.BackgroundColor3 = COLORS.HEADER
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

-- Add rounded corners to header
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = headerFrame

-- Add header accent line
local headerAccent = Instance.new("Frame")
headerAccent.Name = "HeaderAccent"
headerAccent.Size = UDim2.new(0.9, 0, 0, 3)
headerAccent.Position = UDim2.new(0.05, 0, 0.9, 0)
headerAccent.BackgroundColor3 = COLORS.ACCENT1
headerAccent.BorderSizePixel = 0
headerAccent.Parent = headerFrame

-- Add header gradient
local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.ACCENT1),
    ColorSequenceKeypoint.new(0.5, COLORS.ACCENT2),
    ColorSequenceKeypoint.new(1, COLORS.ACCENT1)
})
headerGradient.Parent = headerAccent

-- Add title text with enhanced styling
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
titleLabel.Text = "⚡ PLAYER STATS ⚡"
titleLabel.Font = Enum.Font.Bangers
titleLabel.TextColor3 = COLORS.TEXT_PRIMARY
titleLabel.TextSize = 22
titleLabel.Parent = headerFrame

-- Add glow effect to title
local titleGlow = Instance.new("UIStroke")
titleGlow.Color = COLORS.ACCENT2
titleGlow.Thickness = 1.5
titleGlow.Transparency = 0.5
titleGlow.Parent = titleLabel

-- Create level display with enhanced visuals
local levelFrame = Instance.new("Frame")
levelFrame.Name = "LevelFrame"
levelFrame.Size = UDim2.new(0.92, 0, 0, 38)
levelFrame.Position = UDim2.new(0.04, 0, 0.33, 0)
levelFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
levelFrame.BorderSizePixel = 0
levelFrame.Parent = mainFrame

-- Add rounded corners to level frame
local levelCorner = Instance.new("UICorner")
levelCorner.CornerRadius = UDim.new(0, 12)
levelCorner.Parent = levelFrame

-- Add level frame gradient
local levelFrameGradient = Instance.new("UIGradient")
levelFrameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 65))
})
levelFrameGradient.Rotation = 90
levelFrameGradient.Parent = levelFrame

-- Add level icon with pulse effect
local levelIcon = Instance.new("ImageLabel")
levelIcon.Name = "LevelIcon"
levelIcon.Size = UDim2.new(0, 28, 0, 28)
levelIcon.BackgroundTransparency = 1
levelIcon.AnchorPoint = Vector2.new(0, 0.5)
levelIcon.Position = UDim2.new(0.05, 0, 0.5, 0)
levelIcon.Image = "rbxassetid://7733715400" -- Star icon
levelIcon.ImageColor3 = COLORS.LEVEL_COLOR
levelIcon.Parent = levelFrame

-- Add level text label with Bangers font
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Size = UDim2.new(0, 70, 0, 30)
levelLabel.BackgroundTransparency = 1
levelLabel.AnchorPoint = Vector2.new(0, 0.5)
levelLabel.Position = UDim2.new(0.18, 0, 0.5, 0)
levelLabel.Text = "LEVEL:"
levelLabel.Font = Enum.Font.Bangers
levelLabel.TextColor3 = COLORS.TEXT_SECONDARY
levelLabel.TextSize = 20
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = levelFrame

-- Create container for level value with fixed positioning
local levelValueContainer = Instance.new("Frame")
levelValueContainer.Name = "LevelValueContainer"
levelValueContainer.Size = UDim2.new(0, 100, 0, 30)
levelValueContainer.AnchorPoint = Vector2.new(1, 0.5)
levelValueContainer.Position = UDim2.new(0.95, 0, 0.5, 0)
levelValueContainer.BackgroundTransparency = 1
levelValueContainer.ClipsDescendants = true
levelValueContainer.Parent = levelFrame

-- Add level value label with enhanced styling and proper anchoring
local levelValue = Instance.new("TextLabel")
levelValue.Name = "LevelValue"
levelValue.Size = UDim2.new(1, 0, 1, 0)
levelValue.Position = UDim2.new(0, 0, 0, 0)
levelValue.BackgroundTransparency = 1
levelValue.AnchorPoint = Vector2.new(1, 0.5)
levelValue.Position = UDim2.new(1, 0, 0.5, 0)
levelValue.Text = "0"
levelValue.Font = Enum.Font.Bangers
levelValue.TextColor3 = COLORS.LEVEL_COLOR
levelValue.TextSize = 26
levelValue.TextXAlignment = Enum.TextXAlignment.Right
levelValue.Parent = levelValueContainer

-- Add glow to level value
local levelValueGlow = Instance.new("UIStroke")
levelValueGlow.Color = COLORS.LEVEL_COLOR
levelValueGlow.Thickness = 1.2
levelValueGlow.Transparency = 0.6
levelValueGlow.Parent = levelValue

-- Create money display with enhanced visuals
local moneyFrame = Instance.new("Frame")
moneyFrame.Name = "MoneyFrame"
moneyFrame.Size = UDim2.new(0.92, 0, 0, 38)
moneyFrame.Position = UDim2.new(0.04, 0, 0.65, 0)
moneyFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
moneyFrame.BorderSizePixel = 0
moneyFrame.Parent = mainFrame

-- Add rounded corners to money frame
local moneyCorner = Instance.new("UICorner")
moneyCorner.CornerRadius = UDim.new(0, 12)
moneyCorner.Parent = moneyFrame

-- Add money frame gradient
local moneyFrameGradient = Instance.new("UIGradient")
moneyFrameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 65))
})
moneyFrameGradient.Rotation = 90
moneyFrameGradient.Parent = moneyFrame

-- Add money icon with glow
local moneyIcon = Instance.new("ImageLabel")
moneyIcon.Name = "MoneyIcon"
moneyIcon.Size = UDim2.new(0, 28, 0, 28)
moneyIcon.AnchorPoint = Vector2.new(0, 0.5)
moneyIcon.Position = UDim2.new(0.05, 0, 0.5, 0)
moneyIcon.BackgroundTransparency = 1
moneyIcon.Image = "rbxassetid://7734053495" -- Coin icon
moneyIcon.ImageColor3 = COLORS.MONEY_COLOR
moneyIcon.Parent = moneyFrame

-- Add money text label with Bangers font
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(0, 70, 0, 30)
moneyLabel.AnchorPoint = Vector2.new(0, 0.5)
moneyLabel.Position = UDim2.new(0.18, 0, 0.5, 0)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "MONEY:"
moneyLabel.Font = Enum.Font.Bangers
moneyLabel.TextColor3 = COLORS.TEXT_SECONDARY
moneyLabel.TextSize = 20
moneyLabel.TextXAlignment = Enum.TextXAlignment.Left
moneyLabel.Parent = moneyFrame

-- Create container for money value with fixed positioning
local moneyValueContainer = Instance.new("Frame")
moneyValueContainer.Name = "MoneyValueContainer"
moneyValueContainer.Size = UDim2.new(0, 100, 0, 30)
moneyValueContainer.AnchorPoint = Vector2.new(1, 0.5)
moneyValueContainer.Position = UDim2.new(0.95, 0, 0.5, 0)
moneyValueContainer.BackgroundTransparency = 1
moneyValueContainer.ClipsDescendants = true
moneyValueContainer.Parent = moneyFrame

-- Add money value label with enhanced styling and proper anchoring
local moneyValue = Instance.new("TextLabel")
moneyValue.Name = "MoneyValue"
moneyValue.Size = UDim2.new(1, 0, 1, 0)
moneyValue.Position = UDim2.new(0, 0, 0, 0)
moneyValue.BackgroundTransparency = 1
moneyValue.AnchorPoint = Vector2.new(1, 0.5)
moneyValue.Position = UDim2.new(1, 0, 0.5, 0)
moneyValue.Text = "$0"
moneyValue.Font = Enum.Font.Bangers
moneyValue.TextColor3 = COLORS.MONEY_COLOR
moneyValue.TextSize = 26
moneyValue.TextXAlignment = Enum.TextXAlignment.Right
moneyValue.Parent = moneyValueContainer

-- Add glow to money value
local moneyValueGlow = Instance.new("UIStroke")
moneyValueGlow.Color = COLORS.MONEY_COLOR
moneyValueGlow.Thickness = 1.2
moneyValueGlow.Transparency = 0.6
moneyValueGlow.Parent = moneyValue

-- Add enhanced drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Size = UDim2.new(1, 36, 1, 36)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Create particle effects container
local particleContainer = Instance.new("Frame")
particleContainer.Name = "ParticleContainer"
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.ClipsDescendants = true
particleContainer.Parent = mainFrame

-- Function to format numbers with K, M, B notation
local function formatNumber(number)
    if number >= 1000000000 then
        return string.format("%.1fB", number / 1000000000)
    elseif number >= 1000000 then
        return string.format("%.1fM", number / 1000000)
    elseif number >= 1000 then
        return string.format("%.1fK", number / 1000)
    else
        return tostring(number)
    end
end

-- Enhanced pulse animation with multiple effects when values change
local function pulseAnimation(valueLabel, oldValue, newValue)
    if tonumber(newValue) > tonumber(oldValue) then
        -- Create vibrant animation clone
        local animClone = valueLabel:Clone()
        animClone.Parent = valueLabel.Parent
        animClone.ZIndex = valueLabel.ZIndex + 1
        animClone.TextTransparency = 0
        
        -- Add shine effect
        local shine = Instance.new("Frame")
        shine.Size = UDim2.new(0.05, 0, 2, 0)
        shine.BackgroundColor3 = Color3.new(1, 1, 1)
        shine.BackgroundTransparency = 0.6
        shine.BorderSizePixel = 0
        shine.ZIndex = valueLabel.ZIndex + 2
        shine.Rotation = 45
        shine.Position = UDim2.new(-0.1, 0, -0.5, 0)
        shine.Parent = valueLabel.Parent
        
        -- Animate the shine
        tweenService:Create(
            shine,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(1.1, 0, -0.5, 0),
                BackgroundTransparency = 1
            }
        ):Play()
        
        -- Animate the value clone
        local upTween = tweenService:Create(
            animClone,
            TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(1, 0, -0.7, 0),
                TextTransparency = 1,
                TextSize = valueLabel.TextSize * 1.5
            }
        )
        
        upTween:Play()
        
        -- Remove clones after animation
        upTween.Completed:Connect(function()
            animClone:Destroy()
            shine:Destroy()
        end)
        
        -- Create number increment particles
        local difference = tonumber(newValue) - tonumber(oldValue)
        local incrementText = "+"
        if difference >= 1000000000 then
            incrementText = incrementText..string.format("%.1fB", difference / 1000000000)
        elseif difference >= 1000000 then
            incrementText = incrementText..string.format("%.1fM", difference / 1000000)
        elseif difference >= 1000 then
            incrementText = incrementText..string.format("%.1fK", difference / 1000)
        else
            incrementText = incrementText..tostring(difference)
        end
        
        local incrementLabel = Instance.new("TextLabel")
        incrementLabel.Size = UDim2.new(0, 100, 0, 20)
        incrementLabel.Position = UDim2.new(0.9, 0, 0.5, 0)
        incrementLabel.AnchorPoint = Vector2.new(1, 0.5)
        incrementLabel.BackgroundTransparency = 1
        incrementLabel.Font = Enum.Font.Bangers
        incrementLabel.TextColor3 = Color3.new(1, 1, 0.5)
        incrementLabel.TextSize = 18
        incrementLabel.Text = incrementText
        incrementLabel.TextXAlignment = Enum.TextXAlignment.Right
        incrementLabel.Parent = valueLabel.Parent
        
        -- Animate increment label
        tweenService:Create(
            incrementLabel,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Position = UDim2.new(0.9, 0, 0, 0),
                TextTransparency = 1
            }
        ):Play()
        
        debris:AddItem(incrementLabel, 0.6)
        
        -- Enhanced shake effect on the original
        local originalPos = valueLabel.Position
        local shake = {
            UDim2.new(1, 2, 0.5, 0),
            UDim2.new(1, -2, 0.5, 1),
            UDim2.new(1, 1, 0.5, -1),
            UDim2.new(1, -1, 0.5, -2),
            UDim2.new(1, 2, 0.5, 2),
            UDim2.new(1, 0, 0.5, 0)
        }
        
        spawn(function()
            for i = 1, #shake do
                valueLabel.Position = shake[i]
                wait(0.02)
            end
            valueLabel.Position = originalPos
        end)
        
        -- Flash effect on the container
        local originalColor = valueLabel.TextColor3
        valueLabel.TextColor3 = Color3.new(1, 1, 1)
        wait(0.05)
        valueLabel.TextColor3 = originalColor
    end
end

-- Function to update the UI with player values
local prevLevel = 0
local prevMoney = 0
local function updateUI()
    if player and player:FindFirstChild("Values") then
        local values = player.Values
        
        if values:FindFirstChild("Level") and values:FindFirstChild("Money") then
            local currentLevel = values.Level.Value
            local currentMoney = values.Money.Value
            
            -- Format the values for display
            local formattedLevel = formatNumber(currentLevel)
            local formattedMoney = "$" .. formatNumber(currentMoney)
            
            -- Update the display
            levelValue.Text = formattedLevel
            moneyValue.Text = formattedMoney
            
            -- Check if values have changed and animate
            if currentLevel ~= prevLevel then
                pulseAnimation(levelValue, prevLevel, currentLevel)
                prevLevel = currentLevel
            end
            
            if currentMoney ~= prevMoney then
                pulseAnimation(moneyValue, prevMoney, currentMoney)
                prevMoney = currentMoney
            end
        end
    end
end

-- Enhanced draggable frame with smooth transitions
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function update(input)
    local delta = input.Position - dragStart
    local targetPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    
    -- Smooth tween for dragging
    tweenService:Create(
        mainFrame,
        TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = targetPosition}
    ):Play()
end

headerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        -- Visual feedback when dragging starts
        tweenService:Create(
            headerFrame, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = COLORS.ACCENT1:Lerp(COLORS.HEADER, 0.7)}
        ):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                
                -- Visual feedback when dragging ends
                tweenService:Create(
                    headerFrame, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundColor3 = COLORS.HEADER}
                ):Play()
            end
        end)
    end
end)

headerFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Enhanced animations and effects in a coroutine to prevent blocking
spawn(function()
    -- Gradient animation with wave effect
    local rotationSpeed = 0.2
    local colorShift = 0
    local iconScale = 0
    
    while true do
        -- Animate gradient rotation
        gradient.Rotation = (gradient.Rotation + rotationSpeed) % 360
        
        -- Pulse border effect
        local pulse = math.sin(tick() * 2) * 0.3 + 0.7
        outerGlow.Transparency = pulse
        
        -- Pulse icons
        iconScale = math.sin(tick() * 2.5) * 0.1 + 1
        levelIcon.Size = UDim2.new(0, 28 * iconScale, 0, 28 * iconScale)
        moneyIcon.Size = UDim2.new(0, 28 * iconScale, 0, 28 * iconScale)
        
        -- Shift header accent colors
        colorShift = (colorShift + 0.003) % 1
        headerGradient.Offset = Vector2.new(colorShift, 0)
        
        -- Create occasional sparkle effect
        if math.random(1, 100) == 1 then
            local sparkle = Instance.new("Frame")
            sparkle.Size = UDim2.new(0, math.random(3, 5), 0, math.random(3, 5))
            sparkle.Position = UDim2.new(math.random()/1.2, 0, math.random()/1.2, 0)
            sparkle.BackgroundColor3 = COLORS.GOLD
            sparkle.BackgroundTransparency = 0.2
            sparkle.Parent = particleContainer
            
            local sparkleCorner = Instance.new("UICorner")
            sparkleCorner.CornerRadius = UDim.new(1, 0)
            sparkleCorner.Parent = sparkle
            
            -- Animate and remove sparkle
            tweenService:Create(
                sparkle,
                TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(sparkle.Position.X.Scale + 0.1, 0, sparkle.Position.Y.Scale - 0.1, 0)
                }
            ):Play()
            
            debris:AddItem(sparkle, 0.8)
        end
        
        wait(0.01)
    end
end)

-- Connect update function to run repeatedly with RunService instead of infinite loop
runService.Heartbeat:Connect(updateUI)

-- Set up drag functionality with RunService
runService.RenderStepped:Connect(function()
    if dragging and dragInput then
        update(dragInput)
    end
end)

-- Load the UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()

game:GetService("ReplicatedStorage").Events.Local.Alert:Fire("ConstlynHub","THX for using our script")

-- Function to delete objects for anti-lag
function deleteForAntiLags()
    if not getgenv().onlyonetime then
        local targets = {}
        
        if game.PlaceId == 15812335463 or game.PlaceId == 16872617739 then
            targets = {
                workspace.Main.Kitchen.Buns,
                workspace.Main.Kitchen:GetChildren()[6],
                workspace.Main.Kitchen.Fryer,
                workspace.Main.Kitchen.Model,
                workspace.Main.Kitchen.Patty,
                workspace.Main.Kitchen:GetChildren()[12],
                workspace.Main.Kitchen.Plate,
                workspace.Main.Kitchen.Salad,
                workspace.Main.Kitchen.SodaMachine,
                workspace.Main.Kitchen.Stove,
                workspace.Main.Kitchen:GetChildren()[4],
                workspace.Main.Kitchen.Trash,
            }
        elseif game.PlaceId == 16819089066 or game.PlaceId == 16873261961 then
            targets = {
                workspace.Main.Kitchen:GetChildren()[17],
                workspace.Main.Kitchen.Bush_03,
                workspace.Main.Kitchen:GetChildren()[19],
                workspace.Main.Kitchen:GetChildren()[18],
                workspace.Main.Kitchen.Japanese_Drink,
                workspace.Main.Kitchen:GetChildren()[9],
                workspace.Main.Kitchen.MeatPrep,
                workspace.Main.Kitchen:GetChildren()[13],
                workspace.Main.Kitchen:GetChildren()[12],
                workspace.Main.Kitchen.NigiriPrep,
                workspace.Main.Kitchen:GetChildren()[2],
                workspace.Main.Kitchen.Plate,
                workspace.Main.Kitchen.RamenKit,
                workspace.Main.Kitchen.Stove,
                workspace.Main.Kitchen:GetChildren()[20],
                workspace.Main.Kitchen:GetChildren()[11],
                workspace.Main.Kitchen.SushiPrep,
                workspace.Main.Kitchen.Trash,
                workspace.Main.Kitchen.UncutMeat,
            }
        end

        for _, obj in ipairs(targets) do
            if obj then
                obj:Destroy()
            end
        end
        
        getgenv().onlyonetime = true
    elseif getgenv().onlyonetime then
        return
    end
end

-- Function to handle anti-lag by cleaning player-generated models
function antiLags()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local character = player.Character
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Model") and (item.Name == "Fries" or item.Name == "Salad" or item.Name == "Burger" or item.Name == "Soda" or item.Name == "Cake" or item.Name == "Sushi" or item.Name == "Nigiri" or item.Name == "Donut" or item.Name == "Pastery" or item.Name == "Drink" or item.Name == "Japanese_Drink" or item.Name == "Ramen" or item.Name == "Cleansing Tea") then
                    item:Destroy()
                end
            end
        end
    end
end

-- Function to handle automated farming for dinner orders
function autoFarmOrders()
    if game.PlaceId == 15812335463 or game.PlaceId == 16872617739 then
        local foodItems = {"Fries", "Burger", "Soda", "Salad"}
        
        for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
            for _, item in ipairs(foodItems) do
                local args = { [1] = item, [2] = 16232900 }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)
                task.wait()
            end
        end
        
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
        
        local bossLocation = workspace.Main.BotFolder.BossLocation
        for _, item in ipairs(foodItems) do
            local args = { [1] = item, [2] = 16232900 }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
            task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)
        end
        
    elseif game.PlaceId == 16819089066 then
        local foodItems = {"Ramen", "Japanese_Drink", "Sushi", "Nigiri"}
        
        for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
            for _, item in ipairs(foodItems) do
                local args = { [1] = item, [2] = 16232900 }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)
                task.wait()
            end
        end
        
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
        
        local bossLocation = workspace.Main.BotFolder.BossLocation
        for _, item in ipairs(foodItems) do
            local args = { [1] = item, [2] = 16232900 }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
            task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)
        end
        
    elseif game.PlaceId == 16873261961 or game.PlaceId == 15897687172 then
        local foodItems = {"Cake", "Drink", "Donut", "Pastery"}
        
        for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
            for _, item in ipairs(foodItems) do
                local args = { [1] = item, [2] = 16232900 }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)
                task.wait()
            end
        end
        
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
        
        local bossLocation = workspace.Main.BotFolder.BossLocation
        for _, item in ipairs(foodItems) do
            local args = { [1] = item, [2] = 16232900 }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
            task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)
        end
    end
end
function autofarmordersv2()
return
end
-- Create particle container for effects
local particleContainer = Instance.new("Frame")
particleContainer.Name = "ParticleContainer"
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = mainFrame

-- Add shadow to mainFrame 
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Image = "rbxassetid://7131988773"
shadow.ImageColor3 = COLORS.BACKGROUND
shadow.ImageTransparency = 0.5
shadow.Parent = mainFrame

-- Format number function for displaying values
local function formatNumber(number)
    if number >= 1000000000 then
        return string.format("%.1fB", number / 1000000000)
    elseif number >= 1000000 then
        return string.format("%.1fM", number / 1000000)
    elseif number >= 1000 then
        return string.format("%.1fK", number / 1000)
    else
        return tostring(number)
    end
end

-- Create the GUI window using the Library
local Window = Library:Window({
    text = "ConstlynHub"
})

-- Create tabs for different features
local mainTab = Window:TabSection({
    text = "Order Up"
})

local mainPage = mainTab:Tab({
    text = "Main",
    icon = "rbxassetid://7733715400"
})

local statsPage = mainTab:Tab({
    text = "Stats",
    icon = "rbxassetid://7743875263"
})

local visualsTab = Window:TabSection({
    text = "Visual Options"
})

local visualsPage = visualsTab:Tab({
    text = "UI Settings",
    icon = "rbxassetid://7733954760"
})

-- Settings section for main controls
local mainSection = mainPage:Section({
    text = "Main"
})

-- Add toggle for GUI visibility
mainSection:Toggle({
    text = "Show Stats",
    callback = function(Value)
        screenGui.Enabled = Value
    end
})

-- Add toggle for anti-lag features
mainSection:Toggle({
    text = "Anti-Lag",
    callback = function(Value)
        if Value then
            deleteForAntiLags()
            -- Set up a connection to continuously clean up lag-causing objects
            getgenv().antiLagConnection = game:GetService("RunService").Heartbeat:Connect(antiLags)
        else
            if getgenv().antiLagConnection then
                getgenv().antiLagConnection:Disconnect()
            end
        end
    end
})

-- Stats display section
local statsSection = statsPage:Section({
    text = "Stats Display Options"
})

-- Add color customization
statsSection:Colorpicker({
    text = "Background Color",
    color = COLORS.BACKGROUND,
    callback = function(Color)
        COLORS.BACKGROUND = Color
        mainFrame.BackgroundColor3 = Color
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color),
            ColorSequenceKeypoint.new(0.5, Color:Lerp(Color3.new(1, 1, 1), 0.2)),
            ColorSequenceKeypoint.new(1, Color)
        })
    end
})

statsSection:Colorpicker({
    text = "Accent Color",
    color = COLORS.ACCENT1,
    callback = function(Color)
        COLORS.ACCENT1 = Color
        outerGlow.Color = Color
        headerAccent.BackgroundColor3 = Color
    end
})

-- Visual settings section
local visualSection = visualsPage:Section({
    text = "Visual Effects"
})

-- Add slider for animation speed
visualSection:Slider({
    text = "Animation Speed",
    min = 0.1,
    max = 2,
    callback = function(Value)
        rotationSpeed = Value
    end
})

-- Add toggle for particle effects
visualSection:Toggle({
    text = "Show Particles",
    callback = function(Value)
        particleContainer.Visible = Value
    end
})

-- Add button to reset all settings
visualSection:Button({
    text = "Reset All Settings",
    callback = function()
        -- Reset colors to defaults
        COLORS.BACKGROUND = Color3.fromRGB(20, 20, 32)
        COLORS.ACCENT1 = Color3.fromRGB(140, 90, 255)
        
        -- Update UI elements
        mainFrame.BackgroundColor3 = COLORS.BACKGROUND
        outerGlow.Color = COLORS.ACCENT1
        headerAccent.BackgroundColor3 = COLORS.ACCENT1
        
        -- Reset other settings
        rotationSpeed = 0.2
        particleContainer.Visible = true
        
        -- Notify user
        game:GetService("ReplicatedStorage").Events.Local.Alert:Fire("ConstlynHub", "Settings reset to default")
    end
})

mainSection:Button({
    text = "Teleport to Unreleased Dinner 🎁",
    callback = function()
        game:GetService("TeleportService"):Teleport(15989668274)
    end,
})

mainSection:Button({
    text = "Teleport To Unreleased Bakery 🎁",
    callback = function()
        game:GetService("TeleportService"):Teleport(16142203369)
    end,
})
mainSection:Toggle({
    text = "AutoFarm V2[Better wifi]✨",
    state = false,
    callback = function(state)
        getgenv().AutofarmV2 = state
        
        if getgenv().AutofarmV2 then
            coroutine.wrap(function()
                while getgenv().AutofarmV2 do
                    game:GetService("RunService").heartbeat:Wait()
                    
                    
                    for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
                        for _, bot in pairs(location:GetChildren()) do 
                            if bot:IsA("Model") and bot:FindFirstChild("HumanoidRootPart") then
                                if (bot.HumanoidRootPart.Position - location.Hitbox.Position).Magnitude < 5 then
                                    local orderFolder = bot:FindFirstChildWhichIsA("Folder")
                                    if orderFolder then
                                        for _, order in pairs(orderFolder:GetChildren()) do
                                            local itemName = order.Name
                                            
                                            if itemName ~= "Anything" then
                                                local args = { [1] = itemName, [2] = 16232900 }
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                                                
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)

                                            else
                                                -- Handle "Anything" order type with a default item
                                                local defaultItem = "Salad"
                                                if game.PlaceId == 16819089066 or game.PlaceId == 16873261961 then
                                                    defaultItem = game.PlaceId == 16819089066 and "Sushi" or "Cake"
                                                end
                                                
                                                local args = { [1] = defaultItem, [2] = 16232900 }
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))

                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)

                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Process boss location
                    local bossLocation = workspace.Main.BotFolder.BossLocation
                    for _, bot in pairs(bossLocation:GetChildren()) do 
                        if bot:IsA("Model") and bot:FindFirstChild("HumanoidRootPart") then
                            if (bot.HumanoidRootPart.Position - bossLocation.Hitbox.Position).Magnitude < 10 then
                                local orderFolder = bot:FindFirstChildWhichIsA("Folder")
                                if orderFolder then
                                    for _, order in pairs(orderFolder:GetChildren()) do
                                        local itemName = order.Name
                                        
                                        if itemName ~= "Anything" then
                                            local args = { [1] = itemName, [2] = 16232900 }
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                                           
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)

                                        else
                                            -- Handle "Anything" order type with a default item for boss
                                            local defaultItem = "Salad"
                                            if game.PlaceId == 16819089066 or game.PlaceId == 16873261961 then
                                                defaultItem = game.PlaceId == 16819089066 and "Sushi" or "Cake"
                                            end
                                            
                                            local args = { [1] = defaultItem, [2] = 16232900 }
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                                           
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)

                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Clean tables in a separate thread to not delay the main loop
                    task.spawn(function()
                        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
                        end
                    end)
                end
            end)()
        end
    end
})

mainSection:Toggle({
    text = "AutoFarm ✨",
    state = false,
    callback = function(state)
        getgenv().autofarmorder = state
        
        if getgenv().autofarmorder then
            if not getgenv().autofarmConnection then
                getgenv().autofarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().autofarmorder then
                        autoFarmOrders()
                    else
                        task.wait()
                        getgenv().autofarmConnection:Disconnect()
                        getgenv().autofarmConnection = nil
                    end
                end)
            end
        elseif getgenv().autofarmConnection then
            task.wait()
            getgenv().autofarmConnection:Disconnect()
            getgenv().autofarmConnection = nil
        end
    end
})

mainSection:Toggle({
    text = "AntiLag 🎯",
    state = false,
    callback = function(state)
        getgenv().antilag = state
        
        if getgenv().antilag then
            deleteForAntiLags()
            
            getgenv().onlyonetime = true
            if not getgenv().antilagConnection then
                getgenv().antilagConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().antilag then
                        antiLags()
                    else
                        task.wait()
                        getgenv().antilagConnection:Disconnect()
                        getgenv().antilagConnection = nil
                    end
                end)
            end
        elseif getgenv().antilagConnection then
            task.wait()
            getgenv().antilagConnection:Disconnect()
            getgenv().antilagConnection = nil
        end
    end
})

mainSection:Dropdown({
    text = "Select Crate",
    list = {"Diner", "Bakery", "Japanese"},
    default = "Diner",
    callback = function(selected)
        getgenv().NameOfRestourant = selected
    end
})

mainSection:Toggle({
    text = "Auto Crates [LOBBY] | 🍴",
    state = false,
    callback = function(state)
        getgenv().autocrates = state
        
        if getgenv().autocrates then
            if not getgenv().autocratesConnection then
                getgenv().autocratesConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().autocrates then
                        local foodItems = {"Burger", "Salad", "Soda", "Fries"}
                        local foodItems1 = {"Drinks", "Pastery", "Donut", "Cake"}
                        local foodItems2 = {"Sushi", "Nigiri", "Ramen", "Japanese_Drink"}
                        
                        if getgenv().NameOfRestourant == "Diner" then
                            for _, item in ipairs(foodItems) do
                                local args = { "Diner", item, "Money" }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args))
                            end
                        elseif getgenv().NameOfRestourant == "Bakery" then
                            for _, item1 in ipairs(foodItems1) do
                                local args = { "Bakery", item1, "Money" }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args))
                            end
                        elseif getgenv().NameOfRestourant == "Japanese" then
                            for _, item2 in ipairs(foodItems2) do
                                local args = { "Japanese", item2, "Money" }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args))
                            end
                        end
                    else
                        task.wait()
                        getgenv().autocratesConnection:Disconnect()
                        getgenv().autocratesConnection = nil
                    end
                end)
            end
        elseif getgenv().autocratesConnection then
            task.wait()
            getgenv().autocratesConnection:Disconnect()
            getgenv().autocratesConnection = nil
        end
    end
})

-- Add additional utility functions
local UtilitySection = mainPage:Section({ text = "Utilities" })

UtilitySection:Button({
    text = "Instant Cleanup Tables",
    callback = function()
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
    end
})

UtilitySection:Button({
    text = "Refresh UI",
    callback = function()
        Library:Toggle()
        task.wait(0.5)
        Library:Toggle()
    end
})

-- Credits section
local CreditsSection = mainPage:Section({ text = "Credits" })

-- Use TextBox or Button instead of Label since Label isn't implemented
CreditsSection:Button({
    text = "Script by ConstlynHub Team",
    callback = function() end -- Empty callback
})

CreditsSection:Button({
    text = "Updated: March 2025",
    callback = function() end -- Empty callback
})
-- Initialize with default values
screenGui.Enabled = false
particleContainer.Visible = false

-- Notify user on successful load
game:GetService("ReplicatedStorage").Events.Local.Alert:Fire("ConstlynHub", "Script loaded successfully!")

-- Check for game updates
local gameVersion = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Updated
local lastupdate = os.time() - 604800
if gameVersion > lastupdate then -- If game updated in last week
    game:GetService("ReplicatedStorage").Events.Local.Alert:Fire("ConstlynHub", "Game was recently updated. Please report any issues!")
end

else
    game:GetService("Players").LocalPlayer:Kick("Bypassing paid script is not allowed!")
end
