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
end
