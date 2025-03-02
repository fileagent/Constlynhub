local UILibrary = {}
UILibrary.__index = UILibrary

-- Colors and settings
local theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 120, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(50, 50, 50),
    Tertiary = Color3.fromRGB(40, 40, 40),
    Hover = Color3.fromRGB(60, 60, 60)
}

-- Initialize the library
function UILibrary.new(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UILibrary"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")
    
    local self = setmetatable({}, UILibrary)
    self.ScreenGui = screenGui
    self.Windows = {}
    
    return self
end

-- Create a new window
function UILibrary:CreateWindow(title)
    local window = {}
    window.Elements = {}
    
    -- Create main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Window"
    mainFrame.Size = UDim2.new(0, 250, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    mainFrame.BackgroundColor3 = theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = self.ScreenGui
    
    -- Create rounded corners
    local cornerRadius = Instance.new("UICorner")
    cornerRadius.CornerRadius = UDim.new(0, 8)
    cornerRadius.Parent = mainFrame
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = theme.Accent
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Create title text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -10, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = theme.Text
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Create content container
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -40)
    contentFrame.Position = UDim2.new(0, 10, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Create scrolling frame for elements
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "Elements"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = theme.Accent
    scrollFrame.Parent = contentFrame
    
    -- Make window draggable
    local dragging = false
    local dragInput, mousePos, framePos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mousePos
            mainFrame.Position = UDim2.new(
                framePos.X.Scale, 
                framePos.X.Offset + delta.X, 
                framePos.Y.Scale, 
                framePos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Window functions
    local yOffset = 0
    local padding = 8
    
    function window:AddButton(text, callback)
        callback = callback or function() end
        
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = text.."Button"
        buttonFrame.Size = UDim2.new(1, 0, 0, 35)
        buttonFrame.Position = UDim2.new(0, 0, 0, yOffset)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.Parent = scrollFrame
        
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundColor3 = theme.Secondary
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = theme.Text
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Parent = buttonFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Button effects
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = theme.Hover
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = theme.Secondary
        end)
        
        button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        yOffset = yOffset + buttonFrame.Size.Y.Offset + padding
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
        
        return buttonFrame
    end
    
    function window:AddToggle(text, default, callback)
        default = default or false
        callback = callback or function() end
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = text.."Toggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 35)
        toggleFrame.Position = UDim2.new(0, 0, 0, yOffset)
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.Parent = scrollFrame
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(1, -50, 1, 0)
        toggleLabel.Position = UDim2.new(0, 0, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = theme.Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("Frame")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
        toggleButton.BackgroundColor3 = default and theme.Accent or theme.Secondary
        toggleButton.BorderSizePixel = 0
        toggleButton.Parent = toggleFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggleButton
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Name = "Circle"
        toggleCircle.Size = UDim2.new(0, 16, 0, 16)
        toggleCircle.Position = default and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2)
        toggleCircle.BackgroundColor3 = theme.Text
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = toggleCircle
        
        local state = default
        
        toggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                toggleCircle:TweenPosition(
                    state and UDim2.new(0, 22, 0, 2) or UDim2.new(0, 2, 0, 2),
                    Enum.EasingDirection.InOut,
                    Enum.EasingStyle.Quad,
                    0.15,
                    true
                )
                toggleButton.BackgroundColor3 = state and theme.Accent or theme.Secondary
                callback(state)
            end
        end)
        
        yOffset = yOffset + toggleFrame.Size.Y.Offset + padding
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
        
        return toggleFrame
    end
    
    function window:AddSlider(text, min, max, default, callback)
        min = min or 0
        max = max or 100
        default = default or min
        callback = callback or function() end
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = text.."Slider"
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.Position = UDim2.new(0, 0, 0, yOffset)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = scrollFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text
        sliderLabel.TextColor3 = theme.Text
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 14
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Size = UDim2.new(0, 30, 0, 20)
        valueLabel.Position = UDim2.new(1, -30, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.TextColor3 = theme.Text
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Name = "Background"
        sliderBg.Size = UDim2.new(1, 0, 0, 10)
        sliderBg.Position = UDim2.new(0, 0, 0, 30)
        sliderBg.BackgroundColor3 = theme.Secondary
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = sliderFrame
        
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(0, 5)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "Fill"
        sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        sliderFill.BackgroundColor3 = theme.Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(0, 5)
        sliderFillCorner.Parent = sliderFill
        
        local function updateSlider(value)
            value = math.clamp(value, min, max)
            valueLabel.Text = tostring(math.floor(value))
            sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            callback(value)
        end
        
        local dragging = false
        
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
                local value = min + (max - min) * (relativeX / sliderBg.AbsoluteSize.X)
                updateSlider(value)
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
                local value = min + (max - min) * (relativeX / sliderBg.AbsoluteSize.X)
                updateSlider(value)
            end
        end)
        
        updateSlider(default)
        
        yOffset = yOffset + sliderFrame.Size.Y.Offset + padding
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
        
        return sliderFrame
    end
    
    table.insert(self.Windows, window)
    return window
end

-- Change theme colors
function UILibrary:SetTheme(newTheme)
    for key, color in pairs(newTheme) do
        if theme[key] then
            theme[key] = color
        end
    end
end

return UILibrary
