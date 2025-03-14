local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "One More Night"
})

local TabSection = Window:TabSection({
    text = "Main"
})


local Tab = TabSection:Tab({
    text = "Main",
    icon = "rbxassetid://7999345313",
})

local Tab2 = TabSection:Tab({
    text = "Lobby",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "Section"
})

local LobbySection = Tab2:Section({
    text = "Lobby Stuff"
})

-- Function to increase proximity prompt distance
local function increaseProximityDistance(prompt, distance)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.MaxActivationDistance = distance
        print("Increased proximity distance for: " .. prompt.Parent.Name)
    end
end

-- Function to find and enhance all proximity prompts
local function enhanceAllProximityPrompts(distance)
    -- Look in workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            increaseProximityDistance(obj, distance)
        end
    end
    
    -- Also look in AssetsInGameplay when it loads
    if workspace:FindFirstChild("AssetsInGameplay") then
        for _, obj in pairs(workspace.AssetsInGameplay:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                increaseProximityDistance(obj, distance)
            end
        end
    end
end

-- Global prompt distance setting
_G.ProximityDistance = 15 -- Default value

-- Add a button to manually increase all proximity prompt distances
Section:Button({
    text = "Increase All Proximity Distances 🔍",
    callback = function()
        enhanceAllProximityPrompts(_G.ProximityDistance)
        print("Increased all proximity prompt distances to " .. _G.ProximityDistance)
    end,
})


Section:Button({
    text = "Delete Door Shadows 🎫",
    callback = function()
local map = workspace.Map

-- Get the 7th and 6th children
local part7 = map:GetChildren()[7]
local part6 = map:GetChildren()[6]
local doorShadow = map.DoorShadow

-- Destroy the parts
if part7 then
    part7:Destroy()
end

if part6 then
    part6:Destroy()
end

if doorShadow then
    doorShadow:Destroy()
end
    end,
})

Section:Button({
    text = "Emotes List 🔑",
    callback = function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Emote list from your provided names
local emoteList = {
    "Afk", "Ascend", "Backflip", "Banana", "Bang", "Blast", "BloxyCola", "Bow",
    "California", "Caramell", "Cat", "Classic", "Conga", "Coward", "Default",
    "Distraction", "Engineer", "Fireplace", "Flashlight", "Flex", "Fork", "Fresh",
    "Garry", "Griddy", "Groove", "Hakari", "Happy", "Kart", "KazotskyKick",
    "LethalCompany", "Mannrobics", "Medic", "Meditate", "OfficeChair", "Parrot",
    "Penguin", "Pong", "RanchoRelaxo", "Rat", "Salute", "Sit", "Smug", "Snap",
    "Spin", "Spooky", "Spray", "Stop", "Success", "Thriller", "Tpose", "Unlock"
}

-- Create the GUI
local function createEmoteGui()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Check if GUI already exists and remove it
    if playerGui:FindFirstChild("EmoteGui") then
        playerGui.EmoteGui:Destroy()
    end
    
    -- Main GUI
    local emoteGui = Instance.new("ScreenGui")
    emoteGui.Name = "EmoteGui"
    emoteGui.ResetOnSpawn = false
    emoteGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    emoteGui.Parent = playerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = emoteGui
    
    -- Round corners
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = mainFrame
    
    -- Add shadow
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1.5
    uiStroke.Color = Color3.fromRGB(60, 60, 70)
    uiStroke.Parent = mainFrame
    
    -- Header frame
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Size = UDim2.new(1, 0, 0, 40)
    headerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame
    
    -- Header corner
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = headerFrame
    
    -- Bottom corner cover to make the header blend with main frame
    local headerCover = Instance.new("Frame")
    headerCover.Name = "HeaderCover"
    headerCover.Size = UDim2.new(1, 0, 0, 10)
    headerCover.Position = UDim2.new(0, 0, 1, -10)
    headerCover.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    headerCover.BorderSizePixel = 0
    headerCover.ZIndex = 0
    headerCover.Parent = headerFrame
    
    -- Title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = "Emotes Names /e [name]"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = headerFrame
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.BorderSizePixel = 0
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Parent = headerFrame
    
    -- Close button corner
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Scroll frame for emotes
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "EmoteScroll"
    scrollFrame.Size = UDim2.new(1, -20, 1, -50)
    scrollFrame.Position = UDim2.new(0, 10, 0, 45)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, (#emoteList * 40) + 10)
    scrollFrame.Parent = mainFrame
    
    -- Auto layout for scroll frame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    -- Padding around the list
    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 5)
    listPadding.PaddingBottom = UDim.new(0, 5)
    listPadding.Parent = scrollFrame
    
    -- Create emote buttons
    for i, emoteName in ipairs(emoteList) do
        local emoteButton = Instance.new("TextButton")
        emoteButton.Name = emoteName .. "Button"
        emoteButton.Size = UDim2.new(1, 0, 0, 36)
        emoteButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        emoteButton.BorderSizePixel = 0
        emoteButton.Font = Enum.Font.Gotham
        emoteButton.Text = emoteName
        emoteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        emoteButton.TextSize = 16
        emoteButton.LayoutOrder = i
        emoteButton.Parent = scrollFrame
        
        -- Button corner
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = emoteButton
        
        -- Button hover effect
        emoteButton.MouseEnter:Connect(function()
            TweenService:Create(emoteButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
        end)
        
        emoteButton.MouseLeave:Connect(function()
            TweenService:Create(emoteButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        end)
        
        -- Button click effect
        emoteButton.MouseButton1Click:Connect(function()
            -- Play emote animation (implement your emote play logic here)
            print("Playing emote: " .. emoteName)
            
            -- Visual feedback
            local clickTween = TweenService:Create(emoteButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 180)})
            clickTween:Play()
            clickTween.Completed:Wait()
            TweenService:Create(emoteButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
        end)
    end
    
    -- Make GUI draggable
    local isDragging = false
    local dragStart
    local startPos
    
    headerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        -- Animate close
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Wait()
        emoteGui:Destroy()
    end)
    
    -- Open animation
    mainFrame.Size = UDim2.new(0, 300, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 400)}):Play()
    
    return emoteGui
end

-- Function to toggle the emote menu (you would bind this to a key or button)
local function toggleEmoteMenu()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("EmoteGui") then
        -- Close animation
        local mainFrame = playerGui.EmoteGui.MainFrame
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 300, 0, 0)})
        closeTween:Play()
        closeTween.Completed:Wait()
        playerGui.EmoteGui:Destroy()
    else
        createEmoteGui()
    end
end

-- Bind to a key (uncomment to use)
-- UserInputService.InputBegan:Connect(function(input, processed)
--     if not processed and input.KeyCode == Enum.KeyCode.B then
--         toggleEmoteMenu()
--     end
-- end)

-- Create the GUI when this script runs
createEmoteGui()

-- You could also create a button to toggle the menu
-- local screenGui = Instance.new("ScreenGui")
-- screenGui.Name = "EmoteButtonGui"
-- screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
-- 
-- local toggleButton = Instance.new("TextButton")
-- toggleButton.Name = "EmoteMenuButton"
-- toggleButton.Size = UDim2.new(0, 120, 0, 40)
-- toggleButton.Position = UDim2.new(0, 10, 0, 10)
-- toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
-- toggleButton.BorderSizePixel = 0
-- toggleButton.Font = Enum.Font.GothamBold
-- toggleButton.Text = "Emotes"
-- toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
-- toggleButton.TextSize = 16
-- toggleButton.Parent = screenGui
-- 
-- local buttonCorner = Instance.new("UICorner")
-- buttonCorner.CornerRadius = UDim.new(0, 8)
-- buttonCorner.Parent = toggleButton
-- 
-- toggleButton.MouseButton1Click:Connect(toggleEmoteMenu)
    end,
})


Section:Toggle({
    text = "Auto Press Destroyman 🦖",
    state = false, -- Default boolean
    callback = function(boolean)
        -- Store the toggle state in a variable
        _G.AutoDestroyMan = boolean
        
        -- Create a separate function that only runs when toggle is on
        if _G.AutoDestroyMan then
            spawn(function()
                while _G.AutoDestroyMan do
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):WaitForChild("Threats"):WaitForChild("DestroymanIII"):WaitForChild("RemoteEvent"):FireServer()
                end
            end)
        end
    end
})

Section:Toggle({
    text = "Auto Solve Puppet/Power 🤡",
    state = false, -- Default boolean
    callback = function(boolean)
        -- Store the toggle state in a variable
        _G.AutoSolvePuppet = boolean
        
        -- Create a separate function that only runs when toggle is on
        if _G.AutoSolvePuppet then
            spawn(function()
                while _G.AutoSolvePuppet do
                    task.wait(0.1)
                    local args = {
                        [1] = true
                    }
                    game:GetService("Players").LocalPlayer:WaitForChild("RemoteEvent"):FireServer(unpack(args))
                end
            end)
        end
    end
})

-- Create a variable to track toggle state
local autoRoxieEnabled = false

-- Auto Clean toggle with improved path finding
Section:Toggle({
    text = "Auto Clean 🍴",
    state = false, -- Default boolean
    callback = function(boolean)
        _G.AutoCleanEnabled = boolean
        
        if _G.AutoCleanEnabled then
            -- Create a new thread for the cleaning loop
            task.spawn(function()
                while _G.AutoCleanEnabled do
                    task.wait(0.5) -- Slightly longer check interval to reduce errors
                    
                    -- First check if AssetsInGameplay exists
                    if workspace:FindFirstChild("AssetsInGameplay") then
                        local highlightBlue = workspace.AssetsInGameplay:FindFirstChild("HighlightBlue")
                        
                        if highlightBlue then
                            local cleaningSupplies = highlightBlue:FindFirstChild("CleaningSupplies")
                            
                            if cleaningSupplies and cleaningSupplies:FindFirstChild("Active") then
                                local proximityPrompt = cleaningSupplies.Active:FindFirstChild("ProximityPrompt")
                                
                                if proximityPrompt then
                                    pcall(function()
                                        fireproximityprompt(proximityPrompt)
                                        print("Fired Cleaning Supplies prompt successfully")
                                    end)
                                end
                            end
                        end
                    else
                        print("Waiting for game to fully load...")
                    end
                end
                print("Auto Clean loop stopped")
            end)
            print("Auto Clean enabled")
        else
            print("Auto Clean disabled")
        end
    end
})

-- Auto Roxie toggle with improved path finding
Section:Toggle({
    text = "Auto Solve Roxie 🎁",
    state = false, -- Default boolean
    callback = function(boolean)
        -- Update the toggle state
        _G.AutoRoxieEnabled = boolean
        
        -- If enabled, start the loop in a new thread
        if _G.AutoRoxieEnabled then
            -- Use spawn to create a new thread for the loop
            spawn(function()
                while _G.AutoRoxieEnabled do -- Only run while toggle is enabled
                    task.wait(0.5) -- Slightly longer check interval
                    
                    -- First check if AssetsInGameplay exists
                    if workspace:FindFirstChild("AssetsInGameplay") then
                        local highlightCyan = workspace.AssetsInGameplay:FindFirstChild("HighlightCyan")
                        
                        if highlightCyan then
                            local fumo = highlightCyan:FindFirstChild("Fumo")
                            
                            if fumo then
                                local proximityPrompt = fumo:FindFirstChild("ProximityPrompt")
                                
                                if proximityPrompt then
                                    pcall(function()
                                        fireproximityprompt(proximityPrompt)
                                        print("Fired Fumo prompt successfully")
                                    end)
                                end
                            end
                        end
                    else
                        print("Waiting for game to fully load...")
                    end
                    
                    task.wait(3) -- Wait between attempts
                end
                print("Auto Roxie disabled")
            end)
            print("Auto Roxie enabled")
        end
    end
})

Section:Toggle({
    text = "Auto Solve Vents 🎲",
    state = false,
    callback = function(boolean)
        _G.AutoSolveVents = boolean
        
        if _G.AutoSolveVents then
            spawn(function()
                while _G.AutoSolveVents and task.wait(0.1) do
                    workspace:WaitForChild("AssetsInGameplay"):WaitForChild("HighlightGreen"):WaitForChild("MaintenancePanel"):WaitForChild("RemoteEvent"):FireServer()
                end
            end)
        end
    end
})


-- Add a slider to control the proximity distance
Section:Slider({
    text = "Proximity Distance",
    min = 5,
    max = 50,
    callback = function(number)
        _G.ProximityDistance = number
        print("Set proximity distance to: " .. number)
    end
})

-- NEW TELEPORT FUNCTION FOR LOBBY TAB
-- Function to safely teleport with tweening
local function teleportWithTween(targetCFrame)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- Make sure character exists
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        print("Character or HumanoidRootPart not found!")
        return
    end
    
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    
    -- Create tween info with smoothed movement
    local tweenInfo = TweenInfo.new(
        2,                      -- Duration
        Enum.EasingStyle.Sine,  -- Smooth movement
        Enum.EasingDirection.Out
    )
    
    -- Create and play the tween
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    -- Optional: Add a completed event to know when teleport is finished
    tween.Completed:Connect(function()
        print("Teleport completed!")
    end)
end

-- Add teleport button to Lobby section
LobbySection:Button({
    text = "Teleport to Secret Claim Badge 🗝️",
    callback = function()
        -- Target position for teleport
        local targetCFrame = CFrame.new(
            92.3286667, 6.97885609, -262.776733,
            0.224608392, 3.56058614e-08, 0.974449098,
            -6.91893902e-08, 1, -2.05914716e-08,
            -0.974449098, -6.27965235e-08, 0.224608392
        )
        
        teleportWithTween(targetCFrame)
        print("Teleporting to Secret Claim...")
    end,
})

LobbySection:Button({
    text = "Auto Hammer Perfect 🔨",
    callback = function()
        for i,v in pairs(workspace.Interactives:GetChildren()) do 
            if v.Name == "Strongman" then 
                if (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Screen.Position).Magnitude < 15 then
                    local args = {
                        [1] = "Complete",
                        [2] = 100,
                        [3] = 100,
                        [4] = 100
                    }

                    v:WaitForChild("RemoteEvent"):FireServer(unpack(args))
                end
            end
        end
        print("Auto Hammer Perfect executed!")
    end,
})

LobbySection:Button({
    text = "Auto Pushups 👌",
    callback = function()
     local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local pushupCount = 0
local maxPushups = 10000

local function doPushups()
    spawn(function()
        while pushupCount < maxPushups do
            for i, v in pairs(workspace.Interactives:GetChildren()) do
                if v.Name == "PushUps" then
                    if (rootPart.Position - v.Position).Magnitude < 1 then
                        fireproximityprompt(v.ProximityPrompt)
                        pushupCount = pushupCount + 1
                        print("Pushup #" .. pushupCount .. " completed")
                        
                        if pushupCount >= maxPushups then
                            print("All 100 pushups completed!")
                            break
                        end
                        
                    end
                end
            end
            
            if pushupCount >= maxPushups then
                break
            end
            
            wait()
        end
    end)
end
doPushups()
    end,
})
