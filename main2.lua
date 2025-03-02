-- Modern UI Library for Roblox
-- A sleek, animated UI library with advanced features and smooth transitions

local UILibrary = {}
UILibrary.__index = UILibrary

-- Configuration
local Config = {
    Font = Enum.Font.GothamBold,
    AccentColor = Color3.fromRGB(114, 137, 218), -- Discord-like blue
    BackgroundColor = Color3.fromRGB(32, 34, 37), -- Dark theme
    TextColor = Color3.fromRGB(255, 255, 255),
    ShadowColor = Color3.fromRGB(0, 0, 0),
    CornerRadius = UDim.new(0, 8),
    ButtonHoverColor = Color3.fromRGB(66, 70, 77),
    SliderDefaultColor = Color3.fromRGB(114, 137, 218),
    LoadingColor = Color3.fromRGB(114, 137, 218),
    AnimationSpeed = 0.3, -- Animation duration in seconds
}

-- Utility Functions
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create smooth tween effect
local function createTween(instance, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or Config.AnimationSpeed,
            easingStyle or Enum.EasingStyle.Quint,
            easingDirection or Enum.EasingDirection.Out
        ),
        properties
    )
    return tween
end

-- Apply shadow effect to a UI element
local function applyShadow(parent, intensity, offset)
    intensity = intensity or 0.5
    offset = offset or UDim2.new(0, 4, 0, 4)
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, 0, 0, 0)
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.Image = "rbxassetid://6014261993" -- Shadow image
    shadow.ImageColor3 = Config.ShadowColor
    shadow.ImageTransparency = 1 - intensity
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    
    return shadow
end

-- Apply a ripple effect on click
local function applyRippleEffect(button, rippleColor)
    rippleColor = rippleColor or Color3.fromRGB(255, 255, 255)
    
    local function createRipple(x, y)
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = rippleColor
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        ripple.ZIndex = button.ZIndex + 1
        ripple.Parent = button
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        
        -- Position the ripple where the user clicked
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0, x, 0, y)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        
        -- Animate the ripple
        local growTween = createTween(
            ripple,
            {
                Size = UDim2.new(0, size, 0, size),
                BackgroundTransparency = 1
            },
            0.5,
            Enum.EasingStyle.Sine
        )
        
        growTween:Play()
        growTween.Completed:Connect(function()
            ripple:Destroy()
        end)
    end
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local x, y = input.Position.X - button.AbsolutePosition.X, input.Position.Y - button.AbsolutePosition.Y
            createRipple(x, y)
        end
    end)
end

-- Create the UI main window
function UILibrary.CreateWindow(title, size)
    local window = {}
    setmetatable(window, UILibrary)
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Config.BackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    MainFrame.Size = size or UDim2.new(0, 500, 0, 350)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Apply Shadow
    local shadow = applyShadow(MainFrame, 0.7, UDim2.new(0, 15, 0, 15))
    
    -- Corner rounding
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = Config.CornerRadius
    UICorner.Parent = MainFrame
    
    -- Top bar for title and drag functionality
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Config.AccentColor
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.Parent = MainFrame
    
    -- Corner rounding for TopBar
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    -- Create a bottom cover to fix corner rounding
    local BottomCover = Instance.new("Frame")
    BottomCover.Name = "BottomCover"
    BottomCover.BackgroundColor3 = Config.AccentColor
    BottomCover.BorderSizePixel = 0
    BottomCover.Size = UDim2.new(1, 0, 0, 12)
    BottomCover.Position = UDim2.new(0, 0, 1, -12)
    BottomCover.ZIndex = TopBar.ZIndex
    BottomCover.Parent = TopBar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -30, 1, 0)
    TitleLabel.Font = Config.Font
    TitleLabel.Text = title or "Modern UI"
    TitleLabel.TextColor3 = Config.TextColor
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Config.TextColor
    CloseButton.TextSize = 24
    CloseButton.Parent = TopBar
    
    -- Animation for close button
    CloseButton.MouseEnter:Connect(function()
        createTween(CloseButton, {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        createTween(CloseButton, {TextColor3 = Config.TextColor}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        -- Animate window closing
        local closeTween = createTween(
            MainFrame,
            {
                Size = UDim2.new(0, MainFrame.Size.X.Offset, 0, 0),
                Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 
                                      MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + MainFrame.Size.Y.Offset / 2)
            },
            0.5
        )
        
        closeTween:Play()
        closeTween.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 10, 0, 45)
    ContentContainer.Size = UDim2.new(1, -20, 1, -55)
    ContentContainer.Parent = MainFrame
    
    -- Add scroll functionality
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ScrollBarImageColor3 = Config.AccentColor
    ScrollingFrame.Parent = ContentContainer
    
    -- Make UI draggable
    local isDragging = false
    local dragStart
    local startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            createTween(
                MainFrame, 
                {Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, 
                    startPos.Y.Offset + delta.Y
                )},
                0.1,
                Enum.EasingStyle.Sine
            ):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    -- Sections and containers
    local ElementPadding = 10
    local ElementHeight = 35
    local SectionPadding = 25
    local CurrentSectionY = 0
    
    -- Show window with fade-in animation
    MainFrame.BackgroundTransparency = 1
    TopBar.BackgroundTransparency = 1
    BottomCover.BackgroundTransparency = 1
    
    local initialFadeTween = createTween(
        MainFrame, 
        {BackgroundTransparency = 0},
        0.5
    )
    
    local topBarFadeTween = createTween(
        TopBar, 
        {BackgroundTransparency = 0},
        0.5
    )
    
    local bottomCoverFadeTween = createTween(
        BottomCover, 
        {BackgroundTransparency = 0},
        0.5
    )
    
    initialFadeTween:Play()
    topBarFadeTween:Play()
    bottomCoverFadeTween:Play()
    
    -- Loading Animation
    local function showLoadingAnimation()
        local loadingContainer = Instance.new("Frame")
        loadingContainer.Name = "LoadingContainer"
        loadingContainer.BackgroundColor3 = Config.BackgroundColor
        loadingContainer.BackgroundTransparency = 0.2
        loadingContainer.Size = UDim2.new(1, 0, 1, 0)
        loadingContainer.ZIndex = 100
        loadingContainer.Parent = MainFrame
        
        local loadingBar = Instance.new("Frame")
        loadingBar.Name = "LoadingBar"
        loadingBar.AnchorPoint = Vector2.new(0.5, 0.5)
        loadingBar.BackgroundColor3 = Config.AccentColor
        loadingBar.BorderSizePixel = 0
        loadingBar.Position = UDim2.new(0.5, 0, 0.5, 0)
        loadingBar.Size = UDim2.new(0.7, 0, 0, 6)
        loadingBar.ZIndex = 101
        loadingBar.Parent = loadingContainer
        
        local loadingBarCorner = Instance.new("UICorner")
        loadingBarCorner.CornerRadius = UDim.new(0, 3)
        loadingBarCorner.Parent = loadingBar
        
        local fillBar = Instance.new("Frame")
        fillBar.Name = "FillBar"
        fillBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fillBar.BorderSizePixel = 0
        fillBar.Size = UDim2.new(0, 0, 1, 0)
        fillBar.ZIndex = 102
        fillBar.Parent = loadingBar
        
        local fillBarCorner = Instance.new("UICorner")
        fillBarCorner.CornerRadius = UDim.new(0, 3)
        fillBarCorner.Parent = fillBar
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Name = "LoadingText"
        loadingText.BackgroundTransparency = 1
        loadingText.Position = UDim2.new(0, 0, 0, -30)
        loadingText.Size = UDim2.new(1, 0, 0, 20)
        loadingText.Font = Config.Font
        loadingText.Text = "Loading UI..."
        loadingText.TextColor3 = Config.TextColor
        loadingText.TextSize = 16
        loadingText.ZIndex = 101
        loadingText.Parent = loadingBar
        
        -- Animate loading
        local fillTween = createTween(
            fillBar,
            {Size = UDim2.new(1, 0, 1, 0)},
            1.5,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.InOut
        )
        
        fillTween:Play()
        
        task.delay(1.7, function()
            local fadeTween = createTween(
                loadingContainer,
                {BackgroundTransparency = 1},
                0.5
            )
            
            fadeTween:Play()
            fadeTween.Completed:Connect(function()
                loadingContainer:Destroy()
            end)
        end)
    end
    
    showLoadingAnimation()
    
    -- Function to create a new section
    function window:CreateSection(sectionName)
        local section = {}
        
        -- Section container
        local SectionContainer = Instance.new("Frame")
        SectionContainer.Name = sectionName .. "Section"
        SectionContainer.BackgroundColor3 = Color3.fromRGB(40, 43, 48)
        SectionContainer.BorderSizePixel = 0
        SectionContainer.Position = UDim2.new(0, 0, 0, CurrentSectionY)
        SectionContainer.Size = UDim2.new(1, 0, 0, 40) -- Will be resized as elements are added
        SectionContainer.Parent = ScrollingFrame
        
        -- Apply rounded corners to the section
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 6)
        SectionCorner.Parent = SectionContainer
        
        -- Section shadow
        applyShadow(SectionContainer, 0.5)
        
        -- Section title
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "SectionTitle"
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Position = UDim2.new(0, 15, 0, 0)
        SectionTitle.Size = UDim2.new(1, -30, 0, 35)
        SectionTitle.Font = Config.Font
        SectionTitle.Text = sectionName
        SectionTitle.TextColor3 = Config.TextColor
        SectionTitle.TextSize = 14
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = SectionContainer
        
        -- Element container
        local ElementContainer = Instance.new("Frame")
        ElementContainer.Name = "ElementContainer"
        ElementContainer.BackgroundTransparency = 1
        ElementContainer.Position = UDim2.new(0, 10, 0, 35)
        ElementContainer.Size = UDim2.new(1, -20, 1, -35)
        ElementContainer.Parent = SectionContainer
        
        local ElementY = 0
        
        -- Update ScrollingFrame canvas size
        local function updateCanvasSize()
            SectionContainer.Size = UDim2.new(1, 0, 0, ElementY + 50)
            ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CurrentSectionY + SectionContainer.Size.Y.Offset + SectionPadding)
        end
        
        -- Create a button element
        function section:CreateButton(buttonText, callback)
            callback = callback or function() end
            
            local ButtonContainer = Instance.new("Frame")
            ButtonContainer.Name = buttonText .. "Button"
            ButtonContainer.BackgroundTransparency = 1
            ButtonContainer.Position = UDim2.new(0, 0, 0, ElementY)
            ButtonContainer.Size = UDim2.new(1, 0, 0, ElementHeight)
            ButtonContainer.Parent = ElementContainer
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.BackgroundColor3 = Config.BackgroundColor
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0, 2, 0, 2)
            Button.Size = UDim2.new(1, -4, 1, -4)
            Button.Font = Config.Font
            Button.Text = buttonText
            Button.TextColor3 = Config.TextColor
            Button.TextSize = 14
            Button.Parent = ButtonContainer
            
            -- Apply ripple effect
            applyRippleEffect(Button, Color3.fromRGB(200, 200, 200))
            
            -- Apply hover effect
            Button.MouseEnter:Connect(function()
                createTween(Button, {BackgroundColor3 = Config.ButtonHoverColor}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                createTween(Button, {BackgroundColor3 = Config.BackgroundColor}):Play()
            end)
            
            Button.MouseButton1Click:Connect(callback)
            
            -- Update element position for the next element
            ElementY = ElementY + ElementHeight + ElementPadding
            updateCanvasSize()
            
            return Button
        end
        
        -- Create a toggle element
        function section:CreateToggle(toggleText, defaultValue, callback)
            callback = callback or function() end
            
            local ToggleContainer = Instance.new("Frame")
            ToggleContainer.Name = toggleText .. "Toggle"
            ToggleContainer.BackgroundTransparency = 1
            ToggleContainer.Position = UDim2.new(0, 0, 0, ElementY)
            ToggleContainer.Size = UDim2.new(1, 0, 0, ElementHeight)
            ToggleContainer.Parent = ElementContainer
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 2, 0, 2)
            ToggleLabel.Size = UDim2.new(0.7, -4, 1, -4)
            ToggleLabel.Font = Config.Font
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Config.TextColor
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleContainer
            
            local ToggleSwitch = Instance.new("TextButton")
            ToggleSwitch.Name = "ToggleSwitch"
            ToggleSwitch.BackgroundColor3 = defaultValue and Config.AccentColor or Config.BackgroundColor
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Position = UDim2.new(1, -50, 0, 5)
            ToggleSwitch.Size = UDim2.new(0, 40, 0, 25)
            ToggleSwitch.Font = Config.Font
            ToggleSwitch.Text = defaultValue and "ON" or "OFF"
            ToggleSwitch.TextColor3 = Config.TextColor
            ToggleSwitch.TextSize = 12
            ToggleSwitch.Parent = ToggleContainer
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleSwitch
            
            local function updateToggleState(state)
                if state then
                    createTween(ToggleSwitch, {BackgroundColor3 = Config.AccentColor, TextColor3 = Config.TextColor, Text = "ON"}):Play()
                else
                    createTween(ToggleSwitch, {BackgroundColor3 = Config.BackgroundColor, TextColor3 = Config.TextColor, Text = "OFF"}):Play()
                end
            end
            
            ToggleSwitch.MouseButton1Click:Connect(function()
                defaultValue = not defaultValue
                updateToggleState(defaultValue)
                callback(defaultValue)
            end)
            
            -- Apply hover effect
            ToggleSwitch.MouseEnter:Connect(function()
                createTween(ToggleSwitch, {BackgroundColor3 = Config.ButtonHoverColor}):Play()
            end)
            
            ToggleSwitch.MouseLeave:Connect(function()
                createTween(ToggleSwitch, {BackgroundColor3 = defaultValue and Config.AccentColor or Config.BackgroundColor}):Play()
            end)
            
            -- Initialize the toggle state
            updateToggleState(defaultValue)
            
            -- Update element position for the next element
            ElementY = ElementY + ElementHeight + ElementPadding
            updateCanvasSize()
            
            return ToggleSwitch
        end
        
        -- Create a slider element
        function section:CreateSlider(sliderText, minValue, maxValue, defaultValue, callback)
            callback = callback or function() end
            
            local SliderContainer = Instance.new("Frame")
            SliderContainer.Name = sliderText .. "Slider"
            SliderContainer.BackgroundTransparency = 1
            SliderContainer.Position = UDim2.new(0, 0, 0, ElementY)
            SliderContainer.Size = UDim2.new(1, 0, 0, ElementHeight)
            SliderContainer.Parent = ElementContainer
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 2, 0, 2)
            SliderLabel.Size = UDim2.new(0.5, -4, 1, -4)
            SliderLabel.Font = Config.Font
            SliderLabel.Text = sliderText .. ": " .. defaultValue
            SliderLabel.TextColor3 = Config.TextColor
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderContainer
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "SliderBar"
            SliderBar.BackgroundColor3 = Color3.fromRGB(66, 70, 77)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 0, 0.5, 7)
            SliderBar.Size = UDim2.new(1, 0, 0, 6)
            SliderBar.AnchorPoint = Vector2.new(0, 0)
            SliderBar.Parent = SliderContainer
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 3)
            SliderCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.BackgroundColor3 = Config.SliderDefaultColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(0, 3)
            SliderFillCorner.Parent = SliderFill
            
            local SliderHandle = Instance.new("Frame")
            SliderHandle.Name = "SliderHandle"
            SliderHandle.BackgroundColor3 = Config.AccentColor
            SliderHandle.BorderSizePixel = 0
            SliderHandle.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 0, 0)
            SliderHandle.Size = UDim2.new(0, 16, 1, 0)
            SliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderHandle.ZIndex = 2
            SliderHandle.Parent = SliderBar
            
            local HandleCorner = Instance.new("UICorner")
            HandleCorner.CornerRadius = UDim.new(1, 0)
            HandleCorner.Parent = SliderHandle
            
            local isDraggingSlider = false
            local dragStartSlider
            
            SliderHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    dragStartSlider = input.Position.X
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if isDraggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position.X - dragStartSlider
                    local newPosition = math.clamp(SliderHandle.Position.X.Scale + delta / SliderBar.AbsoluteSize.X, 0, 1)
                    local newValue = minValue + newPosition * (maxValue - minValue)
                    
                    SliderHandle.Position = UDim2.new(newPosition, 0, 0, 0)
                    SliderFill.Size = UDim2.new(newPosition, 0, 1, 0)
                    SliderLabel.Text = sliderText .. ": " .. string.format("%.2f", newValue)
                    
                    callback(newValue)
                    dragStartSlider = input.Position.X
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                end
            end)
            
            -- Update element position for the next element
            ElementY = ElementY + ElementHeight + ElementPadding
            updateCanvasSize()
            
            return SliderBar
        end
        
        CurrentSectionY = CurrentSectionY + SectionContainer.Size.Y.Offset + SectionPadding
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, CurrentSectionY)
        
        return section
    end
    
    return window
end

return UILibrary
