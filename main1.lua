--[[
    Advanced Roblox UI Library v2.0
    A comprehensive, feature-rich UI framework with enhanced performance,
    better error handling, and improved animations.
    
    Features:
    - Responsive design system
    - Comprehensive theming support
    - Optimized rendering
    - Robust error handling
    - Smooth animations
    - Advanced UI components
    - Auto-scaling
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

-- Optimization: Cache frequently used functions
local typeof = typeof
local pcall = pcall
local setmetatable = setmetatable
local tostring = tostring
local math_min = math.min
local math_max = math.max
local math_floor = math.floor
local math_clamp = math.clamp
local string_format = string.format
local table_insert = table.insert
local task_delay = task.delay
local task_spawn = task.spawn
local Color3_new = Color3.new
local Color3_fromRGB = Color3.fromRGB
local Color3_fromHSV = Color3.fromHSV
local UDim2_new = UDim2.new
local Vector2_new = Vector2.new
local Instance_new = Instance.new
local Rect_new = Rect.new

-- Library Module
local AdvancedUI = {}
AdvancedUI.__index = AdvancedUI
AdvancedUI._version = "2.0.0"

-- Preload essential assets to prevent flickering
local function preloadAssets()
    local assets = {
        "rbxassetid://1316045217", -- Shadow
        "rbxassetid://3926307971", -- Icon pack 1
        "rbxassetid://3926305904", -- Icon pack 2
        "rbxassetid://4155801252", -- HSV color picker
    }
    
    ContentProvider:PreloadAsync(assets)
end

-- Icon system with sprite sheet support
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
    Play = "rbxassetid://3926307971",
    Pause = "rbxassetid://3926307971",
    Sound = "rbxassetid://3926305904",
    Mute = "rbxassetid://3926305904",
    Brush = "rbxassetid://3926307971",
    
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

-- Icon image rectangles for sprite sheets
local IconRects = {
    Settings = Rect_new(324, 124, 444, 244),
    Home = Rect_new(964, 204, 1084, 324),
    Search = Rect_new(964, 324, 1084, 444),
    Menu = Rect_new(564, 764, 684, 884),
    Close = Rect_new(284, 4, 404, 124),
    Plus = Rect_new(984, 4, 1104, 124),
    Minus = Rect_new(564, 884, 684, 1004),
    Check = Rect_new(404, 124, 524, 244),
    Warning = Rect_new(164, 764, 284, 884),
    Info = Rect_new(524, 524, 644, 644),
    Success = Rect_new(764, 244, 884, 364),
    Error = Rect_new(124, 124, 244, 244),
    User = Rect_new(124, 764, 244, 884),
    Lock = Rect_new(4, 684, 124, 804),
    Heart = Rect_new(204, 564, 324, 684),
    Star = Rect_new(924, 444, 1044, 564),
    Play = Rect_new(764, 124, 884, 244),
    Pause = Rect_new(804, 124, 924, 244),
    Sound = Rect_new(684, 684, 804, 804),
    Mute = Rect_new(564, 684, 684, 804),
    Brush = Rect_new(644, 444, 764, 564),
    
    -- Game specific
    Coins = Rect_new(44, 164, 164, 284),
    Burger = Rect_new(684, 444, 804, 564),
    Soda = Rect_new(764, 684, 884, 804),
    Fries = Rect_new(764, 124, 884, 244),
    Sushi = Rect_new(204, 404, 324, 524),
    Cake = Rect_new(44, 404, 164, 524),
    
    -- Arrow icons
    ArrowRight = Rect_new(764, 724, 884, 844),
    ArrowLeft = Rect_new(404, 764, 524, 884),
    ArrowUp = Rect_new(244, 724, 364, 844),
    ArrowDown = Rect_new(444, 884, 564, 1004),
}

-- Comprehensive Utility Functions
local Util = {}

-- Safe instance creation with error handling
function Util.Create(instanceType, properties)
    local success, instance = pcall(function()
        return Instance_new(instanceType)
    end)
    
    if not success then
        warn("Failed to create " .. instanceType .. ": " .. tostring(instance))
        return nil
    end
    
    for property, value in pairs(properties or {}) do
        local success, err = pcall(function()
            instance[property] = value
        end)
        
        if not success then
            warn("Failed to set property " .. property .. " for " .. instanceType .. ": " .. tostring(err))
        end
    end
    
    return instance
end

-- Enhanced tweening system with completion callback
function Util.Tween(instance, properties, duration, style, direction, callback)
    -- Validate inputs
    if not instance or typeof(instance) ~= "Instance" then
        warn("Util.Tween: Invalid instance provided")
        if callback then callback(false) end
        return nil
    end
    
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    -- Create and validate tween
    local success, tween = pcall(function()
        return TweenService:Create(
            instance,
            TweenInfo.new(duration, style, direction),
            properties
        )
    end)
    
    if not success then
        warn("Util.Tween: Failed to create tween: " .. tostring(tween))
        if callback then callback(false) end
        return nil
    end
    
    -- Handle completion callback
    if callback then
        tween.Completed:Connect(function()
            callback(true)
        end)
    end
    
    -- Play tween
    tween:Play()
    return tween
end

-- Improved shadow with multiple options
function Util.Shadow(parent, size, transparency, color, cornerRadius)
    if not parent then return nil end
    
    size = size or 10
    transparency = transparency or 0.5
    color = color or Color3_fromRGB(0, 0, 0)
    cornerRadius = cornerRadius or UDim2_new(0, 4, 0, 4)
    
    local shadow = Util.Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2_new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2_new(0.5, 0, 0.5, 0),
        Size = UDim2_new(1, size, 1, size),
        ZIndex = parent.ZIndex > 1 and parent.ZIndex - 1 or 0,
        Image = "rbxassetid://1316045217",
        ImageColor3 = color,
        ImageTransparency = transparency,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect_new(10, 10, 118, 118),
        Parent = parent
    })
    
    return shadow
end

-- Create icon with more options
function Util.CreateIcon(iconName, size, position, color, parent, zIndex)
    -- Validate inputs
    if not iconName or not Icons[iconName] or not parent then
        warn("Util.CreateIcon: Invalid parameters")
        return nil
    end
    
    local imageId = Icons[iconName]
    local imageRect = IconRects[iconName]
    
    if not imageRect then
        warn("Util.CreateIcon: No image rect found for icon: " .. iconName)
        return nil
    end
    
    size = size or UDim2_new(0, 20, 0, 20)
    position = position or UDim2_new(0, 0, 0.5, 0)
    color = color or Color3_fromRGB(255, 255, 255)
    zIndex = zIndex or (parent.ZIndex + 1)
    
    local icon = Util.Create("ImageLabel", {
        Name = "Icon_" .. iconName,
        AnchorPoint = Vector2_new(0, 0.5),
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        Image = imageId,
        ImageRectOffset = Vector2_new(imageRect.Min.X, imageRect.Min.Y),
        ImageRectSize = Vector2_new(
            imageRect.Max.X - imageRect.Min.X,
            imageRect.Max.Y - imageRect.Min.Y
        ),
        ImageColor3 = color,
        ZIndex = zIndex,
        Parent = parent
    })
    
    return icon
end

-- Create ripple effect
function Util.Ripple(button, color)
    local ripple = Util.Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2_new(0.5, 0.5),
        BackgroundColor3 = color or Color3_fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Position = UDim2_new(0.5, 0, 0.5, 0),
        Size = UDim2_new(0, 0, 0, 0),
        ZIndex = button.ZIndex + 1,
        Parent = button
    })
    
    local corner = Util.Create("UICorner", {
        CornerRadius = UDim2_new(1, 0, 1, 0),
        Parent = ripple
    })
    
    Util.Tween(ripple, {
        Size = UDim2_new(2, 0, 2, 0),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
        ripple:Destroy()
    end)
end

-- Create tooltip
function Util.CreateTooltip(parent, text, theme)
    local tooltip = Util.Create("Frame", {
        Name = "Tooltip",
        BackgroundColor3 = theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2_new(0.5, 0, 0, -10),
        Size = UDim2_new(0, 0, 0, 30),
        AnchorPoint = Vector2_new(0.5, 1),
        ZIndex = 100,
        Visible = false,
        Parent = parent.Parent
    })
    
    local corner = Util.Create("UICorner", {
        CornerRadius = UDim2_new(0, 4, 0, 4),
        Parent = tooltip
    })
    
    local shadow = Util.Shadow(tooltip, 10, 0.7)
    
    local label = Util.Create("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Position = UDim2_new(0, 10, 0, 0),
        Size = UDim2_new(1, -20, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = theme.Text,
        TextSize = 12,
        ZIndex = 101,
        Parent = tooltip
    })
    
    -- Calculate size based on text
    local textSize = TextService:GetTextSize(text, 12, Enum.Font.Gotham, Vector2_new(400, 100))
    tooltip.Size = UDim2_new(0, textSize.X + 20, 0, 30)
    
    -- Mouse enter/leave events
    parent.MouseEnter:Connect(function()
        tooltip.Position = UDim2_new(0.5, 0, 0, -10)
        tooltip.Visible = true
        Util.Tween(tooltip, {
            Position = UDim2_new(0.5, 0, 0, -30),
            BackgroundTransparency = 0
        }, 0.2)
    end)
    
    parent.MouseLeave:Connect(function()
        Util.Tween(tooltip, {
            Position = UDim2_new(0.5, 0, 0, -10),
            BackgroundTransparency = 1
        }, 0.2, nil, nil, function()
            tooltip.Visible = false
        end)
    end)
    
    return tooltip
end

-- Create glow effect
function Util.CreateGlow(parent, size, transparency, color)
    local glow = Util.Create("ImageLabel", {
        Name = "Glow",
        AnchorPoint = Vector2_new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2_new(0.5, 0, 0.5, 0),
        Size = UDim2_new(1, size or 30, 1, size or 30),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = color or Color3_fromRGB(255, 255, 255),
        ImageTransparency = transparency or 0.9,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect_new(23, 23, 277, 277),
        Parent = parent
    })
    
    return glow
end

-- Enhanced theme system
local DefaultTheme = {
    Primary = Color3_fromRGB(255, 100, 50),
    Secondary = Color3_fromRGB(35, 35, 35),
    Background = Color3_fromRGB(25, 25, 25),
    BackgroundDark = Color3_fromRGB(20, 20, 20),
    Text = Color3_fromRGB(255, 255, 255),
    TextDark = Color3_fromRGB(220, 220, 210),
    Success = Color3_fromRGB(100, 200, 70),
    Warning = Color3_fromRGB(255, 210, 50),
    Error = Color3_fromRGB(255, 80, 80),
    Disabled = Color3_fromRGB(130, 120, 110),
    ButtonColor = Color3_fromRGB(45, 40, 35),
    ButtonHover = Color3_fromRGB(55, 50, 45),
    ButtonActive = Color3_fromRGB(65, 60, 55),
    ToggleOn = Color3_fromRGB(255, 100, 50),
    ToggleOff = Color3_fromRGB(90, 80, 75),
    SliderBackground = Color3_fromRGB(45, 40, 35),
    SliderFill = Color3_fromRGB(255, 100, 50),
    DropdownBackground = Color3_fromRGB(45, 40, 35),
    DropdownItem = Color3_fromRGB(55, 50, 45),
    DropdownHover = Color3_fromRGB(65, 60, 55),
    CornerRadius = UDim2_new(0, 8, 0, 8),
    ButtonHeight = 40,
    ToggleHeight = 40,
    SliderHeight = 60,
    DropdownHeight = 40,
    InputHeight = 40,
    Padding = 8
}

-- Theme presets
local ThemePresets = {
    Dark = DefaultTheme,
    
    Light = {
        Primary = Color3_fromRGB(0, 120, 215),
        Secondary = Color3_fromRGB(240, 240, 240),
        Background = Color3_fromRGB(250, 250, 250),
        BackgroundDark = Color3_fromRGB(230, 230, 230),
        Text = Color3_fromRGB(30, 30, 30),
        TextDark = Color3_fromRGB(60, 60, 60),
        Success = Color3_fromRGB(70, 170, 50),
        Warning = Color3_fromRGB(230, 190, 40),
        Error = Color3_fromRGB(220, 60, 60),
        Disabled = Color3_fromRGB(180, 180, 180),
        ButtonColor = Color3_fromRGB(240, 240, 240),
        ButtonHover = Color3_fromRGB(230, 230, 230),
        ButtonActive = Color3_fromRGB(220, 220, 220),
        ToggleOn = Color3_fromRGB(0, 120, 215),
        ToggleOff = Color3_fromRGB(170, 170, 170),
        SliderBackground = Color3_fromRGB(210, 210, 210),
        SliderFill = Color3_fromRGB(0, 120, 215),
        DropdownBackground = Color3_fromRGB(240, 240, 240),
        DropdownItem = Color3_fromRGB(250, 250, 250),
        DropdownHover = Color3_fromRGB(230, 230, 230),
        CornerRadius = UDim2_new(0, 8, 0, 8)
    },
    
    Midnight = {
        Primary = Color3_fromRGB(120, 80, 255),
        Secondary = Color3_fromRGB(30, 30, 40),
        Background = Color3_fromRGB(20, 20, 30),
        BackgroundDark = Color3_fromRGB(15, 15, 25),
        Text = Color3_fromRGB(255, 255, 255),
        TextDark = Color3_fromRGB(200, 200, 220),
        Success = Color3_fromRGB(100, 200, 100),
        Warning = Color3_fromRGB(255, 200, 60),
        Error = Color3_fromRGB(255, 60, 80),
        ButtonColor = Color3_fromRGB(40, 40, 60),
        ButtonHover = Color3_fromRGB(50, 50, 70),
        ButtonActive = Color3_fromRGB(60, 60, 80),
        ToggleOn = Color3_fromRGB(120, 80, 255),
        ToggleOff = Color3_fromRGB(60, 60, 80),
        CornerRadius = UDim2_new(0, 8, 0, 8)
    },
    
    Forest = {
        Primary = Color3_fromRGB(80, 160, 80),
        Secondary = Color3_fromRGB(40, 50, 40),
        Background = Color3_fromRGB(30, 40, 30),
        BackgroundDark = Color3_fromRGB(25, 35, 25),
        Text = Color3_fromRGB(240, 255, 240),
        CornerRadius = UDim2_new(0, 6, 0, 6)
    },
    
    Ocean = {
        Primary = Color3_fromRGB(60, 140, 200),
        Secondary = Color3_fromRGB(30, 40, 60),
        Background = Color3_fromRGB(20, 30, 50),
        BackgroundDark = Color3_fromRGB(15, 25, 45),
        Text = Color3_fromRGB(240, 250, 255),
        CornerRadius = UDim2_new(0, 8, 0, 8)
    },
    
    Sunset = {
        Primary = Color3_fromRGB(240, 100, 60),
        Secondary = Color3_fromRGB(50, 35, 35),
        Background = Color3_fromRGB(40, 25, 25),
        BackgroundDark = Color3_fromRGB(35, 20, 20),
        Text = Color3_fromRGB(255, 240, 230),
        CornerRadius = UDim2_new(0, 8, 0, 8)
    }
}

-- Complete theme preset with default fallbacks
local function completeTheme(customTheme)
    if not customTheme then return DefaultTheme end
    
    local theme = {}
    for key, value in pairs(DefaultTheme) do
        theme[key] = customTheme[key] or DefaultTheme[key]
    end
    return theme
end

-- Initialize the UI Library with robust error handling
function AdvancedUI.new(themePreset)
    -- Validate theme input
    local theme
    if type(themePreset) == "string" then
        if ThemePresets[themePreset] then
            theme = completeTheme(ThemePresets[themePreset])
        else
            warn("Theme preset '" .. themePreset .. "' not found. Using default theme.")
            theme = DefaultTheme
        end
    elseif type(themePreset) == "table" then
        theme = completeTheme(themePreset)
    else
        theme = DefaultTheme
    end
    
    -- Create ScreenGui with error handling
    local screenGui, success = nil, false
    
    success, screenGui = pcall(function()
        local gui = Util.Create("ScreenGui", {
            Name = "AdvancedUI_" .. math_floor(tick()),
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 100
        })
        
        -- Handle proper parenting with fallbacks
        if RunService:IsStudio() then
            gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        else
            -- Try CoreGui first
            pcall(function() gui.Parent = CoreGui end)
            
            -- Fallback to PlayerGui if CoreGui fails
            if not gui.Parent then
                gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            end
        end
        
        return gui
    end)
    
    -- Handle screen gui creation failure
    if not success or not screenGui then
        warn("Failed to create ScreenGui: " .. tostring(screenGui))
        return nil
    end
    
    -- Create notification container
    local notificationFrame = Util.Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Position = UDim2_new(1, -20, 0, 20),
        Size = UDim2_new(0, 300, 1, -40),
        AnchorPoint = Vector2_new(1, 0),
        ZIndex = 10000,
        Parent = screenGui
    })
    
    -- Add layout for notifications
    local notificationLayout = Util.Create("UIListLayout", {
        Padding = UDim2_new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = notificationFrame
    })
    
    -- Preload common assets to prevent flickering
    task_spawn(preloadAssets)
    
    -- Create the library instance
    local self = setmetatable({}, AdvancedUI)
    self.ScreenGui = screenGui
    self.NotificationFrame = notificationFrame
    self.Windows = {}
    self.Theme = theme
    self.Active = true
    
    -- Add version indicator for debugging
    local versionLabel = Util.Create("TextLabel", {
        Name = "Version",
        Text = "AdvancedUI v" .. AdvancedUI._version,
        BackgroundTransparency = 1,
        TextTransparency = 0.7,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextColor3 = theme.TextDark,
        AnchorPoint = Vector2_new(0, 1),
        Position = UDim2_new(0, 5, 1, -5),
        Size = UDim2_new(0, 200, 0, 20),
        ZIndex = 1,
        Parent = screenGui
    })
    
    -- Make version text not interfere with UI
    versionLabel.InputBegan:Connect(function() end)
    
    return self
end

-- Ensure both initialization methods work (Init and new)
function AdvancedUI:Init(customTheme)
    return AdvancedUI.new(customTheme)
end

-- Enhanced notification system
function AdvancedUI:Notify(title, message, duration, notifType)
    -- Validate inputs with defaults
    title = title or "Notification"
    message = message or ""
    duration = duration or 5
    notifType = notifType or "Info"
    
    local colorMap = {
        Info = self.Theme.Primary,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error
    }
    
    local iconMap = {
        Info = "Info",
        Success = "Success",
        Warning = "Warning",
        Error = "Error"
    }
    
    local color = colorMap[notifType] or self.Theme.Primary
    local iconName = iconMap[notifType] or "Info"
    
    -- Create notification container
    local notification = Util.Create("Frame", {
        Name = "Notification_" .. notifType,
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2_new(1, 0, 0, 0), -- Start with 0 height
        ZIndex = 10001,
        Parent = self.NotificationFrame
    })
    
    -- Add corner radius
    local notifCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = notification
    })
    
    -- Add shadow for depth
    local notifShadow = Util.Shadow(notification, 15, 0.5)
    
    -- Colored left bar
    local leftBar = Util.Create("Frame", {
        Name = "LeftBar",
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Position = UDim2_new(0, 0, 0, 0),
        Size = UDim2_new(0, 5, 1, 0),
        ZIndex = 10002,
        Parent = notification
    })
    
    -- Corner radius for left bar
    local leftBarCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = leftBar
    })
    
    -- Create icon with error handling
    local icon = Util.CreateIcon(
        iconName,
        UDim2_new(0, 20, 0, 20),
        UDim2_new(0, 15, 0, 21),
        color,
        notification,
        10003
    )
    
    -- Create title
    local titleLabel = Util.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2_new(0, 45, 0, 10),
        Size = UDim2_new(1, -55, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10003,
        Parent = notification
    })
    
    -- Create message with auto-sizing
    local messageLabel = Util.Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2_new(0, 45, 0, 32),
        Size = UDim2_new(1, -55, 0, 0), -- Will be sized based on text
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10003,
        Parent = notification
    })
    
    -- Create close button
    local closeButton = Util.Create("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2_new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2_new(1, -10, 0, 10),
        Size = UDim2_new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.TextDark,
        TextSize = 18,
        ZIndex = 10003,
        Parent = notification
    })
    
    -- Measure text size for message label
    local textSize = TextService:GetTextSize(
        message, 
        12, 
        Enum.Font.Gotham, 
        Vector2_new(notification.AbsoluteSize.X - 65, 1000)
    )
    
    -- Set message height and notification height
    messageLabel.Size = UDim2_new(1, -65, 0, textSize.Y)
    local notifHeight = math_max(60, textSize.Y + 45) -- Minimum height of 60
    
    -- Animate notification appearance
    notification.Size = UDim2_new(1, -20, 0, 0)
    notification.Position = UDim2_new(0, 10, 0, 0)
    notification.BackgroundTransparency = 1
    
    Util.Tween(notification, {
        Size = UDim2_new(1, -20, 0, notifHeight),
        BackgroundTransparency = 0,
        Position = UDim2_new(0, 10, 0, 0)
    }, 0.3, Enum.EasingStyle.Quint)
    
    -- Button hover effects
    closeButton.MouseEnter:Connect(function()
        closeButton.TextColor3 = self.Theme.Text
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.TextColor3 = self.Theme.TextDark
    end)
    
    -- Close notification function
    local function closeNotification()
        Util.Tween(notification, {
            BackgroundTransparency = 1,
            Position = UDim2_new(0, 20, 0, 0),
            Size = UDim2_new(1, 0, 0, 0)
        }, 0.3, Enum.EasingStyle.Quint, nil, function()
            notification:Destroy()
        end)
    end
    
    -- Close on button click
    closeButton.MouseButton1Click:Connect(closeNotification)
    
    -- Auto close after duration
    task_delay(duration, closeNotification)
    
    return notification
end

-- Create a window with enhanced functionality
function AdvancedUI:CreateWindow(title, position, size, icon)
    local window = {}
    window.Elements = {}
    window.Tabs = {}
    window.ActiveTab = nil
    
    -- Validate inputs with defaults
    title = title or "Window"
    position = position or UDim2_new(0.5, -250, 0.5, -200)
    size = size or UDim2_new(0, 500, 0, 400)
    
    -- Create main frame with animation
    local mainFrame = Util.Create("Frame", {
        Name = "Window_" .. title,
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        Position = position,
        Size = UDim2_new(0, size.X.Offset, 0, 0), -- Start with 0 height for animation
        ZIndex = 10,
        Parent = self.ScreenGui,
        ClipsDescendants = true
    })
    
    -- Apply rounded corners
    local cornerRadius = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = mainFrame
    })
    
    -- Apply shadow for depth
    local shadow = Util.Shadow(mainFrame, 30, 0.5, nil, 0)
    
    -- Create title bar
    local titleBar = Util.Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2_new(1, 0, 0, 40),
        ZIndex = 11,
        Parent = mainFrame
    })
    
    -- Apply corner radius to title bar
    local titleCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = titleBar
    })
    
    -- Create bottom cover to flatten the bottom corners of title bar
    local titleBottomCover = Util.Create("Frame", {
        Name = "BottomCover",
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2_new(0, 0, 1, -10),
        Size = UDim2_new(1, 0, 0, 10),
        ZIndex = 11,
        Parent = titleBar
    })
    
    -- Add icon if provided
    if icon and Icons[icon] then
        local titleIcon = Util.CreateIcon(
            icon,
            UDim2_new(0, 20, 0, 20),
            UDim2_new(0, 15, 0.5, 0),
            self.Theme.Text,
            titleBar,
            12
        )
        
        -- Create title text with icon offset
        local titleText = Util.Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2_new(0, 45, 0, 0),
            Size = UDim2_new(1, -150, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = self.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 12,
            Parent = titleBar
        })
    else
        -- Create title text without icon
        local titleText = Util.Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2_new(0, 15, 0, 0),
            Size = UDim2_new(1, -120, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = self.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 12,
            Parent = titleBar
        })
    end
    
    -- Create minimize button
    local minimizeButton = Util.Create("ImageButton", {
        Name = "MinimizeButton",
        AnchorPoint = Vector2_new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2_new(1, -50, 0.5, 0),
        Size = UDim2_new(0, 24, 0, 24),
        ZIndex = 12,
        Parent = titleBar
    })
    
    -- Create minimize icon
    local minimizeIcon = Util.CreateIcon(
        "Minus",
        UDim2_new(0, 16, 0, 16),
        UDim2_new(0.5, 0, 0.5, 0),
        self.Theme.Text,
        minimizeButton,
        13
    )
    minimizeIcon.AnchorPoint = Vector2_new(0.5, 0.5)
    
    -- Create close button
    local closeButton = Util.Create("ImageButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2_new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2_new(1, -15, 0.5, 0),
        Size = UDim2_new(0, 24, 0, 24),
        ZIndex = 12,
        Parent = titleBar
    })
    
    -- Create close icon
    local closeIcon = Util.CreateIcon(
        "Close",
        UDim2_new(0, 16, 0, 16),
        UDim2_new(0.5, 0, 0.5, 0),
        self.Theme.Text,
        closeButton,
        13
    )
    closeIcon.AnchorPoint = Vector2_new(0.5, 0.5)
    
    -- Create tab container
    local tabContainer = Util.Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2_new(0, 0, 0, 40),
        Size = UDim2_new(1, 0, 0, 35),
        ZIndex = 11,
        Visible = false,
        Parent = mainFrame
    })
    
    -- Create tab scroll frame
    local tabScrollFrame = Util.Create("ScrollingFrame", {
        Name = "TabScroll",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2_new(0, 10, 0, 0),
        Size = UDim2_new(1, -20, 1, 0),
        ZIndex = 12,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2_new(0, 0, 0, 0),
        Parent = tabContainer
    })
    
    -- Create tab layout
    local tabLayout = Util.Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim2_new(0, 5),
        Parent = tabScrollFrame
    })
    
    -- Create content frame
    local contentFrame = Util.Create("Frame", {
        Name = "Content",
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2_new(0, 0, 0, 40),
        Size = UDim2_new(1, 0, 1, -40),
        ZIndex = 10,
        Parent = mainFrame
    })
    
    -- Create scroll frame for content
    local scrollFrame = Util.Create("ScrollingFrame", {
        Name = "ScrollFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2_new(0, 0, 0, 0),
        Size = UDim2_new(1, 0, 1, 0),
        CanvasSize = UDim2_new(0, 0, 0, 0),
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = self.Theme.Primary,
        ZIndex = 11,
        Parent = contentFrame
    })
    
    -- Create padding for content
    local contentPadding = Util.Create("UIPadding", {
        PaddingTop = UDim2_new(0, 10),
        PaddingLeft = UDim2_new(0, 10),
        PaddingRight = UDim2_new(0, 10),
        PaddingBottom = UDim2_new(0, 10),
        Parent = scrollFrame
    })
    
    -- Create layout for content elements
    local contentLayout = Util.Create("UIListLayout", {
        Padding = UDim2_new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollFrame
    })
    
    -- Make window draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            -- Capture input and prevent bubbling
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2_new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        -- Animate window closing
        Util.Tween(mainFrame, {
            Size = UDim2_new(0, mainFrame.AbsoluteSize.X, 0, 0),
            Position = UDim2_new(
                mainFrame.Position.X.Scale,
                mainFrame.Position.X.Offset,
                mainFrame.Position.Y.Scale,
                mainFrame.Position.Y.Offset + mainFrame.AbsoluteSize.Y/2
            ),
            BackgroundTransparency = 1
        }, 0.3, Enum.EasingStyle.Quart, nil, function()
            mainFrame:Destroy()
            
            -- Remove window from library's windows table
            for i, win in pairs(self.Windows) do
                if win == window then
                    table.remove(self.Windows, i)
                    break
                end
            end
        end)
    end)
    
    -- Minimize button functionality
    local minimized = false
    local originalSize = size
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            -- Animate minimizing
            Util.Tween(mainFrame, {
                Size = UDim2_new(0, size.X.Offset, 0, 40)
            }, 0.3, Enum.EasingStyle.Quart)
            
            Util.Tween(minimizeIcon, {Rotation = 180}, 0.3)
            
            -- Hide content
            contentFrame.Visible = false
            tabContainer.Visible = false
        else
            -- Animate restoring
            Util.Tween(mainFrame, {
                Size = UDim2_new(0, size.X.Offset, 0, size.Y.Offset)
            }, 0.3, Enum.EasingStyle.Quart)
            
            Util.Tween(minimizeIcon, {Rotation = 0}, 0.3)
            
            -- Show content
            contentFrame.Visible = true
            if #window.Tabs > 0 then
                tabContainer.Visible = true
            end
        end
    end)
    
    -- Button hover effects
    for _, button in pairs({closeButton, minimizeButton}) do
        button.MouseEnter:Connect(function()
            local icon = button:FindFirstChildOfClass("ImageLabel")
            if icon then
                Util.Tween(icon, {ImageColor3 = self.Theme.Primary}, 0.2)
            end
        end)
        
        button.MouseLeave:Connect(function()
            local icon = button:FindFirstChildOfClass("ImageLabel")
            if icon then
                Util.Tween(icon, {ImageColor3 = self.Theme.Text}, 0.2)
            end
        end)
    end
    
    -- Tab system function
    function window:AddTab(name, icon)
        local tab = {}
        tab.Elements = {}
        
        -- Create tab button
        local tabButton = Util.Create("TextButton", {
            Name = "Tab_" .. name,
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2_new(0, 0, 1, -10), -- Width will be calculated based on text
            Position = UDim2_new(0, 0, 0, 5),
            Font = Enum.Font.GothamSemibold,
            Text = "  " .. name .. "  ",
            TextColor3 = self.Theme.Text,
            TextSize = 14,
            ZIndex = 13,
            Parent = tabScrollFrame,
            AutomaticSize = Enum.AutomaticSize.X -- Auto-size width based on text
        })
        
        -- Apply corner radius
        local tabCorner = Util.Create("UICorner", {
            CornerRadius = UDim2_new(0, 6, 0, 6),
            Parent = tabButton
        })
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local tabIcon = Util.CreateIcon(
                icon,
                UDim2_new(0, 16, 0, 16),
                UDim2_new(0, 10, 0.5, 0),
                self.Theme.Text,
                tabButton,
                14
            )
            
            -- Adjust text position
            tabButton.Text = "          " .. name .. "  "
        end
        
        -- Create content container for this tab
        local tabContent = Util.Create("ScrollingFrame", {
            Name = "TabContent_" .. name,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2_new(0, 0, 0, 0),
            Size = UDim2_new(1, 0, 1, 0),
            CanvasSize = UDim2_new(0, 0, 0, 0),
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = self.Theme.Primary,
            ZIndex = 11,
            Visible = false,
            Parent = scrollFrame
        })
        
        -- Create padding for tab content
        local tabPadding = Util.Create("UIPadding", {
            PaddingTop = UDim2_new(0, 10),
            PaddingLeft = UDim2_new(0, 10),
            PaddingRight = UDim2_new(0, 10),
            PaddingBottom = UDim2_new(0, 10),
            Parent = tabContent
        })
        
        -- Create layout for tab content
        local tabLayout = Util.Create("UIListLayout", {
            Padding = UDim2_new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        
        -- Tab selection function
        local function selectTab()
            -- Deselect all tabs
            for _, otherTab in pairs(window.Tabs) do
                otherTab.Button.BackgroundColor3 = self.Theme.ButtonColor
                otherTab.Content.Visible = false
            end
            
            -- Select this tab
            tabButton.BackgroundColor3 = self.Theme.Primary
            tabContent.Visible = true
            window.ActiveTab = tab
        end
        
        -- Tab button click handler
        tabButton.MouseButton1Click:Connect(selectTab)
        
        -- Tab button hover effect
        tabButton.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                Util.Tween(tabButton, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                Util.Tween(tabButton, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
            end
        end)
        
        -- Show tab container if this is the first tab
        if #window.Tabs == 0 then
            tabContainer.Visible = true
            contentFrame.Position = UDim2_new(0, 0, 0, 75)
            contentFrame.Size = UDim2_new(1, 0, 1, -75)
        end
        
        -- Update tab scroll canvas size
        task_delay(0.1, function()
            tabScrollFrame.CanvasSize = UDim2_new(0, tabLayout.AbsoluteContentSize.X + 20, 0, 0)
        end)
        
        -- Set up tab object
        tab.Button = tabButton
        tab.Content = tabContent
        tab.Name = name
        
        -- Store tab in window's tabs table
        table.insert(window.Tabs, tab)
        
        -- Auto-select first tab
        if #window.Tabs == 1 then
            selectTab()
        end
        
        -- Helper functions for tab
        function tab:Select()
            selectTab()
        end
        
        -- Add UI elements to the tab
        function tab:AddButton(text, callback, icon)
            return window:AddButton(text, callback, tab.Content, icon)
        end
        
        function tab:AddToggle(text, default, callback, icon)
            return window:AddToggle(text, default, callback, tab.Content, icon)
        end
        
        function tab:AddSlider(text, min, max, default, callback, icon)
            return window:AddSlider(text, min, max, default, callback, tab.Content, icon)
        end
        
        function tab:AddDropdown(text, options, default, callback, icon)
            return window:AddDropdown(text, options, default, callback, tab.Content, icon)
        end
        
        function tab:AddColorPicker(text, default, callback, icon)
            return window:AddColorPicker(text, default, callback, tab.Content, icon)
        end
        
        function tab:AddTextBox(text, default, callback, icon)
            return window:AddTextBox(text, default, callback, tab.Content, icon)
        end
        
        function tab:AddLabel(text, textSize, alignment, icon)
            return window:AddLabel(text, textSize, alignment, tab.Content, icon)
        end
        
        function tab:AddDivider()
            return window:AddDivider(tab.Content)
        end
        
        function tab:AddSection(text, icon)
            return window:AddSection(text, tab.Content, icon)
        end
        
        return tab
    end
    
    -- Add UI elements to the window
    function window:AddButton(text, callback, parent, icon)
        parent = parent or scrollFrame
        callback = callback or function() end
        
        local buttonFrame = Util.Create("Frame", {
            Name = text .. "_Button",
            BackgroundTransparency = 1,
            Size = UDim2_new(1, 0, 0, self.Theme.ButtonHeight),
            Parent = parent
        })
        
        local button = Util.Create("TextButton", {
            Name = "Button",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2_new(1, 0, 1, 0),
            Font = Enum.Font.GothamSemibold,
            Text = text,
            TextColor3 = self.Theme.Text,
            TextSize = 14,
            ZIndex = 12,
            Parent = buttonFrame,
            ClipsDescendants = true -- For ripple effect
        })
        
        local buttonCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = button
        })
        
        -- Add shadow
        local shadow = Util.Shadow(button, 6, 0.8)
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local buttonIcon = Util.CreateIcon(
                icon,
                UDim2_new(0, 18, 0, 18),
                UDim2_new(0, 10, 0.5, 0),
                self.Theme.Text,
                button,
                13
            )
            
            -- Adjust text position
            button.Text = "          " .. text
        end
        
        -- Button click effect
        button.MouseButton1Down:Connect(function(x, y)
            -- Create ripple effect
            local ripple = Util.Create("Frame", {
                Name = "Ripple",
                AnchorPoint = Vector2_new(0.5, 0.5),
                BackgroundColor3 = Color3_fromRGB(255, 255, 255),
                BackgroundTransparency = 0.7,
                Position = UDim2_new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y),
                Size = UDim2_new(0, 0, 0, 0),
                ZIndex = 15,
                Parent = button
            })
            
            local rippleCorner = Util.Create("UICorner", {
                CornerRadius = UDim2_new(1, 0, 1, 0),
                Parent = ripple
            })
            
            local maxSize = math_max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
            Util.Tween(ripple, {
                Size = UDim2_new(0, maxSize, 0, maxSize),
                BackgroundTransparency = 1
            }, 0.5, Enum.EasingStyle.Quart, nil, function()
                ripple:Destroy()
            end)
        end)
        
        -- Button click handler
        button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        -- Button hover effect
        button.MouseEnter:Connect(function()
            Util.Tween(button, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            Util.Tween(button, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update parent canvas size for scrolling
        local function updateCanvasSize()
            if parent:IsA("ScrollingFrame") then
                parent.CanvasSize = UDim2_new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y + 20)
            end
        end
        
        updateCanvasSize()
        parent.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        
        return button
    end
    
    -- Add more UI components here (Toggle, Slider, Dropdown, etc.)
    function window:AddToggle(text, default, callback, parent, icon)
        parent = parent or scrollFrame
        default = default or false
        callback = callback or function() end
        
        local toggleFrame = Util.Create("Frame", {
            Name = text .. "_Toggle",
            BackgroundTransparency = 1,
            Size = UDim2_new(1, 0, 0, self.Theme.ToggleHeight),
            Parent = parent
        })
        
        local toggleButton = Util.Create("TextButton", {
            Name = "ToggleButton",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2_new(1, 0, 1, 0),
            Text = "",
            ZIndex = 12,
            Parent = toggleFrame,
            ClipsDescendants = true
        })
        
        local toggleCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = toggleButton
        })
        
        -- Add shadow
        local shadow = Util.Shadow(toggleButton, 6, 0.8)
        
        -- Add icon if provided
        if icon and Icons[icon] then
            local toggleIcon = Util.CreateIcon(
                icon,
                UDim2_new(0, 18, 0, 18),
                UDim2_new(0, 10, 0.5, 0),
                self.Theme.Text,
                toggleButton,
                13
            )
            
            -- Create toggle text with icon offset
            local toggleText = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2_new(0, 40, 0, 0),
                Size = UDim2_new(1, -100, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = toggleButton
            })
        else
            -- Create toggle text without icon
            local toggleText = Util.Create("TextLabel", {
                Name = "Text",
                BackgroundTransparency = 1,
                Position = UDim2_new(0, 15, 0, 0),
                Size = UDim2_new(1, -75, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = toggleButton
            })
        end
        
        -- Create toggle indicator
        local toggleIndicator = Util.Create("Frame", {
            Name = "Indicator",
            AnchorPoint = Vector2_new(1, 0.5),
            BackgroundColor3 = default and self.Theme.ToggleOn or self.Theme.ToggleOff,
            BorderSizePixel = 0,
            Position = UDim2_new(1, -15, 0.5, 0),
            Size = UDim2_new(0, 40, 0, 20),
            ZIndex = 13,
            Parent = toggleButton
        })
        
        local indicatorCorner = Util.Create("UICorner", {
            CornerRadius = UDim2_new(0, 10, 0, 10),
            Parent = toggleIndicator
        })
        
        -- Create toggle knob
        local toggleKnob = Util.Create("Frame", {
            Name = "Knob",
            AnchorPoint = Vector2_new(0.5, 0.5),
            BackgroundColor3 = Color3_fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Position = UDim2_new(default and 0.7 or 0.3, 0, 0.5, 0),
            Size = UDim2_new(0, 16, 0, 16),
            ZIndex = 14,
            Parent = toggleIndicator
        })
        
        local knobCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = toggleKnob
        })
        
        -- Toggle functionality
        local toggled = default
        
        local function updateToggle()
            toggled = not toggled
            
            -- Animate the toggle
            Util.Tween(toggleIndicator, {
                BackgroundColor3 = toggled and self.Theme.ToggleOn or self.Theme.ToggleOff
            }, 0.2)
            
            Util.Tween(toggleKnob, {
                Position = UDim2.new(toggled and 0.7 or 0.3, 0, 0.5, 0)
            }, 0.2)
            
            callback(toggled)
        end
        
        toggleButton.MouseButton1Click:Connect(updateToggle)
        
        -- Button hover effect
        toggleButton.MouseEnter:Connect(function()
            Util.Tween(toggleButton, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        toggleButton.MouseLeave:Connect(function()
            Util.Tween(toggleButton, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update canvas size for scrolling
        local function updateCanvasSize()
            if parent:IsA("ScrollingFrame") then
                parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y + 20)
            end
        end
        
        updateCanvasSize()
        parent.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        
        local toggle = {
            Instance = toggleFrame,
            Value = toggled,
            Set = function(self, value)
                if toggled ~= value then
                    toggled = not toggled
                    updateToggle()
                end
            end
        }
        
        return toggle
    end
    
    function window:AddSlider(text, min, max, default, callback, parent, sliderIcon)
        parent = parent or scrollFrame
        min = min or 0
        max = max or 100
        default = math.clamp(default or min, min, max)
        callback = callback or function() end
        
        local sliderFrame = Util.Create("Frame", {
            Name = text .. "_Slider",
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
        local shadow = Util.Shadow(sliderBackground, 6, 0.8)
        
        -- Add icon if provided
        if sliderIcon and Icons[sliderIcon] then
            local icon = Util.CreateIcon(
                Icons[sliderIcon],
                IconRects[sliderIcon],
                UDim2.new(0, 18, 0, 18),
                UDim2.new(0, 10, 0, 10),
                self.Theme.Text,
                sliderBackground,
                13
            )
            
            -- Create slider label with icon offset
            local sliderLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 5),
                Size = UDim2.new(1, -50, 0, 20),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = sliderBackground
            })
        else
            -- Create slider label without icon
            local sliderLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 5),
                Size = UDim2.new(1, -30, 0, 20),
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
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -15, 0, 5),
            Size = UDim2.new(0, 50, 0, 20),
            Font = Enum.Font.GothamMedium,
            Text = tostring(default),
            TextColor3 = self.Theme.Primary,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 13,
            Parent = sliderBackground
        })
        
        -- Create slider track
        local sliderTrack = Util.Create("Frame", {
            Name = "Track",
            BackgroundColor3 = self.Theme.SliderBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 15, 0, 35),
            Size = UDim2.new(1, -30, 0, 5),
            ZIndex = 13,
            Parent = sliderBackground
        })
        
        local trackCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 3),
            Parent = sliderTrack
        })
        
        -- Create slider fill
        local sliderFill = Util.Create("Frame", {
            Name = "Fill",
            BackgroundColor3 = self.Theme.SliderFill,
            BorderSizePixel = 0,
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            ZIndex = 14,
            Parent = sliderTrack
        })
        
        local fillCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(0, 3),
            Parent = sliderFill
        })
        
        -- Create slider knob
        local sliderKnob = Util.Create("Frame", {
            Name = "Knob",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = self.Theme.Primary,
            BorderSizePixel = 0,
            Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
            Size = UDim2.new(0, 12, 0, 12),
            ZIndex = 15,
            Parent = sliderTrack
        })
        
        local knobCorner = Util.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = sliderKnob
        })
        
        -- Create knob shadow
        local knobShadow = Util.Shadow(sliderKnob, 8, 0.9)
        
        -- Slider functionality
        local value = default
        local sliding = false
        
        -- Function to update slider value
        local function updateSlider(input)
            local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local newValue = math.floor(min + (max - min) * percentage)
            
            if newValue ~= value then
                value = newValue
                valueDisplay.Text = tostring(value)
                
                -- Update fill and knob positions
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderKnob.Position = UDim2.new(percentage, 0, 0.5, 0)
                
                callback(value)
            end
        end
        
        sliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                updateSlider(input)
            end
        end)
        
        sliderTrack.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        
        -- Hover effect
        sliderBackground.MouseEnter:Connect(function()
            Util.Tween(sliderBackground, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        sliderBackground.MouseLeave:Connect(function()
            Util.Tween(sliderBackground, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update canvas size for scrolling
        local function updateCanvasSize()
            if parent:IsA("ScrollingFrame") then
                parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y + 20)
            end
        end
        
        updateCanvasSize()
        parent.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        
        local slider = {
            Instance = sliderFrame,
            Value = value,
            Set = function(self, newValue)
                local clampedValue = math.clamp(newValue, min, max)
                if value ~= clampedValue then
                    value = clampedValue
                    valueDisplay.Text = tostring(value)
                    
                    local percentage = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(percentage, 0, 0.5, 0)
                    
                    callback(value)
                end
            end,
            SetMax = function(self, newMax)
                max = newMax
                if value > max then
                    self:Set(max)
                else
                    local percentage = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(percentage, 0, 0.5, 0)
                end
            end,
            SetMin = function(self, newMin)
                min = newMin
                if value < min then
                    self:Set(min)
                else
                    local percentage = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderKnob.Position = UDim2.new(percentage, 0, 0.5, 0)
                end
            end
        }
        
        return slider
    end
    
    function window:AddDropdown(text, options, default, callback, parent, dropdownIcon)
        parent = parent or scrollFrame
        options = options or {}
        default = default or options[1] or ""
        callback = callback or function() end
        
        local dropdownFrame = Util.Create("Frame", {
            Name = text .. "_Dropdown",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, self.Theme.DropdownHeight),
            Parent = parent
        })
        
        local dropdownButton = Util.Create("TextButton", {
            Name = "Button",
            BackgroundColor3 = self.Theme.ButtonColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            ZIndex = 12,
            Parent = dropdownFrame
        })
        
        local dropdownCorner = Util.Create("UICorner", {
            CornerRadius = self.Theme.CornerRadius,
            Parent = dropdownButton
        })
        
        -- Add shadow
        local shadow = Util.Shadow(dropdownButton, 6, 0.8)
        
        -- Add icon if provided
        if dropdownIcon and Icons[dropdownIcon] then
            local icon = Util.CreateIcon(
                Icons[dropdownIcon],
                IconRects[dropdownIcon],
                UDim2.new(0, 18, 0, 18),
                UDim2.new(0, 10, 0.5, 0),
                self.Theme.Text,
                dropdownButton,
                13
            )
            
            -- Create dropdown label with icon offset
            local dropdownLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(0.6, -40, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = dropdownButton
            })
        else
            -- Create dropdown label without icon
            local dropdownLabel = Util.Create("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(0.6, -15, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = text,
                TextColor3 = self.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 13,
                Parent = dropdownButton
            })
        end
        
        -- Create selected value display
        local selectedDisplay = Util.Create("TextLabel", {
            Name = "Selected",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -30, 0.5, 0),
            Size = UDim2.new(0.4, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = default,
            TextColor3 = self.Theme.TextDark,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 13,
            Parent = dropdownButton
        })
        
        -- Create dropdown arrow
        local dropdownArrow = Util.CreateIcon(
            Icons["ArrowRight"],
            IconRects["ArrowRight"],
            UDim2.new(0, 16, 0, 16),
            UDim2.new(1, -15, 0.5, 0),
            self.Theme.Text,
            dropdownButton,
            13
        )
        dropdownArrow.AnchorPoint = Vector2.new(0.5, 0.5)
        dropdownArrow.Rotation = 90 -- Point down
        
        -- Create dropdown container
        local dropdownContainer = Util.Create("Frame", {
            Name = "Container",
            BackgroundColor3 = self.Theme.DropdownBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 0), -- Will be sized based on options
            ZIndex = 14,
            Visible = false,
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
            
            -- Item button click handler
            itemButton.MouseButton1Click:Connect(function()
                selectedDisplay.Text = option
                callback(option)
                
                -- Close dropdown
                Util.Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                Util.Tween(dropdownArrow, {Rotation = 90}, 0.2)
                task.wait(0.2)
                dropdownContainer.Visible = false
            })
            
            -- Item button hover effect
            itemButton.MouseEnter:Connect(function()
                Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownHover}, 0.1)
            end)
            
            itemButton.MouseLeave:Connect(function()
                Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownItem}, 0.1)
            end)
            
            table.insert(itemButtons, itemButton)
            containerSize = containerSize + 32 -- 30 for button + 2 for padding
        end
        
        -- Set the scroll frame canvas size
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, containerSize)
        
        -- Dropdown toggle functionality
        local dropdownOpen = false
        
        dropdownButton.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            
            if dropdownOpen then
                -- Calculate max height (limited to 200 pixels)
                local maxHeight = math.min(containerSize, 200)
                
                -- Show dropdown
                dropdownContainer.Visible = true
                Util.Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, maxHeight)}, 0.2)
                Util.Tween(dropdownArrow, {Rotation = 270}, 0.2) -- Point up
            else
                -- Hide dropdown
                Util.Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                Util.Tween(dropdownArrow, {Rotation = 90}, 0.2) -- Point down
                task.wait(0.2)
                dropdownContainer.Visible = false
            end
        end)
        
        -- Dropdown button hover effect
        dropdownButton.MouseEnter:Connect(function()
            Util.Tween(dropdownButton, {BackgroundColor3 = self.Theme.ButtonHover}, 0.2)
        end)
        
        dropdownButton.MouseLeave:Connect(function()
            Util.Tween(dropdownButton, {BackgroundColor3 = self.Theme.ButtonColor}, 0.2)
        end)
        
        -- Update canvas size for scrolling
        local function updateCanvasSize()
            if parent:IsA("ScrollingFrame") then
                parent.CanvasSize = UDim2.new(0, 0, 0, parent.UIListLayout.AbsoluteContentSize.Y + 20)
            end
        end
        
        updateCanvasSize()
        parent.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        
        -- Handle auto-close when clicking outside
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdownOpen then
                local mousePos = UserInputService:GetMouseLocation()
                local dropdownPos = dropdownContainer.AbsolutePosition
                local dropdownSize = dropdownContainer.AbsoluteSize
                
                if mousePos.X < dropdownPos.X or 
                   mousePos.Y < dropdownPos.Y or 
                   mousePos.X > dropdownPos.X + dropdownSize.X or 
                   mousePos.Y > dropdownPos.Y + dropdownSize.Y then
                    if not (mousePos.X >= dropdownButton.AbsolutePosition.X and
                           mousePos.Y >= dropdownButton.AbsolutePosition.Y and
                           mousePos.X <= dropdownButton.AbsolutePosition.X + dropdownButton.AbsoluteSize.X and
                           mousePos.Y <= dropdownButton.AbsolutePosition.Y + dropdownButton.AbsoluteSize.Y) then
                        -- Mouse is outside both dropdown and button
                        dropdownOpen = false
                        Util.Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Util.Tween(dropdownArrow, {Rotation = 90}, 0.2)
                        task.wait(0.2)
                        dropdownContainer.Visible = false
                    end
                end
            end
        end)
        
        local dropdown = {
            Instance = dropdownFrame,
            Value = default,
            Options = options,
            Set = function(self, option)
                if table.find(options, option) then
                    selectedDisplay.Text = option
                    self.Value = option
                    callback(option)
                end
            end,
            Update = function(self, newOptions)
                -- Clear existing items
                for _, button in pairs(itemButtons) do
                    button:Destroy()
                end
                itemButtons = {}
                
                -- Update options
                options = newOptions
                self.Options = newOptions
                
                -- Reset selected value if it's not in the new options
                if not table.find(options, self.Value) then
                    self.Value = options[1] or ""
                    selectedDisplay.Text = self.Value
                end
                
                -- Recreate dropdown items
                containerSize = 10 -- Reset with padding
                
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
                    
                    -- Item button click handler
                    itemButton.MouseButton1Click:Connect(function()
                        selectedDisplay.Text = option
                        self.Value = option
                        callback(option)
                        
                        -- Close dropdown
                        Util.Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Util.Tween(dropdownArrow, {Rotation = 90}, 0.2)
                        task.wait(0.2)
                        dropdownContainer.Visible = false
                        dropdownOpen = false
                    end)
                    
                    -- Item button hover effect
                    itemButton.MouseEnter:Connect(function()
                        Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownHover}, 0.1)
                    end)
                    
                    itemButton.MouseLeave:Connect(function()
                        Util.Tween(itemButton, {BackgroundColor3 = self.Theme.DropdownItem}, 0.1)
                    end)
                    
                    table.insert(itemButtons, itemButton)
                    containerSize = containerSize + 32 -- 30 for button + 2 for padding
                end
                
                -- Update the scroll frame canvas size
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, containerSize)
            end
        }
        
        return dropdown
    end
    
    -- Add the remaining UI components (ColorPicker, TextBox, etc.)
    -- Update other window functions
    
    -- Animate window appearance when created
    mainFrame.Size = UDim2.new(0, size.X.Offset, 0, 0)
    Util.Tween(mainFrame, {Size = size}, 0.3, Enum.EasingStyle.Quart)
    
    return window
end

-- Notification system
function AdvancedUI:Notify(title, message, notifType, duration)
    title = title or "Notification"
    message = message or ""
    notifType = notifType or "Info" -- Info, Success, Warning, Error
    duration = duration or 5 -- seconds
    
    -- Create notification
    local notification = self:CreateNotification(title, message, notifType, duration)
    return notification
end

-- Return the library
return AdvancedUI
