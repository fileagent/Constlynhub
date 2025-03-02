-- Advanced Roblox UI Library with Icons
-- A sophisticated, feature-rich UI library with shadows, icons, animations, and modern components

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local ContentProvider = game:GetService("ContentProvider")

local AdvancedUI = {}
AdvancedUI.__index = AdvancedUI

-- Icon presets (mapping friendly names to asset IDs)
local Icons = {
    -- General icons
    Settings = "rbxassetid://3926307971",
    Home = "rbxassetid://3926305904",
    Search = "rbxassetid://3926305904",
    Menu = "rbxassetid://3926307971",
    Close = "rbxassetid://3926305904",
    Plus = "rbxassetid://3926307971",
    Minus = "rbxassetid://3926307971",
    Check = "rbxassetid://3926305904",
    Warning = "rbxassetid://3926305904",
    Info = "rbxassetid://3926305904",
    Success = "rbxassetid://3926305904",
    Error = "rbxassetid://3926305904",
    User = "rbxassetid://3926307971",
    Lock = "rbxassetid://3926305904",
    Heart = "rbxassetid://3926307971",
    Star = "rbxassetid://3926307971",
    
    -- Game specific
    Coins = "rbxassetid://3926307971",
    Burger = "rbxassetid://3926307971",
    Soda = "rbxassetid://3926307971",
    Fries = "rbxassetid://3926305904",
    Sushi = "rbxassetid://3926307971",
    Cake = "rbxassetid://3926307971",
    
    -- Arrow icons
    ArrowRight = "rbxassetid://3926305904",
    ArrowLeft = "rbxassetid://3926305904",
    ArrowUp = "rbxassetid://3926305904",
    ArrowDown = "rbxassetid://3926305904",
}

-- Icon ImageRects (specific regions for sprite sheets)
local IconRects = {
    Settings = Rect.new(324, 124, 444, 244),
    Home = Rect.new(964, 204, 1084, 324),
    Search = Rect.new(964, 324, 1084, 444),
    Menu = Rect.new(564, 764, 684, 884),
    Close = Rect.new(284, 4, 404, 124),
    Plus = Rect.new(984, 4, 1104, 124),
    Minus = Rect.new(564, 884, 684, 1004),
    Check = Rect.new(404, 124, 524, 244),
    Warning = Rect.new(164, 764, 284, 884),
    Info = Rect.new(524, 524, 644, 644),
    Success = Rect.new(764, 244, 884, 364),
    Error = Rect.new(124, 124, 244, 244),
    User = Rect.new(124, 764, 244, 884),
    Lock = Rect.new(4, 684, 124, 804),
    Heart = Rect.new(204, 564, 324, 684),
    Star = Rect.new(924, 444, 1044, 564),
    
    -- Game specific
    Coins = Rect.new(44, 164, 164, 284),
    Burger = Rect.new(684, 444, 804, 564),
    Soda = Rect.new(764, 684, 884, 804),
    Fries = Rect.new(764, 124, 884, 244),
    Sushi = Rect.new(204, 404, 324, 524),
    Cake = Rect.new(44, 404, 164, 524),
    
    -- Arrow icons
    ArrowRight = Rect.new(764, 724, 884, 844),
    ArrowLeft = Rect.new(404, 764, 524, 884),
    ArrowUp = Rect.new(244, 724, 364, 844),
    ArrowDown = Rect.new(444, 884, 564, 1004),
}

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

function Util.CreateIcon(iconId, iconRect, size, position, color, parent, zIndex)
    local icon = Util.Create("ImageLabel", {
        Name = "Icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = position or UDim2.new(0, 0, 0.5, 0),
        Size = size or UDim2.new(0, 20, 0, 20),
        ZIndex = zIndex or 20,
        Image = iconId,
        ImageRectOffset = iconRect and Vector2.new(iconRect.Min.X, iconRect.Min.Y) or Vector2.new(0, 0),
        ImageRectSize = iconRect and Vector2.new(
            iconRect.Max.X - iconRect.Min.X, 
            iconRect.Max.Y - iconRect.Min.Y
        ) or Vector2.new(0, 0),
        ImageColor3 = color or Color3.fromRGB(255, 255, 255),
        Parent = parent
    })
    return icon
end

function Util.CreateGlow(parent, size, transparency, color)
    local glow = Util.Create("ImageLabel", {
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Color3.fromRGB(255, 255, 255),
        ImageTransparency = transparency or 0.9,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = parent
    })
    return glow
end

function Util.CreateTooltip(parent, text, theme)
    local tooltip = Util.Create("Frame", {
        Name = "Tooltip",
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, -40),
        AnchorPoint = Vector2.new(0.5, 1),
        Size = UDim2.new(0, 0, 0, 30),
        ZIndex = 100,
        Visible = false,
        Parent = parent.Parent
    })
    
    local tooltipCorner = Util.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = tooltip
    })
    
    local tooltipShadow = Util.Shadow(tooltip, 15, 0.5)
    
    local tooltipText = Util.Create("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 12,
        ZIndex = 101,
        Parent = tooltip
    })
    
    -- Create arrow pointing down
    local arrow = Util.Create("Frame", {
        Name = "Arrow",
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.new(0, 10, 0, 10),
        Rotation = 45,
        ZIndex = 100,
        Parent = tooltip
    })
    
    -- Calculate tooltip width based on text size
    local textWidth = TextService:GetTextSize(
        text, 
        12, 
        Enum.Font.Gotham, 
        Vector2.new(1000, 100)
    ).X
    
    tooltip.Size = UDim2.new(0, textWidth + 24, 0, 30)
    
    -- Show/hide tooltip
    parent.MouseEnter:Connect(function()
        tooltip.Visible = true
        Util.Tween(tooltip, {Size = UDim2.new(0, textWidth + 24, 0, 30)}, 0.2)
    end)
    
    parent.MouseLeave:Connect(function()
        Util.Tween(tooltip, {Size = UDim2.new(0, 0, 0, 30)}, 0.2)
        task.wait(0.2)
        tooltip.Visible = false
    end)
    
    return tooltip
end

-- Theme Configuration
local DefaultTheme = {
    Primary = Color3.fromRGB(50, 110, 255),     -- Main accent color
    PrimaryDark = Color3.fromRGB(40, 90, 230),  -- Darker shade of primary
    PrimaryLight = Color3.fromRGB(70, 130, 255),-- Lighter shade of primary
    Secondary = Color3.fromRGB(35, 40, 45),     -- Secondary color for backgrounds
    Background = Color3.fromRGB(25, 30, 35),    -- Main background color
    BackgroundDark = Color3.fromRGB(20, 25, 30),-- Darker background for contrast
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
    ButtonHeight = 40,
    ToggleHeight = 40,
    SliderHeight = 60,
    DropdownHeight = 40,
    InputHeight = 40,
    Padding = 8
}

-- Presets
local ThemePresets = {
    Dark = DefaultTheme,
    
    Light = {
        Primary = Color3.fromRGB(50, 110, 255),
        PrimaryDark = Color3.fromRGB(40, 90, 230),
        PrimaryLight = Color3.fromRGB(70, 130, 255),
        Secondary = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(255, 255, 255),
        BackgroundDark = Color3.fromRGB(245, 245, 245),
        Text = Color3.fromRGB(50, 50, 50),
        TextDark = Color3.fromRGB(100, 100, 100),
        Success = Color3.fromRGB(45, 180, 100),
        Warning = Color3.fromRGB(255, 190, 50),
        Error = Color3.fromRGB(255, 65, 65),
        Disabled = Color3.fromRGB(180, 180, 180),
        
        ButtonColor = Color3.fromRGB(240, 240, 240),
        ButtonHover = Color3.fromRGB(230, 230, 230),
        ButtonActive = Color3.fromRGB(220, 220, 220),
        
        ToggleOn = Color3.fromRGB(50, 110, 255),
        ToggleOff = Color3.fromRGB(180, 180, 180),
        
        SliderBackground = Color3.fromRGB(220, 220, 220),
        SliderFill = Color3.fromRGB(50, 110, 255),
        
        DropdownBackground = Color3.fromRGB(240, 240, 240),
        DropdownItem = Color3.fromRGB(230, 230, 230),
        DropdownHover = Color3.fromRGB(220, 220, 220),
        
        CornerRadius = UDim.new(0, 6),
        ButtonHeight = 40,
        ToggleHeight = 40,
        SliderHeight = 60,
        DropdownHeight = 40,
        InputHeight = 40,
        Padding = 8
    },
    
    Cyberpunk = {
        Primary = Color3.fromRGB(0, 230, 255),
        PrimaryDark = Color3.fromRGB(0, 200, 225),
        PrimaryLight = Color3.fromRGB(50, 240, 255),
        Secondary = Color3.fromRGB(30, 30, 45),
        Background = Color3.fromRGB(20, 20, 30),
        BackgroundDark = Color3.fromRGB(15, 15, 25),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(0, 255, 170),
        Warning = Color3.fromRGB(255, 230, 0),
        Error = Color3.fromRGB(255, 0, 80),
        Disabled = Color3.fromRGB(100, 100, 130),
        
        ButtonColor = Color3.fromRGB(30, 30, 45),
        ButtonHover = Color3.fromRGB(40, 40, 55),
        ButtonActive = Color3.fromRGB(50, 50, 65),
        
        ToggleOn = Color3.fromRGB(0, 230, 255),
        ToggleOff = Color3.fromRGB(70, 70, 90),
        
        SliderBackground = Color3.fromRGB(30, 30, 45),
        SliderFill = Color3.fromRGB(0, 230, 255),
        
        DropdownBackground = Color3.fromRGB(30, 30, 45),
        DropdownItem = Color3.fromRGB(40, 40, 55),
        DropdownHover = Color3.fromRGB(50, 50, 65),
        
        CornerRadius = UDim.new(0, 2),
        ButtonHeight = 40,
        ToggleHeight = 40,
        SliderHeight = 60,
        DropdownHeight = 40,
        InputHeight = 40,
        Padding = 8
    },
    
    FoodTheme = {
        Primary = Color3.fromRGB(255, 100, 50),
        PrimaryDark = Color3.fromRGB(230, 80, 30),
        PrimaryLight = Color3.fromRGB(255, 120, 70),
        Secondary = Color3.fromRGB(45, 35, 30),
        Background = Color3.fromRGB(35, 25, 20),
        BackgroundDark = Color3.fromRGB(30, 20, 15),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(220, 220, 210),
        Success = Color3.fromRGB(100, 200, 70),
        Warning = Color3.fromRGB(255, 210, 50),
        Error = Color3.fromRGB(255, 80, 80),
        Disabled = Color3.fromRGB(130, 120, 110),
        
        ButtonColor = Color3.fromRGB(45, 35, 30),
        ButtonHover = Color3.fromRGB(55, 45, 40),
        ButtonActive = Color3.fromRGB(65, 55, 50),
        
        ToggleOn = Color3.fromRGB(255, 100, 50),
        ToggleOff = Color3.fromRGB(90, 80, 75),
        
        SliderBackground = Color3.fromRGB(45, 35, 30),
        SliderFill = Color3.fromRGB(255, 100, 50),
        
        DropdownBackground = Color3.fromRGB(45, 35, 30),
        DropdownItem = Color3.fromRGB(55, 45, 40),
        DropdownHover = Color3.fromRGB(65, 55, 50),
        
        CornerRadius = UDim.new(0, 8),
        ButtonHeight = 40,
        ToggleHeight = 40,
        SliderHeight = 60,
        DropdownHeight = 40,
        InputHeight = 40,
        Padding = 8
    }
}

-- Initialize the UI Library
function AdvancedUI.new(title, themePreset)
    local theme
    if type(themePreset) == "string" and ThemePresets[themePreset] then
        theme = ThemePresets[themePreset]
    elseif type(themePreset) == "table" then
        theme = setmetatable(themePreset, {__index = DefaultTheme})
    else
        theme = DefaultTheme
    end
    
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
    
    local notificationFrame = Util.Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -20, 0, 20),
        Size = UDim2.new(0, 300, 1, -40),
        AnchorPoint = Vector2.new(1, 0),
        ZIndex = 1000,
        Parent = screenGui
    })
    
    local notificationLayout = Util.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = notificationFrame
    })
    
    local self = setmetatable({}, AdvancedUI)
    self.ScreenGui = screenGui
    self.NotificationFrame = notificationFrame
    self.Windows = {}
    self.Theme = theme
    self.Active = true
    
    return self
end

-- Send notification
function AdvancedUI:Notify(title, message, notifType, duration)
    notifType = notifType or "Info" -- Info, Success, Warning, Error
    duration = duration or 5 -- seconds
    
    local colorMap = {
        Info = self.Theme.Primary,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error
    }
    
    local iconMap = {
        Info = {icon = "Info", color = self.Theme.Primary},
        Success = {icon = "Success", color = self.Theme.Success},
        Warning = {icon = "Warning", color = self.Theme.Warning},
        Error = {icon = "Error", color = self.Theme.Error}
    }
    
    local color = colorMap[notifType] or self.Theme.Primary
    local iconInfo = iconMap[notifType] or iconMap.Info
    
    -- Create notification container
    local notification = Util.Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 0), -- Start with 0 height and expand
        ZIndex = 1000,
        Parent = self.NotificationFrame
    })
    
    local notifCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = notification
    })
    
    local notifShadow = Util.Shadow(notification, 15, 0.5)
    
    -- Colored left bar
    local leftBar = Util.Create("Frame", {
        Name = "LeftBar",
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Size = UDim2.new(0,
         4, 1, 0),
        ZIndex = 1001,
        Parent = notification
    })
    
    local leftBarCorner = Util.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = leftBar
    })
    
    -- Icon
    local icon = Util.CreateIcon(
        Icons[iconInfo.icon], 
        IconRects[iconInfo.icon], 
        UDim2.new(0, 24, 0, 24), 
        UDim2.new(0, 22, 0, 22), 
        iconInfo.color, 
        notification, 
        1002
    )
    
    -- Title
    local titleLabel = Util.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 10),
        Size = UDim2.new(1, -90, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1001,
        Parent = notification
    })
    
    -- Message
    local messageLabel = Util.Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 32),
        Size = UDim2.new(1, -55, 0, 0), -- Will be resized based on text
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = 1001,
        Parent = notification
    })
    
    -- Close button
    local closeButton = Util.Create("TextButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 10),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.TextDark,
        TextSize = 20,
        ZIndex = 1002,
        Parent = notification
    })
    
    -- Calculate message height
    local textSize = TextService:GetTextSize(
        message,
        12,
        Enum.Font.Gotham,
        Vector2.new(notification.AbsoluteSize.X - 55, 1000)
    )
    
    local messageHeight = math.min(60, textSize.Y) -- Cap at 60 pixels
    messageLabel.Size = UDim2.new(1, -55, 0, messageHeight)
    
    -- Calculate total height
    local totalHeight = 42 + messageHeight
    
    -- Set notification position and animate in
    notification.Size = UDim2.new(1, 0, 0, 0)
    notification.BackgroundTransparency = 1
    notification.Position = UDim2.new(0, 20, 0, 0)
    
    -- Animation sequence
    Util.Tween(notification, {
        Size = UDim2.new(1, 0, 0, totalHeight),
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 0, 0, 0)
    }, 0.3, Enum.EasingStyle.Quint)
    
    -- Close button hover effect
    closeButton.MouseEnter:Connect(function()
        closeButton.TextColor3 = self.Theme.Error
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.TextColor3 = self.Theme.TextDark
    end)
    
    -- Close notification function
    local function closeNotification()
        Util.Tween(notification, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, 0),
            Size = UDim2.new(1, 0, 0, 0)
        }, 0.3, Enum.EasingStyle.Quint)
        
        task.wait(0.3)
        notification:Destroy()
    end
    
    -- Close on button click
    closeButton.MouseButton1Click:Connect(closeNotification)
    
    -- Auto close after duration
    task.delay(duration, closeNotification)
    
    return notification
end

-- Create a new window
function AdvancedUI:CreateWindow(title, position, size, icon)
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
    
    -- Add window icon if provided
    if icon and Icons[icon] then
        local windowIcon = Util.CreateIcon(
            Icons[icon],
            IconRects[icon],
            UDim2.new(0, 20, 0, 20),
            UDim2.new(0, 20, 0.5, 0),
            self.Theme.Primary,
            titleBar,
            12
        )
        
        -- Create title text with offset for icon
        local titleText = Util.Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 45, 0, 0),
            Size = UDim2.new(1, -125, 1, 0),
            ZIndex = 12,
            Font = Enum.Font.GothamSemibold,
            Text = title,
            TextColor3 = self.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleBar
        })
    else
        -- Create title text without icon
        local titleText = Util.Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(1, -100, 1, 0),
            ZIndex = 12,
            Font = Enum.Font.GothamSemibold,
            Text = title,
            TextColor3 = self.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = titleBar
        })
    end
    
    -- Create close button with icon
    local closeButton = Util.Create("TextButton", {
        Name = "CloseButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        ZIndex = 12,
        Text = "",
        Parent = titleBar
    })
    
    local closeIcon = Util.CreateIcon(
        Icons.Close,
        IconRects.Close,
        UDim2.new(0, 16, 0, 16),
        UDim2.new(0.5, 0, 0.5, 0),
        self.Theme.Text,
        closeButton,
        13
    )
    
    -- Create minimize button with icon
    local minimizeButton = Util.Create("TextButton", {
        Name = "MinimizeButton",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        ZIndex = 12,
        Text = "",
        Parent = titleBar
    })
    
    local minimizeIcon = Util.CreateIcon(
        Icons.Minus,
        IconRects.Minus,
        UDim2.new(0, 16, 0, 16),
        UDim2.new(0.5, 0, 0.5, 0),
        self.Theme.Text,
        minimizeButton,
        13
    )
    
    -- Create tab container
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
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
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
        Util.Tween(mainFrame, {
            Size = UDim2.new(0, mainFrame.AbsoluteSize.X, 0, 0),
            Position = UDim2.new(
                mainFrame.Position.X.Scale,
                mainFrame.Position.X.Offset,
                mainFrame.Position.Y.Scale,
                mainFrame.Position.Y.Offset + mainFrame.AbsoluteSize.Y/2
            ),
            BackgroundTransparency = 1
        }, 0.3, Enum.EasingStyle.Quart)
        
        task.wait(0.3)
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
    local originalContentPosition = contentFrame.Position
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            Util.Tween(mainFrame, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}, 0.3)
            Util.Tween(contentFrame, {Visible = false}, 0)
            Util.Tween(minimizeIcon, {Rotation = 180}, 0.3)
            if tabContainer.Visible then
                Util.Tween(tabContainer, {Visible = false}, 0)
            end
        else
            Util.Tween(mainFrame, {Size = originalSize}, 0.3)
            task.wait(0.15)
            Util.Tween(contentFrame, {Visible = true}, 0)
            Util.Tween(minimizeIcon, {Rotation = 0}, 0.3)
            if #window.Tabs > 0 then
                Util.Tween(tabContainer, {Visible = true}, 0)
            end
        end
    end)
    
    -- Button hover effects
    for _, button in pairs({closeButton, minimizeButton}) do
        button.MouseEnter:Connect(function()
            local icon = button:FindFirstChild("Icon")
            if icon then
                Util.Tween(icon, {ImageColor3 = self.Theme.Primary}, 0.2)
            end
        end)
        
        button.MouseLeave:Connect(function()
            local icon = button:FindFirstChild("Icon")
            if icon then
                Util.Tween(icon, {ImageColor3 = self.Theme.Text}, 0.2)
            end
        end)
    end
    
    -- Tab system function
    function window:AddTab(name, icon)
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
            BackgroundColor3 = self.Theme.Secondary,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, TextService:GetTextSize(name, 14, Enum.Font.GothamSemibold, Vector2.new(1000, 100)).X + (icon and 40 or 20), 0, 35),
            ZIndex = 12,
            Text = "",
            Parent = tabContainer
        })
        
        local tabCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = tabButton
        })
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local tabIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 15, 0.5, 0),
                self.Theme.TextDark,
                tabButton,
                13
            )
            
            -- Create tab text with offset for icon
            local tabText = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 35, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = name,
                TextColor3 = self.Theme.TextDark,
                TextSize = 14,
                ZIndex = 13,
                Parent = tabButton
            })
            
            tab.Icon = tabIcon
        else
            -- Create tab text without icon
            local tabText = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = name,
                TextColor3 = self.Theme.TextDark,
                TextSize = 14,
                ZIndex = 13,
                Parent = tabButton
            })
        end
        
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
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
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
                existingTab.Button.BackgroundTransparency = 1
                existingTab.Button.Text.TextColor3 = self.Theme.TextDark
                if existingTab.Icon then
                    existingTab.Icon.ImageColor3 = self.Theme.TextDark
                end
                existingTab.Content.Visible = false
            end
            
            tabButton.BackgroundTransparency = 0.8
            tabButton.Text.TextColor3 = self.Theme.Primary
            if tab.Icon then
                tab.Icon.ImageColor3 = self.Theme.Primary
            end
            tabContent.Visible = true
            window.ActiveTab = tab
        end)
        
        -- Tab hover effect
        tabButton.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                Util.Tween(tabButton, {BackgroundTransparency = 0.9}, 0.2)
                tabButton.Text.TextColor3 = self.Theme.Text
                if tab.Icon then
                    tab.Icon.ImageColor3 = self.Theme.Text
                end
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                Util.Tween(tabButton, {BackgroundTransparency = 1}, 0.2)
                tabButton.Text.TextColor3 = self.Theme.TextDark
                if tab.Icon then
                    tab.Icon.ImageColor3 = self.Theme.TextDark
                end
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
            tabButton.BackgroundTransparency = 0.8
            tabButton.Text.TextColor3 = self.Theme.Primary
            if tab.Icon then
                tab.Icon.ImageColor3 = self.Theme.Primary
            end
            tabContent.Visible = true
            window.ActiveTab = tab
        end
        
        -- Element creation functions for the tab
        function tab:AddButton(text, callback, buttonIcon)
            return window:AddButton(text, callback, tabContent, buttonIcon)
        end
        
        function tab:AddToggle(text, default, callback, toggleIcon)
            return window:AddToggle(text, default, callback, tabContent, toggleIcon)
        end
        
        function tab:AddSlider(text, min, max, default, callback, sliderIcon)
            return window:AddSlider(text, min, max, default, callback, tabContent, sliderIcon)
        end
        
        function tab:AddDropdown(text, options, default, callback, dropdownIcon)
            return window:AddDropdown(text, options, default, callback, tabContent, dropdownIcon)
        end
        
        function tab:AddColorPicker(text, default, callback, colorPickerIcon)
            return window:AddColorPicker(text, default, callback, tabContent, colorPickerIcon)
        end
        
        function tab:AddTextBox(text, default, callback, textboxIcon)
            return window:AddTextBox(text, default, callback, tabContent, textboxIcon)
        end
        
        function tab:AddLabel(text, textSize, alignment, labelIcon)
            return window:AddLabel(text, textSize, alignment, tabContent, labelIcon)
        end
        
        function tab:AddDivider()
            return window:AddDivider(tabContent)
        end
        
        function tab:AddSection(text, sectionIcon)
            return window:AddSection(text, tabContent, sectionIcon)
        end
        
        return tab
    end
    
    -- Create element creation functions
    function window:AddButton(text, callback, parent, icon)
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
            Text = "",
            ClipsDescendants = true,
            Parent = buttonFrame
        })
        
        local buttonCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = button
        })
        
        -- Add shadow effect
        local shadow = Util.Shadow(button, 12, 0.7)
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local buttonIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 15, 0.5, 0),
                self.Theme.Text,
                button,
                13
            )
            
            -- Add text with icon offset
            local buttonText = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -50, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = button
            })
        else
            -- Add text without icon
            local buttonText = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = button
            })
        end
        
        -- Add right arrow icon
        local arrowIcon = Util.CreateIcon(
            Icons.ArrowRight,
            IconRects.ArrowRight,
            UDim2.new(0, 16, 0, 16),
            UDim2.new(1, -15, 0.5, 0),
            self.Theme.Text,
            button,
            13
        )
        
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
    
    function window:AddToggle(text, default, callback, parent, icon)
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
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local toggleIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 15, 0.5, 0),
                self.Theme.Text,
                toggleBackground,
                13
            )
            
            -- Create toggle text with icon offset
            local toggleLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -100, 1, 0),
                ZIndex = 13,
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleBackground
            })
        else
            -- Create toggle text without icon
            local toggleLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -75, 1, 0),
                ZIndex = 13,
                Font = Enum.Font.Gotham,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggleBackground
            })
        end
        
        local toggleSwitch = Util.Create("Frame", {
            Name = "Switch",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = default and self.Theme.ToggleOn or self.Theme.ToggleOff,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -15, 0.5, 0),
            Size = UDim2.new(0, 44, 0, 22),
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
            Position = default and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
            Size = UDim2.new(0, 18, 0, 18),
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
                    Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
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
        
        local toggle = {
            Instance = toggleFrame,
            State = state,
            Set = function(self, newState)
                state = newState
                Util.Tween(toggleSwitch, {
                    BackgroundColor3 = state and self.Theme.ToggleOn or self.Theme.ToggleOff
                }, 0.2)
                
Util.Tween(toggleCircle, {
                    Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                }, 0.2)
                callback(state)
            end
        }
        
        return toggle
    end
    
    function window:AddSlider(text, min, max, default, callback, parent, icon)
        min = min or 0
        max = max or 100
        default = default or min
        callback = callback or function() end
        parent = parent or scrollFrame
        
        -- Clamp default value
        default = math.clamp(default, min, max)
        
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
        
        -- Add shadow
        local shadow = Util.Shadow(sliderBackground, 12, 0.7)
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local sliderIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 15, 0.25, 0),
                self.Theme.Text,
                sliderBackground,
                13
            )
            
            -- Create slider title with icon offset
            local sliderTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -100, 0, 25),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = sliderBackground
            })
        else
            -- Create slider title without icon
            local sliderTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -75, 0, 25),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = sliderBackground
            })
        end
        
        -- Create value display
        local valueDisplay = Util.Create("TextLabel", {
            Name = "Value",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -50, 0, 0),
            Size = UDim2.new(0, 40, 0, 25),
            Font = Enum.Font.GothamSemibold,
            Text = tostring(default),
            TextColor3 = self.Theme.Primary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 13,
            Parent = sliderBackground
        })
        
        -- Create slider bar container
        local sliderContainer = Util.Create("Frame", {
            Name = "SliderContainer",
            BackgroundColor3 = self.Theme.SliderBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 15, 0, 30),
            Size = UDim2.new(1, -30, 0, 14),
            ZIndex = 13,
            Parent = sliderBackground
        })
        
        local containerCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 7),
            Parent = sliderContainer
        })
        
        -- Calculate initial slider position
        local percent = (default - min) / (max - min)
        
        -- Create fill bar
        local sliderFill = Util.Create("Frame", {
            Name = "Fill",
            BackgroundColor3 = self.Theme.SliderFill,
            BorderSizePixel = 0,
            Size = UDim2.new(percent, 0, 1, 0),
            ZIndex = 14,
            Parent = sliderContainer
        })
        
        local fillCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 7),
            Parent = sliderFill
        })
        
        -- Create slider knob
        local sliderKnob = Util.Create("Frame", {
            Name = "Knob",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.Theme.Primary,
            BorderSizePixel = 0,
            Position = UDim2.new(percent, 0, 0.5, 0),
            Size = UDim2.new(0, 22, 0, 22),
            ZIndex = 15,
            Parent = sliderContainer
        })
        
        local knobCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderKnob
        })
        
        -- Add glow effect to the knob
        local knobGlow = Util.CreateGlow(sliderKnob, 30, 0.8, self.Theme.Primary)
        
        -- Slider functionality
        local dragging = false
        
        sliderContainer.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                
                -- Initial move to mouse position
                local percentage = math.clamp(
                    (input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 
                    0, 
                    1
                )
                
                Util.Tween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                Util.Tween(sliderKnob, {Position = UDim2.new(percentage, 0, 0.5, 0)}, 0.1)
                
                local value = math.floor(min + (max - min) * percentage)
                valueDisplay.Text = tostring(value)
                callback(value)
            end
        end)
        
        sliderContainer.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local percentage = math.clamp(
                    (input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 
                    0, 
                    1
                )
                
                Util.Tween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                Util.Tween(sliderKnob, {Position = UDim2.new(percentage, 0, 0.5, 0)}, 0.1)
                
                local value = math.floor(min + (max - min) * percentage)
                valueDisplay.Text = tostring(value)
                callback(value)
            end
        end)
        
        -- Slider hover effect
        sliderBackground.MouseEnter:Connect(function()
            Util.Tween(sliderBackground, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        sliderBackground.MouseLeave:Connect(function()
            Util.Tween(sliderBackground, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        local slider = {
            Instance = sliderFrame,
            Value = default,
            Min = min,
            Max = max,
            Set = function(self, value)
                local newValue = math.clamp(value, min, max)
                local percentage = (newValue - min) / (max - min)
                
                Util.Tween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                Util.Tween(sliderKnob, {Position = UDim2.new(percentage, 0, 0.5, 0)}, 0.1)
                
                valueDisplay.Text = tostring(newValue)
                self.Value = newValue
                callback(newValue)
            end
        }
        
        return slider
    end
    
    function window:AddDropdown(text, options, default, callback, parent, icon)
        options = options or {}
        default = default or options[1] or ""
        callback = callback or function() end
        parent = parent or scrollFrame
        
        local dropdownFrame = Util.Create("Frame", {
            Name = text.."Dropdown",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, self.Theme.DropdownHeight),
            ClipsDescendants = true,
            Parent = parent
        })
        
        local dropdownHeader = Util.Create("Frame", {
            Name = "Header",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, self.Theme.DropdownHeight),
            ZIndex = 12,
            Parent = dropdownFrame
        })
        
        local headerCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = dropdownHeader
        })
        
        -- Add shadow
        local shadow = Util.Shadow(dropdownHeader, 12, 0.7)
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local dropdownIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 15, 0.5, 0),
                self.Theme.Text,
                dropdownHeader,
                13
            )
            
            -- Create dropdown title with icon offset
            local dropdownTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -100, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = dropdownHeader
            })
        else
            -- Create dropdown title without icon
            local dropdownTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -75, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = dropdownHeader
            })
        end
        
        -- Create selected value display
        local selectedValue = Util.Create("TextLabel", {
            Name = "SelectedValue",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -150, 0, 0),
            Size = UDim2.new(0, 130, 1, 0),
            Font = Enum.Font.Gotham,
            Text = default,
            TextColor3 = self.Theme.Primary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 13,
            Parent = dropdownHeader
        })
        
        -- Add arrow icon
        local arrowIcon = Util.CreateIcon(
            Icons.ArrowDown,
            IconRects.ArrowDown,
            UDim2.new(0, 16, 0, 16),
            UDim2.new(1, -15, 0.5, 0),
            self.Theme.Text,
            dropdownHeader,
            13
        )
        
        -- Create dropdown items container
        local dropdownContainer = Util.Create("Frame", {
            Name = "Container",
            BackgroundColor3 = self.Theme.DropdownBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, self.Theme.DropdownHeight),
            Size = UDim2.new(1, 0, 0, 0), -- Will be sized based on options
            ZIndex = 14,
            Parent = dropdownFrame
        })
        
        local containerCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = dropdownContainer
        })
        
        local scrollingFrame = Util.Create("ScrollingFrame", {
            Name = "ScrollFrame",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = self.Theme.Primary,
            ZIndex = 15,
            Parent = dropdownContainer
        })
        
        local listLayout = Util.Create("UIListLayout", {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = scrollingFrame
        })
        
        local paddingFrame = Util.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            Parent = scrollingFrame
        })
        
        -- Populate dropdown items
        local itemButtons = {}
        local containerSize = 10 -- Starting with padding
        
        for i, option in ipairs(options) do
            local itemButton = Util.Create("TextButton", {
                Name = "Item_" .. i,
                BackgroundColor3 = self.Theme.DropdownItem,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -10, 0, 30),
                Font = Enum.Font.Gotham,
                Text = option,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                ZIndex = 16,
                Parent = scrollingFrame
            })
            
            local itemCorner = Util.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = itemButton
            })
            
            itemButton.MouseButton1Click:Connect(function()
                selectedValue.Text = option
                callback(option)
                
                -- Close dropdown
                Util.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, self.Theme.DropdownHeight)}, 0.3)
                Util.Tween(arrowIcon, {Rotation = 0}, 0.3)
            end)
            
            -- Item hover effect
            itemButton.MouseEnter:Connect(function()
                Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownHover}, 0.2)
            end)
            
            itemButton.MouseLeave:Connect(function()
                Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownItem}, 0.2)
            end)
            
            table.insert(itemButtons, itemButton)
            containerSize = containerSize + 32 -- Item height + padding
        end
        
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        containerSize = math.min(containerSize, 200) -- Limit max height
        
        -- Dropdown open/close logic
        local dropdownOpen = false
        
        dropdownHeader.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dropdownOpen = not dropdownOpen
                
                if dropdownOpen then
                    -- Open dropdown
                    Util.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, self.Theme.DropdownHeight + containerSize)}, 0.3)
                    Util.Tween(arrowIcon, {Rotation = 180}, 0.3)
                    dropdownContainer.Size = UDim2.new(1, 0, 0, containerSize)
                else
                    -- Close dropdown
                    Util.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, self.Theme.DropdownHeight)}, 0.3)
                    Util.Tween(arrowIcon, {Rotation = 0}, 0.3)
                end
            end
        end)
        
        -- Dropdown hover effect
        dropdownHeader.MouseEnter:Connect(function()
            Util.Tween(dropdownHeader, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        dropdownHeader.MouseLeave:Connect(function()
            Util.Tween(dropdownHeader, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        local dropdown = {
            Instance = dropdownFrame,
            Value = default,
            Options = options,
            Set = function(self, value)
                if table.find(options, value) then
                    selectedValue.Text = value
                    self.Value = value
                    callback(value)
                end
            end,
            AddOption = function(self, option)
                if not table.find(options, option) then
                    table.insert(options, option)
                    self.Options = options
                    
                    -- Create new item button
                    local itemButton = Util.Create("TextButton", {
                        Name = "Item_" .. #options,
                        BackgroundColor3 = self.Theme.DropdownItem,
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, -10, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = option,
                        TextColor3 = self.Theme.Text,
                        TextSize = 14,
                        ZIndex = 16,
                        Parent = scrollingFrame
                    })
                    
                    local itemCorner = Util.Create("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = itemButton
                    })
                    
                    itemButton.MouseButton1Click:Connect(function()
                        selectedValue.Text = option
                        self.Value = option
                        callback(option)
                        
                        -- Close dropdown
                        Util.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, self.Theme.DropdownHeight)}, 0.3)
                        Util.Tween(arrowIcon, {Rotation = 0}, 0.3)
                        dropdownOpen = false
                    end)
                    
                    -- Item hover effect
                    itemButton.MouseEnter:Connect(function()
                        Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownHover}, 0.2)
                    end)
                    
                    itemButton.MouseLeave:Connect(function()
                        Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownItem}, 0.2)
                    end)
                    
                    -- Update scrolling frame canvas size
                    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
                    
                    -- Recalculate container size
                    containerSize = math.min(10 + (#options * 32), 200)
                end
            end,
            RemoveOption = function(self, option)
                local index = table.find(options, option)
                if index then
                    table.remove(options, index)
                    self.Options = options
                    
                    -- Find and remove the button
                    for _, itemButton in pairs(scrollingFrame:GetChildren()) do
                        if itemButton:IsA("TextButton") and itemButton.Text == option then
                            itemButton:Destroy()
                            break
                        end
                    end
                    
                    -- If the removed option was the selected one, reset to first option
                    if option == self.Value then
                        self.Value = options[1] or ""
                        selectedValue.Text = self.Value
                        callback(self.Value)
                    end
                    
                    -- Update scrolling frame canvas size
                    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
                    
                    -- Recalculate container size
                    containerSize = math.min(10 + (#options * 32), 200)
                end
            end
        }
        
        return dropdown
    end
    
    function window:AddColorPicker(text, default, callback, parent, icon)
        default = default or Color3.fromRGB(255, 255, 255)
        callback = callback or function() end
        parent = parent or scrollFrame
        
        local colorPickerFrame = Util.Create("Frame", {
            Name = text.."ColorPicker",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, self.Theme.ButtonHeight),
            ClipsDescendants = true,
            Parent = parent
        })
        
        local pickerHeader = Util.Create("Frame", {
            Name = "Header",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, self.Theme.ButtonHeight),
            ZIndex = 12,
            Parent = colorPickerFrame
        })
        
        local headerCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = pickerHeader
        })
        
        -- Add shadow
        local shadow = Util.Shadow(pickerHeader, 12, 0.7)
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local colorIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 15, 0.5, 0),
                self.Theme.Text,
                pickerHeader,
                13
            )
            
            -- Create picker title with icon offset
            local pickerTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -100, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = pickerHeader
            })
        else
            -- Create picker title without icon
            local pickerTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -75, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = pickerHeader
            })
        end
        
        -- Create color preview
        local colorPreview = Util.Create("Frame", {
            Name = "Preview",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = default,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -15, 0.5, 0),
            Size = UDim2.new(0, 30, 0, 30),
            ZIndex = 13,
            Parent = pickerHeader
        })
        
        local previewCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = colorPreview
        })
        
        -- Create RGB value display
        local rgbValue = Util.Create("TextLabel", {
            Name = "RGBValue",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -120, 0, 0),
            Size = UDim2.new(0, 100, 1, 0),
            Font = Enum.Font.Gotham,
            Text = string.format("%d, %d, %d", 
                math.floor(default.R * 255), 
                math.floor(default.G * 255), 
                math.floor(default.B * 255)
            ),
            TextColor3 = self.Theme.TextDark,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 13,
            Parent = pickerHeader
        })
        
        -- Create color picker dropdown container
        local pickerContainer = Util.Create("Frame", {
            Name = "Container",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, self.Theme.ButtonHeight),
            Size = UDim2.new(1, 0, 0, 0), -- Will be sized on open
            ZIndex = 15,
            Visible = false,
            Parent = colorPickerFrame
        })
        
        local containerCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = pickerContainer
        })
        
        -- Create HSV color picker
        local hsvPicker = Util.Create("ImageLabel", {
            Name = "HSVPicker",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 0, 150),
            Image = "rbxassetid://4155801252",
            ZIndex = 16,
            Parent = pickerContainer
        })
        
        local hsvCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = hsvPicker
        })
        
        -- Create HSV picker cursor
        local hsvCursor = Util.Create("Frame", {
            Name = "Cursor",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 10, 0, 10),
            ZIndex = 17,
            Parent = hsvPicker
        })
        
        local cursorCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = hsvCursor
        })
        
        local cursorOutline = Util.Create("UIStroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Transparency = 0.5,
            Thickness = 1,
            Parent = hsvCursor
        })
        
        -- Create hue slider
        local hueSlider = Util.Create("Frame", {
            Name = "HueSlider",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 170),
            Size = UDim2.new(1, -20, 0, 20),
            ZIndex = 16,
            Parent = pickerContainer
        })
        
        local hueCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = hueSl,
            Name = "Cursor",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 10, 0, 10),
            ZIndex = 17,
            Parent = hsvPicker
        })
        
        local cursorCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0.5, 0),
            Parent = hsvCursor
        })
        
        -- Create hue slider
        local hueSlider = Util.Create("Frame", {
            Name = "HueSlider",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 170),
            Size = UDim2.new(1, -20, 0, 20),
            ZIndex = 16,
            Parent = pickerContainer
        })
        
        local hueCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = hueSlider
        })
        
        -- Create hue gradient
        local hueGradient = Util.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            }),
            Parent = hueSlider
        })
        
        -- Create hue slider cursor
        local hueCursor = Util.Create("Frame", {
            Name = "Cursor",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 5, 1, 6),
            ZIndex = 17,
            Parent = hueSlider
        })
        
        local hueCursorCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 2),
            Parent = hueCursor
        })
        
        -- Create RGB input fields
        local rgbContainer = Util.Create("Frame", {
            Name = "RGBContainer",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 200),
            Size = UDim2.new(1, -20, 0, 30),
            ZIndex = 16,
            Parent = pickerContainer
        })
        
        local rgbLayout = Util.Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
            Parent = rgbContainer
        })
        
        -- Create R, G, B input fields
        local function createColorInput(name, defaultValue)
            local inputFrame = Util.Create("Frame", {
                Name = name .. "Input",
                BackgroundColor3 = self.Theme.ButtonColor,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 70, 1, 0),
                ZIndex = 16,
                Parent = rgbContainer
            })
            
            local inputCorner = Util.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = inputFrame
            })
            
            local inputLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(0, 15, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = string.upper(name),
                TextColor3 = self.Theme.Text,
                TextSize = 12,
                ZIndex = 17,
                Parent = inputFrame
            })
            
            local inputBox = Util.Create("TextBox", {
                Name = "Input",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 0),
                Size = UDim2.new(1, -25, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(defaultValue),
                TextColor3 = self.Theme.Text,
                TextSize = 12,
                ZIndex = 17,
                Parent = inputFrame
            })
            
            return inputBox
        end
        
        local rInput = createColorInput("r", math.floor(default.R * 255))
        local gInput = createColorInput("g", math.floor(default.G * 255))
        local bInput = createColorInput("b", math.floor(default.B * 255))
        
        -- Add apply button
        local applyButton = Util.Create("TextButton", {
            Name = "ApplyButton",
            BackgroundColor3 = self.Theme.Primary,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 0, 240),
            Size = UDim2.new(1, -20, 0, 30),
            Font = Enum.Font.GothamSemibold,
            Text = "Apply",
            TextColor3 = self.Theme.Text,
            TextSize = 14,
            ZIndex = 16,
            Parent = pickerContainer
        })
        
        local applyCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = applyButton
        })
        
        -- Calculate initial HSV values
        local h, s, v = Color3.toHSV(default)
        
        -- Update HSV picker and preview based on color
        local function updateColorDisplay(color)
            colorPreview.BackgroundColor3 = color
            rgbValue.Text = string.format("%d, %d, %d", 
                math.floor(color.R * 255), 
                math.floor(color.G * 255), 
                math.floor(color.B * 255)
            )
            
            rInput.Text = tostring(math.floor(color.R * 255))
            gInput.Text = tostring(math.floor(color.G * 255))
            bInput.Text = tostring(math.floor(color.B * 255))
        end
        
        -- Update color from HSV values
        local function updateFromHSV()
            local color = Color3.fromHSV(h, s, v)
            updateColorDisplay(color)
            return color
        end
        
        -- Position cursors based on HSV
        local function positionCursors()
            hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
            hsvCursor.Position = UDim2.new(s, 0, 1 - v, 0)
            
            -- Update HSV picker gradient based on hue
            local hueColor = Color3.fromHSV(h, 1, 1)
            hsvPicker.ImageColor3 = hueColor
        end
        
        -- Initialize cursor positions
        positionCursors()
        
        -- HSV picker interaction
        local pickerDragging = false
        hsvPicker.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                pickerDragging = true
                
                -- Update S and V based on mouse position
                local offset = input.Position - hsvPicker.AbsolutePosition
                s = math.clamp(offset.X / hsvPicker.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp(offset.Y / hsvPicker.AbsoluteSize.Y, 0, 1)
                
                positionCursors()
                callback(updateFromHSV())
            end
        end)
        
        hsvPicker.InputChanged:Connect(function(input)
            if pickerDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                -- Update S and V based on mouse position
                local offset = input.Position - hsvPicker.AbsolutePosition
                s = math.clamp(offset.X / hsvPicker.AbsoluteSize.X, 0, 1)
                v = 1 - math.clamp(offset.Y / hsvPicker.AbsoluteSize.Y, 0, 1)
                
                positionCursors()
                callback(updateFromHSV())
            end
        end)
        
        -- Hue slider interaction
        local hueDragging = false
        hueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                hueDragging = true
                
                -- Update H based on mouse position
                local offset = input.Position - hueSlider.AbsolutePosition
                h = math.clamp(offset.X / hueSlider.AbsoluteSize.X, 0, 1)
                
                positionCursors()
                callback(updateFromHSV())
            end
        end)
        
        hueSlider.InputChanged:Connect(function(input)
            if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                -- Update H based on mouse position
                local offset = input.Position - hueSlider.AbsolutePosition
                h = math.clamp(offset.X / hueSlider.AbsoluteSize.X, 0, 1)
                
                positionCursors()
                callback(updateFromHSV())
            end
        end)
        
        -- End dragging on input end
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                pickerDragging = false
                hueDragging = false
            end
        end)
        
        -- RGB input handling
        local function updateFromRGB()
            local r = tonumber(rInput.Text) or 0
            local g = tonumber(gInput.Text) or 0
            local b = tonumber(bInput.Text) or 0
            
            r = math.clamp(r, 0, 255) / 255
            g = math.clamp(g, 0, 255) / 255
            b = math.clamp(b, 0, 255) / 255
            
            local color = Color3.new(r, g, b)
            h, s, v = Color3.toHSV(color)
            
            positionCursors()
            updateColorDisplay(color)
            
            return color
        end
        
        -- Apply button
        applyButton.MouseButton1Click:Connect(function()
            local color = updateFromRGB()
            callback(color)
            
            -- Close color picker
            Util.Tween(colorPickerFrame, {Size = UDim2.new(1, 0, 0, self.Theme.ButtonHeight)}, 0.3)
            pickerContainer.Visible = false
        end)
        
        -- Open/close color picker
        local pickerOpen = false
        
        pickerHeader.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                pickerOpen = not pickerOpen
                
                if pickerOpen then
                    -- Open color picker
                    pickerContainer.Visible = true
                    Util.Tween(colorPickerFrame, {Size = UDim2.new(1, 0, 0, self.Theme.ButtonHeight + 280)}, 0.3)
                else
                    -- Close color picker
                    Util.Tween(colorPickerFrame, {Size = UDim2.new(1, 0, 0, self.Theme.ButtonHeight)}, 0.3)
                    task.wait(0.3)
                    pickerContainer.Visible = false
                end
            end
        end)
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        local colorPicker = {
            Instance = colorPickerFrame,
            Color = default,
            Set = function(self, color)
                h, s, v = Color3.toHSV(color)
                positionCursors()
                updateColorDisplay(color)
                self.Color = color
                callback(color)
            end
        }
        
        return colorPicker
    end
    
    function window:AddTextBox(text, default, callback, parent, icon)
        default = default or ""
        callback = callback or function() end
        parent = parent or scrollFrame
        
        local textBoxFrame = Util.Create("Frame", {
            Name = text.."TextBox",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, self.Theme.ButtonHeight),
            Parent = parent
        })
        
        local textBoxBackground = Util.Create("Frame", {
            Name = "Background",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 12,
            Parent = textBoxFrame
        })
        
        local cornerRadius = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = textBoxBackground
        })
        
        -- Add shadow
        local shadow = Util.Shadow(textBoxBackground, 12, 0.7)
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local boxIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 15, 0.5, 0),
                self.Theme.Text,
                textBoxBackground,
                13
            )
            
            -- Create text label with icon offset
            local textLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(0, 100, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = textBoxBackground
            })
        else
            -- Create text label without icon
            local textLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0, 100, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = textBoxBackground
            })
        end
        
        -- Create text box
        local inputBox = Util.Create("TextBox", {
            Name = "Input",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = self.Theme.BackgroundDark,
            BorderSizePixel = 0,
            Position = UDim2.new(1, -15, 0.5, 0),
            Size = UDim2.new(0.5, 0, 0, 25),
            Font = Enum.Font.Gotham,
            PlaceholderText = "Enter text...",
            Text = default,
            TextColor3 = self.Theme.Text,
            TextSize = 14,
            ZIndex = 13,
            Parent = textBoxBackground
        })
        
        local inputCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = inputBox
        })
        
        -- Text box functionality
        inputBox.FocusLost:Connect(function(enterPressed)
            callback(inputBox.Text, enterPressed)
        end)
        
        -- Hover effect
        textBoxBackground.MouseEnter:Connect(function()
            Util.Tween(textBoxBackground, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        textBoxBackground.MouseLeave:Connect(function()
            Util.Tween(textBoxBackground, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        local textBox = {
            Instance = textBoxFrame,
            Text = default,
            Set = function(self, value)
                inputBox.Text = value
                self.Text = value
                callback(value, false)
            end
        }
        
        return textBox
    end
    
    function window:AddLabel(text, textSize, alignment, parent, icon)
        textSize = textSize or 14
        alignment = alignment or Enum.TextXAlignment.Left
        parent = parent or scrollFrame
        
        local labelFrame = Util.Create("Frame", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, textSize + 10),
            Parent = parent
        })
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local labelIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 5, 0.5, 0),
                self.Theme.Text,
                labelFrame,
                13
            )
            
            -- Create label with icon offset
            local textLabel = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 30, 0, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = textSize,
                TextXAlignment = alignment,
                TextWrapped = true,
                ZIndex = 12,
                Parent = labelFrame
            })
        else
            -- Create label without icon
            local textLabel = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = textSize,
                TextXAlignment = alignment,
                TextWrapped = true,
                ZIndex = 12,
                Parent = labelFrame
            })
        end
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        return labelFrame
    end
    
    function window:AddDivider(parent)
        parent = parent or scrollFrame
        
        local dividerFrame = Util.Create("Frame", {
            Name = "Divider",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 15),
            Parent = parent
        })
        
        local dividerLine = Util.Create("Frame", {
            Name = "Line",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, -20, 0, 1),
            ZIndex = 12,
            Parent = dividerFrame
        })
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        return dividerFrame
    end
    
    function window:AddSection(text, parent, icon)
        parent = parent or scrollFrame
        
        local sectionFrame = Util.Create("Frame", {
            Name = text.."Section",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Parent = parent
        })
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local sectionIcon = Util.CreateIcon(
                Icons[icon],
                IconRects[icon],
                UDim2.new(0, 16, 0, 16),
                UDim2.new(0, 5, 0.5, 0),
                self.Theme.Primary,
                sectionFrame,
                13
            )
            
            -- Create section title with icon offset
            local sectionTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 30, 0, 0),
                Size = UDim2.new(1, -35, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = text,
                TextColor3 = self.Theme.Primary,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 12,
                Parent = sectionFrame
            })
        else
            -- Create section title without icon
            local sectionTitle = Util.Create("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = text,
                TextColor3 = self.Theme.Primary,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 12,
                Parent = sectionFrame
            })
        end
        
        -- Create divider line
        local dividerLine = Util.Create("Frame", {
            Name = "Divider",
            BackgroundColor3 = self.Theme.Primary,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 1, -2),
            Size = UDim2.new(1, -10, 0, 2),
            ZIndex = 12,
            Parent = sectionFrame
        })
        
        local dividerCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 1),
            Parent = dividerLine
        })
        
        -- Update canvas size for scrolling
        local canvas = parent
        canvas.CanvasSize = UDim2.new(
            0, 
            0, 
            0, 
            canvas.UIListLayout.AbsoluteContentSize.Y + self.Theme.Padding * 2
        )
        
        return sectionFrame
    end
    
    -- Store window in the library
    table.insert(self.Windows, window)
    
    return window
end

-- Initialize the library with default theme
function AdvancedUI:Init(customTheme)
    self.Theme = customTheme or DefaultTheme
    self.Windows = {}
    
    -- Create ScreenGui
    self.ScreenGui = Util.Create("ScreenGui", {
        Name = "AdvancedUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Set parent based on whether running in game or studio
    if RunService:IsRunning() then
        self.ScreenGui.Parent = game:GetService("CoreGui")
    else
        self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Create notification container
    self.NotificationContainer = Util.Create("Frame", {
        Name = "NotificationContainer",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 300, 1, 0),
        ZIndex = 1000,
        Parent = self.ScreenGui
    })
    
    local notificationLayout = Util.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = self.NotificationContainer
    })
    
    local notificationPadding = Util.Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        Parent = self.NotificationContainer
    })
    
    return self
end

return AdvancedUI
