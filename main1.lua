-- Advanced Roblox UI Library
-- A sophisticated, feature-rich UI library with shadows, animations, and modern components

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local AdvancedUI = {}
AdvancedUI.__index = AdvancedUI

-- Utility Functions
local Util = {}

function Util.Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

function Util.Tween(instance, properties, duration, easingStyle, easingDirection, delay)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out,
        0, false, delay or 0
    )
    
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Util.Shadow(parent, size, transparency, color, offset)
    local shadow = Util.Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, offset or 2),
        Size = UDim2.new(1, size or 12, 1, size or 12),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://5554236805", -- Shadow image
        ImageColor3 = color or Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.65,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = parent
    })
    return shadow
end

function Util.Ripple(button, x, y)
    local ripple = Util.Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = button.ZIndex + 1,
        Parent = button
    })
    
    local corner = Util.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    Util.Tween(ripple, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, maxSize, 0, maxSize)
    }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Theme Configuration
local DefaultTheme = {
    Primary = Color3.fromRGB(50, 110, 255),     -- Main accent color
    Secondary = Color3.fromRGB(35, 40, 45),     -- Secondary color for backgrounds
    Background = Color3.fromRGB(25, 30, 35),    -- Main background color
    BackgroundDark = Color3.fromRGB(20, 25, 30), -- Darker background for contrast
    Text = Color3.fromRGB(255, 255, 255),       -- Primary text color
    TextDark = Color3.fromRGB(200, 200, 200),   -- Secondary text color
    Success = Color3.fromRGB(45, 180, 100),     -- Success indicators
    Warning = Color3.fromRGB(255, 190, 50),     -- Warning indicators
    Error = Color3.fromRGB(255, 65, 65),        -- Error indicators
    Disabled = Color3.fromRGB(120, 120, 120),   -- Disabled elements
    
    -- Component-specific colors
    ButtonColor = Color3.fromRGB(40, 45, 50),
    ButtonHover = Color3.fromRGB(50, 55, 60),
    ButtonActive = Color3.fromRGB(60, 65, 70),
    
    ToggleOn = Color3.fromRGB(50, 110, 255),
    ToggleOff = Color3.fromRGB(80, 85, 90),
    
    SliderBackground = Color3.fromRGB(35, 40, 45),
    SliderFill = Color3.fromRGB(50, 110, 255),
    
    DropdownBackground = Color3.fromRGB(35, 40, 45),
    DropdownItem = Color3.fromRGB(40, 45, 50),
    DropdownHover = Color3.fromRGB(50, 55, 60),
    
    -- Sizes and other configurations
    CornerRadius = UDim.new(0, 6),
    ButtonHeight = 35,
    ToggleHeight = 35,
    SliderHeight = 50,
    DropdownHeight = 35,
    InputHeight = 35,
    Padding = 8
}

-- Initialize the UI Library
function AdvancedUI.new(title, theme)
    local screenGui = Util.Create("ScreenGui", {
        Name = "AdvancedUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Handle proper parenting based on environment
    if RunService:IsStudio() then
        screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    else
        screenGui.Parent = game:GetService("CoreGui")
    end
    
    local self = setmetatable({}, AdvancedUI)
    self.ScreenGui = screenGui
    self.Windows = {}
    self.Notifications = {}
    self.Theme = setmetatable(theme or {}, {__index = DefaultTheme})
    self.Active = true
    
    return self
end

-- Create a new window
function AdvancedUI:CreateWindow(title, position, size)
    local window = {}
    window.Elements = {}
    window.Tabs = {}
    window.ActiveTab = nil
    
    -- Create main frame
    local mainFrame = Util.Create("Frame", {
        Name = "Window",
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        Position = position or UDim2.new(0.5, -250, 0.5, -200),
        Size = size or UDim2.new(0, 500, 0, 400),
        ZIndex = 10,
        Parent = self.ScreenGui
    })
    
    -- Apply rounded corners
    local cornerRadius = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = mainFrame
    })
    
    -- Apply shadow effect
    local shadow = Util.Shadow(mainFrame, 30, 0.5, Color3.fromRGB(0, 0, 0), 0)
    
    -- Create title bar
    local titleBar = Util.Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 11,
        Parent = mainFrame
    })
    
    -- Round just the top corners of the title bar
    local titleCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = titleBar
    })
    
    -- Create a frame to cover the bottom corners to create a flat bottom for the title bar
    local bottomCover = Util.Create("Frame", {
        Name = "BottomCover",
        BackgroundColor3 = titleBar.BackgroundColor3,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -8),
        Size = UDim2.new(1, 0, 0, 8),
        ZIndex = 11,
        Parent = titleBar
    })
    
    -- Create title text
    local titleText = Util.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        ZIndex = 12,
        Font = Enum.Font.GothamSemibold,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    -- Create close button
    local closeButton = Util.Create("TextButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        ZIndex = 12,
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.Text,
        TextSize = 24,
        Parent = titleBar
    })
    
    -- Create minimize button
    local minimizeButton = Util.Create("TextButton", {
        Name = "MinimizeButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        ZIndex = 12,
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = self.Theme.Text,
        TextSize = 24,
        Parent = titleBar
    })
    
    -- Create tab container (if tabs are being used)
    local tabContainer = Util.Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = self.Theme.BackgroundDark,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 0, 35),
        ZIndex = 11,
        Visible = false,
        Parent = mainFrame
    })
    
    -- Create content container
    local contentFrame = Util.Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        ZIndex = 11,
        Parent = mainFrame
    })
    
    -- Create scrolling frame for elements
    local scrollFrame = Util.Create("ScrollingFrame", {
        Name = "Elements",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.Primary,
        ZIndex = 12,
        Parent = contentFrame
    })
    
    -- Add padding to the scrolling frame
    local uiPadding = Util.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = scrollFrame
    })
    
    -- Add list layout to organize elements
    local listLayout = Util.Create("UIListLayout", {
        Padding = UDim.new(0, self.Theme.Padding),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollFrame
    })
    
    -- Make window draggable
    local dragging = false
    local dragInput, mousePos, framePos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mousePos
            mainFrame.Position = UDim2.new(
                framePos.X.Scale, 
                framePos.X.Offset + delta.X, 
                framePos.Y.Scale, 
                framePos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        mainFrame:Destroy()
        for i, win in pairs(self.Windows) do
            if win == window then
                table.remove(self.Windows, i)
                break
            end
        end
    end)
    
    -- Minimize button functionality
    local minimized = false
    local originalSize = mainFrame.Size
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            Util.Tween(mainFrame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}, 0.3)
            Util.Tween(contentFrame, {Visible = false}, 0)
            minimizeButton.Text = "+"
            if tabContainer.Visible then
                Util.Tween(tabContainer, {Visible = false}, 0)
            end
        else
            Util.Tween(mainFrame, {Size = originalSize}, 0.3)
            task.wait(0.15)
            Util.Tween(contentFrame, {Visible = true}, 0)
            minimizeButton.Text = "−"
            if #window.Tabs > 0 then
                Util.Tween(tabContainer, {Visible = true}, 0)
            end
        end
    end)
    
    -- Button hover effects
    for _, button in pairs({closeButton, minimizeButton}) do
        button.MouseEnter:Connect(function()
            button.TextColor3 = self.Theme.Primary
        end)
        
        button.MouseLeave:Connect(function()
            button.TextColor3 = self.Theme.Text
        end)
    end
    
    -- Tab system function
    function window:AddTab(name)
        if not window.ActiveTab then
            tabContainer.Visible = true
            contentFrame.Position = UDim2.new(0, 0, 0, 75)
            contentFrame.Size = UDim2.new(1, 0, 1, -75)
        end
        
        local tab = {}
        tab.Elements = {}
        
        -- Create tab button
        local tabButton = Util.Create("TextButton", {
            Name = name .. "Tab",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, TextService:GetTextSize(name, 16, Enum.Font.GothamSemibold, Vector2.new(math.huge, math.huge)).X + 30, 1, 0),
            ZIndex = 12,
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = self.Theme.TextDark,
            TextSize = 16,
            Parent = tabContainer
        })
        
        -- Create tab content container
        local tabContent = Util.Create("ScrollingFrame", {
            Name = name .. "Content",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 1, -20),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = self.Theme.Primary,
            ZIndex = 12,
            Visible = false,
            Parent = contentFrame
        })
        
        -- Add padding to the tab content
        local contentPadding = Util.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            Parent = tabContent
        })
        
        -- Add list layout to organize elements
        local contentLayout = Util.Create("UIListLayout", {
            Padding = UDim.new(0, self.Theme.Padding),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        
        -- Tab selection logic
        tabButton.MouseButton1Click:Connect(function()
            for _, existingTab in pairs(window.Tabs) do
                existingTab.Button.TextColor3 = self.Theme.TextDark
                existingTab.Content.Visible = false
                Util.Tween(existingTab.Button, {BackgroundTransparency = 1}, 0.2)
            end
            
            tabButton.TextColor3 = self.Theme.Primary
            tabContent.Visible = true
            Util.Tween(tabButton, {BackgroundTransparency = 0.8}, 0.2)
            window.ActiveTab = tab
        end)
        
        -- Tab hover effect
        tabButton.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                tabButton.TextColor3 = self.Theme.Text
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                tabButton.TextColor3 = self.Theme.TextDark
            end
        end)
        
        tab.Button = tabButton
        tab.Content = tabContent
        
        table.insert(window.Tabs, tab)
        
        -- Auto-position tab buttons
        local xOffset = 10
        for _, existingTab in pairs(window.Tabs) do
            existingTab.Button.Position = UDim2.new(0, xOffset, 0, 0)
            xOffset = xOffset + existingTab.Button.AbsoluteSize.X + 5
        end
        
        -- Activate this tab if it's the first one
        if #window.Tabs == 1 then
            tabButton.TextColor3 = self.Theme.Primary
            tabContent.Visible = true
            Util.Tween(tabButton, {BackgroundTransparency = 0.8}, 0.2)
            window.ActiveTab = tab
        end
        
        -- Create element functions for this tab
        local yOffset = 0
        
        function tab:AddButton(text, callback)
            return window:AddButton(text, callback, tabContent)
        end
        
        function tab:AddToggle(text, default, callback)
            return window:AddToggle(text, default, callback, tabContent)
        end
        
        function tab:AddSlider(text, min, max, default, callback)
            return window:AddSlider(text, min, max, default, callback, tabContent)
        end
        
        function tab:AddDropdown(text, options, default, callback)
            return window:AddDropdown(text, options, default, callback, tabContent)
        end
        
        function tab:AddColorPicker(text, default, callback)
            return window:AddColorPicker(text, default, callback, tabContent)
        end
        
        function tab:AddTextBox(text, default, callback)
            return window:AddTextBox(text, default, callback, tabContent)
        end
        
        function tab:AddLabel(text, textSize, alignment)
            return window:AddLabel(text, textSize, alignment, tabContent)
        end
        
        function tab:AddDivider()
            return window:AddDivider(tabContent)
        end
        
        function tab:AddSection(text)
            return window:AddSection(text, tabContent)
        end
        
        return tab
    end
    
    -- Updated element functions to support tabs
    function window:AddButton(text, callback, parent)
        callback = callback or function() end
        parent = parent or scrollFrame
        
        local buttonFrame = Util.Create("Frame", {
            Name = text.."Button",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, self.Theme.ButtonHeight),
            Parent = parent
        })
        
        local button = Util.Create("TextButton", {
            Name = "Button",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 12,
            Font = Enum.Font.GothamSemibold,
            Text = "  " .. text,
            TextColor3 = self.Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClipsDescendants = true,
            Parent = buttonFrame
        })
        
        local buttonCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = button
        })
        
        -- Add shadow effect
        local shadow = Util.Shadow(button, 12, 0.7)
        
        -- Add right arrow icon
        local arrowIcon = Util.Create("ImageLabel", {
            Name = "ArrowIcon",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.new(0, 16, 0, 16),
            ZIndex = 13,
            Image = "rbxassetid://6031091004", -- Right arrow icon
            ImageColor3 = self.Theme.Text,
            Parent = button
        })
        
        -- Button effects
        button.MouseEnter:Connect(function()
            Util.Tween(button, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            Util.Tween(button, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        button.MouseButton1Down:Connect(function()
            Util.Tween(button, {BackgroundColor3 = self.Theme.ButtonActive}, 0.1)
        end)
        
        button.MouseButton1Up:Connect(function()
            Util.Tween(button, {BackgroundColor3 = self.Theme.ButtonHover}, 0.1)
        end)
        
        button.MouseButton1Click:Connect(function()
            local x, y = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
            local buttonPos = button.AbsolutePosition
            local buttonSize = button.AbsoluteSize
            
            -- Create ripple effect at mouse position relative to button
            Util.Ripple(button, x - buttonPos.X, y - buttonPos.Y)
            
            callback()
        end)
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        return buttonFrame
    end
    
    function window:AddToggle(text, default, callback, parent)
        default = default or false
        callback = callback or function() end
        parent = parent or scrollFrame
        
        local toggleFrame = Util.Create("Frame", {
            Name = text.."Toggle",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, self.Theme.ToggleHeight),
            Parent = parent
        })
        
        local toggleBackground = Util.Create("Frame", {
            Name = "Background",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 12,
            Parent = toggleFrame
        })
        
        local toggleCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = toggleBackground
        })
        
        -- Add shadow
        local shadow = Util.Shadow(toggleBackground, 12, 0.7)
        
        local toggleLabel = Util.Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            ZIndex = 13,
            Font = Enum.Font.Gotham,
            Text = text,
            TextColor3 = self.Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = toggleBackground
        })
        
        local toggleSwitch = Util.Create("Frame", {
            Name = "Switch",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = default and self.Theme.ToggleOn or self.Theme.ToggleOff,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.new(0, 40, 0, 20),
            ZIndex = 13,
            Parent = toggleBackground
        })
        
        local switchCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = toggleSwitch
        })
        
        local toggleCircle = Util.Create("Frame", {
            Name = "Circle",
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = self.Theme.Text,
            BorderSizePixel = 0,
            Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(0, 16, 0, 16),
            ZIndex = 14,
            Parent = toggleSwitch
        })
        
        local circleCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = toggleCircle
        })
        
        -- Add a subtle shadow to the circle
        local circleShadow = Util.Create("ImageLabel", {
            Name = "Shadow",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1.1, 0, 1.1, 0),
            ZIndex = 13,
            Image = "rbxassetid://5554236805",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.8,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(23, 23, 277, 277),
            Parent = toggleCircle
        })
        
        local state = default
        
        -- Toggle functionality
        toggleBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                
                Util.Tween(toggleSwitch, {
                    BackgroundColor3 = state and self.Theme.ToggleOn or self.Theme.ToggleOff
                }, 0.2)
                
                Util.Tween(toggleCircle, {
                    Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                }, 0.2)
                
                callback(state)
            end
        end)
        
        -- Toggle hover effect
        toggleBackground.MouseEnter:Connect(function()
            Util.Tween(toggleBackground, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        toggleBackground.MouseLeave:Connect(function()
            Util.Tween(toggleBackground, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        return toggleFrame
    end
    
function window:AddSlider(text, min, max, default, callback, parent)
    min = min or 0
    max = max or 100
    default = default or min
    default = math.clamp(default, min, max)
    callback = callback or function() end
    parent = parent or scrollFrame
    
    local sliderFrame = Util.Create("Frame", {
        Name = text.."Slider",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, self.Theme.SliderHeight),
        Parent = parent
    })
    
    local sliderBackground = Util.Create("Frame", {
        Name = "Background",
        BackgroundColor3 = self.Theme.ButtonColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 12,
        Parent = sliderFrame
    })
    
    local sliderCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = sliderBackground
    })
    
    -- Add shadow effect
    local shadow = Util.Shadow(sliderBackground, 12, 0.7)
    
    local sliderLabel = Util.Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        ZIndex = 13,
        Font = Enum.Font.GothamSemibold,
        Text = text,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderBackground
    })
    
    local valueDisplay = Util.Create("TextLabel", {
        Name = "Value",
        BackgroundColor3 = self.Theme.BackgroundDark,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 5),
        Size = UDim2.new(0, 50, 0, 20),
        ZIndex = 14,
        Font = Enum.Font.GothamSemibold,
        Text = tostring(default),
        TextColor3 = self.Theme.Text,
        TextSize = 12,
        Parent = sliderBackground
    })
    
    local valueCorner = Util.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = valueDisplay
    })
    
    local sliderTrack = Util.Create("Frame", {
        Name = "Track",
        BackgroundColor3 = self.Theme.SliderBackground,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 0, 10),
        ZIndex = 13,
        Parent = sliderBackground
    })
    
    local trackCorner = Util.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = sliderTrack
    })
    
    local sliderFill = Util.Create("Frame", {
        Name = "Fill",
        BackgroundColor3 = self.Theme.SliderFill,
        BorderSizePixel = 0,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        ZIndex = 14,
        Parent = sliderTrack
    })
    
    local fillCorner = Util.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = sliderFill
    })
    
    -- Create slider thumb
    local sliderThumb = Util.Create("Frame", {
        Name = "Thumb",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Primary,
        BorderSizePixel = 0,
        Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
        Size = UDim2.new(0, 18, 0, 18),
        ZIndex = 15,
        Parent = sliderTrack
    })
    
    local thumbCorner = Util.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = sliderThumb
    })
    
    -- Add glow effect to thumb
    local thumbGlow = Util.Create("ImageLabel", {
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1.5, 0, 1.5, 0),
        ZIndex = 14,
        Image = "rbxassetid://5554236805",
        ImageColor3 = self.Theme.Primary,
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = sliderThumb
    })
    
    -- Add min/max labels
    local minLabel = Util.Create("TextLabel", {
        Name = "MinLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 40),
        Size = UDim2.new(0, 30, 0, 15),
        ZIndex = 13,
        Font = Enum.Font.Gotham,
        Text = tostring(min),
        TextColor3 = self.Theme.TextDark,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderBackground
    })
    
    local maxLabel = Util.Create("TextLabel", {
        Name = "MaxLabel",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -38, 0, 40),
        Size = UDim2.new(0, 30, 0, 15),
        ZIndex = 13,
        Font = Enum.Font.Gotham,
        Text = tostring(max),
        TextColor3 = self.Theme.TextDark,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderBackground
    })
    
    -- Slider functionality
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        value = math.floor(value * 10) / 10 -- Round to 1 decimal place
        
        local percent = (value - min) / (max - min)
        
        Util.Tween(sliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
        Util.Tween(sliderThumb, {Position = UDim2.new(percent, 0, 0.5, 0)}, 0.1)
        valueDisplay.Text = tostring(value)
        
        callback(value)
    end
    
    local dragging = false
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local relativeX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
            local percent = relativeX / sliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            
            -- Create pulse effect on thumb
            Util.Tween(sliderThumb, {Size = UDim2.new(0, 22, 0, 22)}, 0.1)
            Util.Tween(thumbGlow, {ImageTransparency = 0.5}, 0.1)
            
            updateSlider(value)
        end
    end)
    
    sliderTrack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            
            -- Return thumb to normal size
            Util.Tween(sliderThumb, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
            Util.Tween(thumbGlow, {ImageTransparency = 0.7}, 0.1)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
            local percent = relativeX / sliderTrack.AbsoluteSize.X
            local value = min + (max - min) * percent
            
            updateSlider(value)
        end
    end)
    
    -- Slider hover effect
    sliderBackground.MouseEnter:Connect(function()
        Util.Tween(sliderBackground, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
    end)
    
    sliderBackground.MouseLeave:Connect(function()
        Util.Tween(sliderBackground, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        
        -- Also ensure thumb returns to normal if mouse leaves during drag
        if not dragging then
            Util.Tween(sliderThumb, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
            Util.Tween(thumbGlow, {ImageTransparency = 0.7}, 0.1)
        end
    end)
    
    -- Set initial value
    updateSlider(default)
    
    -- Update canvas size for scrolling
    local canvas = parent
    canvas.CanvasSize = UDim2.new(
        0, 
        0, 
        0, 
        canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
    )
    
    return sliderFrame
end
end
