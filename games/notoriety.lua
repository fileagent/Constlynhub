local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "Notoriety"
})

local TabSection = Window:TabSection({
    text = "Constlynhub"
})

local Tab = TabSection:Tab({
    text = "Main",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "Main"
})
Section:Toggle({
    text = "Kill All Cops✨",
    state = false,
    callback = function(state)
        getgenv().KillAllCops = state
        
        if getgenv().KillAllCops then
            coroutine.wrap(function()
                while getgenv().KillAllCops do
                    game:GetService("RunService").heartbeat:Wait()
                   local a1b2 = game:GetService("RunService")
    local c3d4 = game:GetService("ReplicatedStorage")
    local e5f6 = game:GetService("Workspace")
    local g7h8 = game:GetService("Players")

    local i9j0 = a1b2.RenderStepped
    local m3n4 = c3d4:FindFirstChild("RS_Package"):WaitForChild("Assets"):WaitForChild("Remotes"):WaitForChild("Damage")
    local o5p6 = g7h8.LocalPlayer

    local q7r8 = {
        s9t0 = true,
        u1v2 = 'Head'
    }

    if q7r8.s9t0 then
        local w3x4 = o5p6.Character:FindFirstChildOfClass("Tool")
        if w3x4 ~= nil then
            for _, y5z6 in ipairs(e5f6:FindFirstChild("Police"):GetChildren()) do
                if y5z6 ~= nil and y5z6:IsA("Model") and y5z6:FindFirstChild(q7r8.u1v2) ~= nil and y5z6:FindFirstChildOfClass("Humanoid") ~= nil and m3n4 ~= nil then
                    m3n4:FireServer("Damage", w3x4, y5z6.Humanoid, math.huge, y5z6[q7r8.u1v2], w3x4.Name, Vector3.new())
                end
            end
        end
    end
                end
            end)()
        end
    end
})

Section:Toggle({
    text = "Inf Stamina 🏃‍♂️",
    state = false,
    callback = function(state)
        getgenv().InfStamina = state
        
        if getgenv().InfStamina then
            coroutine.wrap(function()
                local plr = game.Players.LocalPlayer.Name
                local v = game:GetService("Workspace").Criminals[plr]
                
                while getgenv().InfStamina do
                    v.MaxStamina.Value = 10000
                    v.Stamina.Value = 10000
                    task.wait(0.1)
                end
                
                -- Reset to default when toggled off
                v.MaxStamina.Value = 100
                v.Stamina.Value = 100
            end)()
        end
    end
})

Section:Toggle({
    text = "Remove Glass 🎫",
    state = false,
    callback = function(state)
        getgenv().RemoveGlass = state
        
        if getgenv().RemoveGlass then
            coroutine.wrap(function()
                while getgenv().RemoveGlass do
                    for i,v in pairs(game:GetService("Workspace").Glass:GetChildren()) do
                        if v.Name == 'Glass' then
                            v:Destroy()
                        end
                    end
                    task.wait(0.5)  -- Prevent potential issues with rapid destruction
                end
            end)()
        end
    end
})

Section:Toggle({
    text = "TP Bags to Van 💰",
    state = false,
    callback = function(state)
        getgenv().TPBagsToVan = state
        
        if getgenv().TPBagsToVan then
            coroutine.wrap(function()
                while getgenv().TPBagsToVan do
                    local vanCFrame = game:GetService("Workspace").BagSecuredArea.FloorPart.CFrame
                    for i,v in pairs(game:GetService("Workspace").Bags:GetDescendants()) do
                        if v.Name == 'MoneyBag' then
                            v.CFrame = vanCFrame * CFrame.new(0, 0, 10 + (i * 2))
                        end
                    end
                    task.wait(0.5)  -- Prevent potential server issues
                end
            end)()
        end
    end
})


Section:Toggle({
    text = "Guard/Police Esp 👮‍♀️",
    state = false,
    callback = function(boolean)
        -- Clear any existing ESP elements when toggled off
        if not boolean then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("Highlight") then
                    obj:FindFirstChild("Highlight"):Destroy()
                end
                if obj:FindFirstChild("BillboardGui") then
                    obj:FindFirstChild("BillboardGui"):Destroy()
                end
            end
            
            -- Remove status UI if it exists
            if game.Players.LocalPlayer:FindFirstChild("PlayerGui") and 
               game.Players.LocalPlayer.PlayerGui:FindFirstChild("ESPStatus") then
                game.Players.LocalPlayer.PlayerGui.ESPStatus:Destroy()
            end
            return
        end
        
        local function highlightObjects(folder, highlightColor, labelText, icon)
            if not folder then 
                warn(tostring(folder) .. " folder not found!")
                return
            end
            
            -- Configuration
            local PULSE_SPEED = 0.8
            local FLOAT_AMPLITUDE = 0.5
            local FLOAT_SPEED = 2.0
            local SHOW_DISTANCE = true
            local GLOW_INTENSITY = 0.7
            
            local function createHighlight(obj)
                -- Remove existing highlights first to prevent duplicates
                if obj:FindFirstChild("Highlight") then
                    obj:FindFirstChild("Highlight"):Destroy()
                end
                if obj:FindFirstChild("BillboardGui") then
                    obj:FindFirstChild("BillboardGui"):Destroy()
                end
                
                -- Check if it's a Model or a BasePart
                local targetPart = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")) or
                                   obj:IsA("BasePart") and obj
                
                if not targetPart then return end
                
                -- Create ESP Highlight
                local highlight = Instance.new("Highlight")
                highlight.Parent = obj
                highlight.FillColor = highlightColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.OutlineTransparency = 0.2
                
                -- Animated highlight effect
                spawn(function()
                    local t = 0
                    while highlight.Parent do
                        t = t + 0.03
                        highlight.FillTransparency = 0.3 + 0.2 * math.sin(t * PULSE_SPEED * 5) + 0.1 * math.sin(t * PULSE_SPEED * 8)
                        highlight.OutlineTransparency = 0.2 + 0.2 * math.cos(t * PULSE_SPEED * 3)
                        wait(0.03)
                    end
                end)
                
                -- Create BillboardGui for nametag
                local billboard = Instance.new("BillboardGui")
                billboard.Parent = obj
                billboard.Adornee = targetPart
                billboard.Size = UDim2.new(6, 0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.LightInfluence = 0
                
                -- Create main container frame
                local mainFrame = Instance.new("Frame")
                mainFrame.Parent = billboard
                mainFrame.Size = UDim2.new(1, 0, 1, 0)
                mainFrame.BackgroundTransparency = 1
                
                -- Create background
                local background = Instance.new("Frame")
                background.Parent = mainFrame
                background.AnchorPoint = Vector2.new(0.5, 0.5)
                background.Position = UDim2.new(0.5, 0, 0.5, 0)
                background.Size = UDim2.new(0.95, 0, 0.65, 0)
                background.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                background.BackgroundTransparency = 0.2
                
                -- Rounded corners
                local uiCorner = Instance.new("UICorner")
                uiCorner.Parent = background
                uiCorner.CornerRadius = UDim.new(0.3, 0)
                
                -- Gradient
                local gradient = Instance.new("UIGradient")
                gradient.Parent = background
                gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 15)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(20, 20, 30)),
                    ColorSequenceKeypoint.new(0.7, highlightColor:Lerp(Color3.fromRGB(10, 10, 15), 0.6)),
                    ColorSequenceKeypoint.new(1, highlightColor:Lerp(Color3.fromRGB(0, 0, 0), 0.5))
                })
                gradient.Rotation = 35
                
                -- Animate gradient
                spawn(function()
                    local t = 0
                    while background.Parent do
                        t = t + 0.02
                        gradient.Offset = Vector2.new(math.sin(t * 0.5) * 0.2, 0)
                        gradient.Rotation = 35 + math.sin(t * 0.3) * 10
                        wait(0.03)
                    end
                end)
                
                -- Border with glow effect
                local stroke = Instance.new("UIStroke")
                stroke.Parent = background
                stroke.Color = highlightColor
                stroke.Thickness = 2.5
                stroke.Transparency = 0.1
                
                -- Animate stroke color
                spawn(function()
                    local t = 0
                    while stroke.Parent do
                        t = t + 0.03
                        stroke.Color = highlightColor:Lerp(Color3.fromRGB(255, 255, 255), math.abs(math.sin(t * 0.8)) * GLOW_INTENSITY)
                        stroke.Transparency = 0.1 + 0.2 * math.sin(t * 1.2)
                        wait(0.03)
                    end
                end)
                
                -- Glowing backdrop
                local glowBackdrop = Instance.new("Frame")
                glowBackdrop.Parent = background
                glowBackdrop.AnchorPoint = Vector2.new(0.5, 0.5)
                glowBackdrop.Position = UDim2.new(0.5, 0, 0.5, 0)
                glowBackdrop.Size = UDim2.new(1.1, 0, 1.2, 0)
                glowBackdrop.BackgroundColor3 = highlightColor
                glowBackdrop.BackgroundTransparency = 0.7
                glowBackdrop.ZIndex = background.ZIndex - 1
                
                -- Round corners for glow backdrop
                local backdropCorner = Instance.new("UICorner")
                backdropCorner.Parent = glowBackdrop
                backdropCorner.CornerRadius = UDim.new(0.3, 0)
                
                -- Animate glow backdrop
                spawn(function()
                    local t = 0
                    while glowBackdrop.Parent do
                        t = t + 0.05
                        glowBackdrop.BackgroundTransparency = 0.7 + 0.2 * math.sin(t * 1.5)
                        glowBackdrop.Size = UDim2.new(1.1 + 0.05 * math.sin(t * 2), 0, 1.2 + 0.05 * math.sin(t * 2), 0)
                        wait(0.03)
                    end
                end)
                
                -- Create TextLabel
                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = background
                textLabel.Size = UDim2.new(0.95, 0, 0.8, 0)
                textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                textLabel.BackgroundTransparency = 1
                textLabel.TextSize = 16
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.Font = Enum.Font.GothamBlack
                textLabel.Text = labelText
                textLabel.RichText = true
                
                -- Add shadow effect
                local shadowDepth = 3
                for i = 1, shadowDepth do
                    local shadowLabel = Instance.new("TextLabel")
                    shadowLabel.Parent = background
                    shadowLabel.Size = UDim2.new(0.95, 0, 0.8, 0)
                    shadowLabel.Position = UDim2.new(0.5, i, 0.5, i)
                    shadowLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    shadowLabel.BackgroundTransparency = 1
                    shadowLabel.TextSize = 16
                    shadowLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                    shadowLabel.TextTransparency = 0.5 + (i * 0.1)
                    shadowLabel.Font = Enum.Font.GothamBlack
                    shadowLabel.Text = labelText
                    shadowLabel.ZIndex = textLabel.ZIndex - i
                    shadowLabel.RichText = true
                end
                
                -- Animated scale effect for text
                spawn(function()
                    local t = 0
                    local originalSize = textLabel.TextSize
                    while textLabel.Parent do
                        t = t + 0.05
                        textLabel.TextSize = originalSize + math.sin(t * 2) * 1
                        wait(0.03)
                    end
                end)
                
                -- Add icon if provided
                if icon then
                    local iconContainer = Instance.new("Frame")
                    iconContainer.Parent = background
                    iconContainer.Size = UDim2.new(0.22, 0, 0.9, 0)
                    iconContainer.Position = UDim2.new(0.12, 0, 0.5, 0)
                    iconContainer.AnchorPoint = Vector2.new(0.5, 0.5)
                    iconContainer.BackgroundTransparency = 1
                    
                    local iconImage = Instance.new("ImageLabel")
                    iconImage.Parent = iconContainer
                    iconImage.Size = UDim2.new(0.9, 0, 0.9, 0)
                    iconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
                    iconImage.AnchorPoint = Vector2.new(0.5, 0.5)
                    iconImage.BackgroundTransparency = 1
                    iconImage.Image = icon
                    iconImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    
                    -- Add glow to icon
                    local iconGlow = Instance.new("ImageLabel")
                    iconGlow.Parent = iconContainer
                    iconGlow.Size = UDim2.new(1.2, 0, 1.2, 0)
                    iconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
                    iconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
                    iconGlow.BackgroundTransparency = 1
                    iconGlow.Image = icon
                    iconGlow.ImageColor3 = highlightColor
                    iconGlow.ImageTransparency = 0.7
                    iconGlow.ZIndex = iconImage.ZIndex - 1
                    
                    -- Animate icon and glow
                    spawn(function()
                        local t = 0
                        while iconContainer.Parent do
                            t = t + 0.05
                            iconGlow.ImageTransparency = 0.5 + 0.3 * math.sin(t * 1.5)
                            iconGlow.Size = UDim2.new(1.2 + 0.1 * math.sin(t * 2), 0, 1.2 + 0.1 * math.sin(t * 2), 0)
                            iconImage.Rotation = math.sin(t * 0.5) * 5
                            wait(0.03)
                        end
                    end)
                    
                    -- Adjust text position
                    textLabel.Size = UDim2.new(0.7, 0, 0.8, 0)
                    textLabel.Position = UDim2.new(0.65, 0, 0.5, 0)
                    for _, shadow in ipairs(background:GetChildren()) do
                        if shadow:IsA("TextLabel") and shadow ~= textLabel then
                            shadow.Size = UDim2.new(0.7, 0, 0.8, 0)
                            shadow.Position = UDim2.new(0.65, shadow.Position.X.Offset, 0.5, shadow.Position.Y.Offset)
                        end
                    end
                end
                
                -- Add distance tracker if enabled
                if SHOW_DISTANCE then
                    -- Container for distance tracker
                    local distanceContainer = Instance.new("Frame")
                    distanceContainer.Parent = mainFrame
                    distanceContainer.Size = UDim2.new(0.6, 0, 0.3, 0)
                    distanceContainer.Position = UDim2.new(0.5, 0, 0.85, 0)
                    distanceContainer.AnchorPoint = Vector2.new(0.5, 0)
                    distanceContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                    distanceContainer.BackgroundTransparency = 0.3
                    
                    -- Round corners
                    local distanceCorner = Instance.new("UICorner")
                    distanceCorner.Parent = distanceContainer
                    distanceCorner.CornerRadius = UDim.new(0.3, 0)
                    
                    -- Add stroke
                    local distanceStroke = Instance.new("UIStroke")
                    distanceStroke.Parent = distanceContainer
                    distanceStroke.Color = highlightColor:Lerp(Color3.fromRGB(255, 255, 255), 0.5)
                    distanceStroke.Thickness = 1.5
                    distanceStroke.Transparency = 0.5
                    
                    local distanceLabel = Instance.new("TextLabel")
                    distanceLabel.Parent = distanceContainer
                    distanceLabel.Size = UDim2.new(0.9, 0, 0.8, 0)
                    distanceLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                    distanceLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    distanceLabel.BackgroundTransparency = 1
                    distanceLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
                    distanceLabel.Font = Enum.Font.GothamBold
                    distanceLabel.TextSize = 12
                    
                    -- Add shadow to distance label
                    local distanceShadow = Instance.new("TextLabel")
                    distanceShadow.Parent = distanceContainer
                    distanceShadow.Size = UDim2.new(0.9, 0, 0.8, 0)
                    distanceShadow.Position = UDim2.new(0.5, 1, 0.5, 1)
                    distanceShadow.AnchorPoint = Vector2.new(0.5, 0.5)
                    distanceShadow.BackgroundTransparency = 1
                    distanceShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
                    distanceShadow.TextTransparency = 0.5
                    distanceShadow.Font = Enum.Font.GothamBold
                    distanceShadow.TextSize = 12
                    distanceShadow.ZIndex = distanceLabel.ZIndex - 1
                    
                    -- Add small icon
                    local distanceIcon = Instance.new("ImageLabel")
                    distanceIcon.Parent = distanceContainer
                    distanceIcon.Size = UDim2.new(0.15, 0, 0.6, 0)
                    distanceIcon.Position = UDim2.new(0.1, 0, 0.5, 0)
                    distanceIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                    distanceIcon.BackgroundTransparency = 1
                    distanceIcon.Image = "rbxassetid://7733774602"
                    distanceIcon.ImageColor3 = highlightColor
                    
                    -- Adjust text position
                    distanceLabel.Position = UDim2.new(0.55, 0, 0.5, 0)
                    distanceLabel.Size = UDim2.new(0.7, 0, 0.8, 0)
                    distanceShadow.Position = UDim2.new(0.55, 1, 0.5, 1)
                    distanceShadow.Size = UDim2.new(0.7, 0, 0.8, 0)
                    
                    -- Update distance continuously with color coding
                    spawn(function()
                        while distanceContainer.Parent do
                            local success, err = pcall(function()
                                if game.Players.LocalPlayer and 
                                   game.Players.LocalPlayer.Character and 
                                   game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                                   targetPart then
                                    local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                                    local objPos = targetPart.Position
                                    local distance = (playerPos - objPos).Magnitude
                                    local formattedDistance = math.floor(distance)
                                    
                                    -- Add color coding based on distance
                                    local distanceText, textColor
                                    if distance <= 15 then
                                        distanceText = "CLOSE: " .. formattedDistance .. "</b></font>"
                                        textColor = Color3.fromRGB(255, 85, 85)
                                    elseif distance <= 40 then
                                        distanceText = "NEAR: " .. formattedDistance .. "</b></font>"
                                        textColor = Color3.fromRGB(255, 170, 85)
                                    else
                                        distanceText = "FAR: " .. formattedDistance .. "</b></font>"
                                        textColor = Color3.fromRGB(85, 255, 85)
                                    end
                                    
                                    distanceLabel.Text = distanceText
                                    distanceShadow.Text = "DIST: " .. formattedDistance
                                    
                                    -- Update icon color based on distance
                                    distanceIcon.ImageColor3 = textColor
                                end
                            end)
                            
                            if not success then
                                warn("Distance calculation error: " .. tostring(err))
                            end
                            
                            wait(0.1)
                        end
                    end)
                end
                
                
                -- Small indicator line with animation
                local lineFrame = Instance.new("Frame")
                lineFrame.Parent = mainFrame
                lineFrame.Size = UDim2.new(0.1, 0, 0.02, 0)
                lineFrame.AnchorPoint = Vector2.new(0.5, 0)
                lineFrame.Position = UDim2.new(0.5, 0, 0.65, 0)
                lineFrame.BackgroundColor3 = highlightColor
                lineFrame.Rotation = 45
                
                -- Animate the line
                spawn(function()
                    local t = 0
                    while lineFrame.Parent do
                        t = t + 0.1
                        lineFrame.BackgroundTransparency = 0.2 + 0.3 * math.sin(t)
                        lineFrame.Size = UDim2.new(0.1 + 0.02 * math.sin(t * 1.3), 0, 0.02, 0)
                        wait(0.05)
                    end
                end)
            end
            
            -- Refresh highlights for all children in the folder
            local function refreshHighlights()
                for _, obj in ipairs(folder:GetChildren()) do
                    task.spawn(function()
                        pcall(function()
                            createHighlight(obj)
                        end)
                    end)
                end
            end
            
            -- Initial highlight creation
            refreshHighlights()
            
            -- Monitor for changes in the folder
            local childAddedConnection = folder.ChildAdded:Connect(function(child)
                task.spawn(function() 
                    pcall(function()
                        createHighlight(child)
                    end)
                end)
            end)
            
            -- Store connection in folder for cleanup
            if not folder:FindFirstChild("ESPConnection") then
                local valueObj = Instance.new("ObjectValue")
                valueObj.Name = "ESPConnection"
                valueObj.Parent = folder
                valueObj.Value = childAddedConnection
            end
        end
        
        -- Define icons
        local guardIcon = "rbxassetid://7733658504"
        local cameraIcon = "rbxassetid://7734053495"
        
        -- Highlight Police/Guards with error handling
        pcall(function()
            highlightObjects(
                workspace:FindFirstChild("Police"), 
                Color3.fromRGB(30, 255, 150),
                "<stroke color='#000000' thickness='2'><font face='GothamBlack'>GUARD</font></stroke>", 
                guardIcon
            )
        end)
        
        -- Highlight Cameras with error handling
        pcall(function()
            highlightObjects(
                workspace:FindFirstChild("Cameras"), 
                Color3.fromRGB(255, 70, 70),
                "<stroke color='#000000' thickness='2'><font face='GothamBlack'>CAMERA</font></stroke>", 
                cameraIcon
            )
        end)
        
        -- Status UI with error handling
        local function createStatusUI()
            pcall(function()
                -- Clean up existing UI
                if game.Players.LocalPlayer:FindFirstChild("PlayerGui") and 
                   game.Players.LocalPlayer.PlayerGui:FindFirstChild("ESPStatus") then
                    game.Players.LocalPlayer.PlayerGui.ESPStatus:Destroy()
                end
                
                local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                
                local screenGui = Instance.new("ScreenGui")
                screenGui.Name = "ESPStatus"
                screenGui.Parent = playerGui
                
                -- Main container
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 1, 0)
                container.BackgroundTransparency = 1
                container.Parent = screenGui
                
                -- Main frame
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(0, 250, 0, 60)
                frame.Position = UDim2.new(0.5, 0, 0.1, 0)
                frame.AnchorPoint = Vector2.new(0.5, 0)
                frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                frame.BackgroundTransparency = 0.3
                frame.Parent = container
                
                -- Rounded corners
                local uiCorner = Instance.new("UICorner")
                uiCorner.CornerRadius = UDim.new(0.2, 0)
                uiCorner.Parent = frame
                
                -- Stroke with animation
                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(0, 200, 255)
                stroke.Thickness = 2.5
                stroke.Transparency = 0.1
                stroke.Parent = frame
                
                -- Gradient
                local gradient = Instance.new("UIGradient")
                gradient.Parent = frame
                gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 10, 20)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 25, 35)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 15, 25))
                })
                gradient.Rotation = 45
                
                -- Glow effect
                local glow = Instance.new("Frame")
                glow.Size = UDim2.new(1.1, 0, 1.2, 0)
                glow.Position = UDim2.new(0.5, 0, 0.5, 0)
                glow.AnchorPoint = Vector2.new(0.5, 0.5)
                glow.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                glow.BackgroundTransparency = 0.7
                glow.ZIndex = frame.ZIndex - 1
                glow.Parent = frame
                
                -- Glow corners
                local glowCorner = Instance.new("UICorner")
                glowCorner.CornerRadius = UDim.new(0.2, 0)
                glowCorner.Parent = glow
                
                -- Main label
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0.6, 0)
                label.Position = UDim2.new(0.5, 0, 0.4, 0)
                label.AnchorPoint = Vector2.new(0.5, 0.5)
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamBlack
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 24
                label.Text = "ESP ACTIVATED"
                label.Parent = frame
                
                -- Shadow
                local shadowLabel = Instance.new("TextLabel")
                shadowLabel.Size = UDim2.new(1, 0, 0.6, 0)
                shadowLabel.Position = UDim2.new(0.5, 2, 0.4, 2)
                shadowLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                shadowLabel.BackgroundTransparency = 1
                shadowLabel.Font = Enum.Font.GothamBlack
                shadowLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                shadowLabel.TextTransparency = 0.5
                shadowLabel.TextSize = 24
                shadowLabel.Text = "ESP ACTIVATED"
                shadowLabel.ZIndex = label.ZIndex - 1
                shadowLabel.Parent = frame
                
                -- Subtitle
                local subLabel = Instance.new("TextLabel")
                subLabel.Size = UDim2.new(1, 0, 0.3, 0)
                subLabel.Position = UDim2.new(0.5, 0, 0.75, 0)
                subLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                subLabel.BackgroundTransparency = 1
                subLabel.Font = Enum.Font.GothamSemibold
                subLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
                subLabel.TextSize = 12
                subLabel.Text = "GUARDS & CAMERAS VISIBLE"
                subLabel.Parent = frame
                
                -- Pulsing animation with cleanup
                local pulseConnection
                spawn(function()
                    pulseConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
                        local t = tick() % 10
                        stroke.Color = Color3.fromRGB(0, 200, 255):Lerp(
                            Color3.fromRGB(255, 0, 100), 
                            (math.sin(t * 2) + 1) / 2
                        )
                    end)
                    
                    screenGui.AncestryChanged:Connect(function(_, parent)
                        if parent == nil and pulseConnection then
                            pulseConnection:Disconnect()
                        end
                    end)
                end)
                
                -- Fade out after a few seconds
                spawn(function()
                    wait(4)
                    for i = 0, 1, 0.05 do
                        if screenGui.Parent then
                            frame.BackgroundTransparency = 0.3 + (i * 0.7)
                            label.TextTransparency = i
                            shadowLabel.TextTransparency = 0.5 + (i * 0.5)
                            subLabel.TextTransparency = i
                            stroke.Transparency = 0.1 + (i * 0.9)
                            glow.BackgroundTransparency = 0.7 + (i * 0.3)
                            wait(0.05)
                        else
                            break
                        end
                    end
                    wait(1)
                    if screenGui.Parent then
                        screenGui:Destroy()
                    end
                end)
            end)
        end
        
        -- Call the status UI function
        createStatusUI()
        
        -- Create a cleanup function for when ESP is toggled off
        local cleanupConnection
        cleanupConnection = game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
            if not boolean then
                cleanupConnection:Disconnect()
                return
            end
            
            -- Refresh ESP when character respawns
            wait(1) -- Wait for character to fully load
            
            pcall(function()
                highlightObjects(
                    workspace:FindFirstChild("Police"), 
                    Color3.fromRGB(30, 255, 150),
                    "<stroke color='#000000' thickness='2'><font face='GothamBlack'>GUARD</font></stroke>", 
                    guardIcon
                )
            end)
            
            pcall(function()
                highlightObjects(
                    workspace:FindFirstChild("Cameras"), 
                    Color3.fromRGB(255, 70, 70),
                    "<stroke color='#000000' thickness='2'><font face='GothamBlack'>CAMERA</font></stroke>", 
                    cameraIcon
                )
            end)
        end)
        
        -- Add health ESP for guards with humanoids
        local function addHealthTracking(folder, labelColor)
            if not folder then return end
            
            local function createHealthBar(model)
                if not model:FindFirstChildOfClass("Humanoid") then return end
                
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
                if not root then return end
                
                -- Remove existing health bars
                for _, v in pairs(model:GetChildren()) do
                    if v.Name == "HealthESP" then v:Destroy() end
                end
                
                local healthGui = Instance.new("BillboardGui")
                healthGui.Name = "HealthESP"
                healthGui.Parent = model
                healthGui.Adornee = root
                healthGui.Size = UDim2.new(5, 0, 0.5, 0)
                healthGui.AlwaysOnTop = true
                
                local background = Instance.new("Frame")
                background.Parent = healthGui
                background.Size = UDim2.new(1, 0, 0.2, 0)
                background.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                background.BorderSizePixel = 0
                
                local healthBar = Instance.new("Frame")
                healthBar.Parent = background
                healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth, 0, 1, 0)
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(50, 255, 50), humanoid.Health/humanoid.MaxHealth)
                healthBar.BorderSizePixel = 0
                
                local cornerRadius = Instance.new("UICorner")
                cornerRadius.CornerRadius = UDim.new(0.2, 0)
                cornerRadius.Parent = background
                
                local cornerRadius2 = Instance.new("UICorner")
                cornerRadius2.CornerRadius = UDim.new(0.2, 0)
                cornerRadius2.Parent = healthBar
                
                local stroke = Instance.new("UIStroke")
                stroke.Parent = background
                stroke.Color = labelColor
                stroke.Thickness = 2
                stroke.Transparency = 0.3
                
                -- Add value display
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Parent = background
                valueLabel.BackgroundTransparency = 1
                valueLabel.Size = UDim2.new(1, 0, 1, 0)
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                valueLabel.TextStrokeTransparency = 0.5
                valueLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                valueLabel.TextSize = 12
                
                -- Update health bar continuously
                local healthConnection
                healthConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                    if not healthBar or not healthBar.Parent then
                        if healthConnection then
                            healthConnection:Disconnect()
                        end
                        return
                    end
                    
                    healthBar.Size = UDim2.new(humanoid.Health/humanoid.MaxHealth, 0, 1, 0)
                    healthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(50, 255, 50), humanoid.Health/humanoid.MaxHealth)
                    valueLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                end)
                
                -- Initial value
                valueLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                
                -- Add pulsing animation when health is low
                spawn(function()
                    while healthBar and healthBar.Parent do
                        wait(0.1)
                        if humanoid and humanoid.Health/humanoid.MaxHealth <= 0.3 then
                            for i = 0, 1, 0.1 do
                                if not healthBar or not healthBar.Parent then break end
                                healthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50):Lerp(Color3.fromRGB(255, 150, 150), i)
                                wait(0.05)
                            end
                            for i = 0, 1, 0.1 do
                                if not healthBar or not healthBar.Parent then break end
                                healthBar.BackgroundColor3 = Color3.fromRGB(255, 150, 150):Lerp(Color3.fromRGB(255, 50, 50), i)
                                wait(0.05)
                            end
                        end
                    end
                end)
                
                -- Clean up when model is removed
                model.AncestryChanged:Connect(function(_, parent)
                    if parent == nil and healthConnection then
                        healthConnection:Disconnect()
                    end
                end)
            end
            
            -- Apply to existing models
            for _, model in pairs(folder:GetChildren()) do
                task.spawn(function()
                    pcall(function()
                        createHealthBar(model)
                    end)
                end)
            end
            
            -- Apply to new models
            folder.ChildAdded:Connect(function(model)
                task.spawn(function()
                    pcall(function()
                        wait(0.1) -- Small delay to ensure model is fully loaded
                        createHealthBar(model)
                    end)
                end)
            end)
        end
        
        -- Add health tracking for guards
        pcall(function()
            addHealthTracking(workspace:FindFirstChild("Police"), Color3.fromRGB(30, 255, 150))
        end)
    end
})

Section:Toggle({
    text = "Auto Throw Bag 💰",
    state = false,
    callback = function(state)
        getgenv().AutoThrowBag = state
        
        if getgenv().AutoThrowBag then
            coroutine.wrap(function()
                while getgenv().AutoThrowBag do
                    game:GetService("RunService").Heartbeat:Wait()
                    local args = {
                        [1] = Vector3.new(0.9790925979614258, -0.07362937182188034, -0.1896216869354248)
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RS_Package"):WaitForChild("Remotes"):WaitForChild("ThrowBag"):FireServer(unpack(args))
                end
            end)()
        end
    end
})



Section:Toggle({
    text = "Auto Yell All Npc 🧑",
    state = false,
    callback = function(state)
        getgenv().AutoYellAllNpc = state
        
        if getgenv().AutoYellAllNpc then
            coroutine.wrap(function()
                while getgenv().AutoYellAllNpc do
                    pcall(function()
                        local ohTable1 = {}
                        
                        -- Safely get Citizens, with error checking
                        local citizensFolder = workspace:FindFirstChild("Citizens")
                        if not citizensFolder then 
                            warn("Citizens folder not found!")
                            getgenv().AutoYellAllNpc = false
                            return 
                        end

                        -- Carefully add models to table with type checking
                        for _, child in pairs(citizensFolder:GetChildren()) do
                            if child:IsA("Model") and child:FindFirstChild("Humanoid") then
                                table.insert(ohTable1, child)
                            end
                        end

                        -- Limit the number of NPCs to prevent overwhelming the server
                        if #ohTable1 > 20 then
                            ohTable1 = {unpack(ohTable1, 1, 20)}
                        end

                        -- Fire server event with safeguards
                        local yellRemote = game:GetService("ReplicatedStorage"):FindFirstChild("RS_Package")
                        if yellRemote then
                            local remotes = yellRemote:FindFirstChild("Remotes")
                            if remotes then
                                local playerYellRemote = remotes:FindFirstChild("PlayerYell")
                                if playerYellRemote then
                                    playerYellRemote:FireServer(ohTable1)
                                end
                            end
                        end
                    end)
                    
                    -- Added longer wait to reduce server load
                    task.wait(1)
                end
            end)()
        end
    end
})

Section:Button({
    text = "Restrain All Citizens 🎭",
    callback = function()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function restrainCitizens()
    local citizensFolder = workspace:WaitForChild("Citizens")
    local allRestrained = false
    
    while not allRestrained do
        allRestrained = true
        
        for _, citizen in pairs(citizensFolder:GetChildren()) do
            if citizen:IsA("Model") and 
               not citizen.Name:find("CitizenTied") and 
               citizen:FindFirstChild("Torso") and 
               citizen:FindFirstChild("Torso"):FindFirstChild("ProximityPrompt") then
                
                allRestrained = false
                
                -- Teleport player near the citizen
                humanoidRootPart.CFrame = citizen.Torso.CFrame * CFrame.new(0, 0, 3)
                wait(0.1)
                
                local proximityPrompt = citizen:FindFirstChild("Torso"):FindFirstChild("ProximityPrompt")
                
                local args = {
                    [1] = proximityPrompt
                }
                
                -- Start interaction
                game:GetService("ReplicatedStorage"):WaitForChild("RS_Package"):WaitForChild("Remotes"):WaitForChild("StartInteraction"):FireServer(unpack(args))
                
                -- Complete interaction
                game:GetService("ReplicatedStorage"):WaitForChild("RS_Package"):WaitForChild("Remotes"):WaitForChild("CompleteInteraction"):FireServer(unpack(args))
                
                wait(0.2) -- Small delay between citizens
            end
        end
        
        if allRestrained then
            break
        end
        
        wait(0.5) -- Wait before checking again
    end
    
    print("All citizens restrained!")
end

-- Execute the function
restrainCitizens()
    end,
})




-- Add this before the toggle section
local selectedMap = "None"




--[[
    blacklisted keybind:
        Return
        Space
        Tab
        W,A,S,D,I,O
        Unknown
]]
