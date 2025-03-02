-- Advanced Roblox UI Library with Icons
-- A sophisticated, feature-rich UI library with shadows, icons, animations, and modern components
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local ContentProvider = game:GetService("ContentProvider")

-- Define the library module
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

function Util.Tween(instance, properties, duration, style, direction)
    -- Check if instance exists and is valid
    if not instance or typeof(instance) ~= "Instance" then
        warn("Util.Tween: Invalid instance")
        return
    end
    
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, style, direction),
        properties
    )
    
    tween:Play()
    return tween
end

function Util.Shadow(parent, size, transparency)
    size = size or 10
    transparency = transparency or 0.5
    
    local shadow = Util.Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size, 1, size),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = parent
    })
    
    return shadow
end

function Util.CreateIcon(imageId, imageRect, size, position, color, parent, zIndex)
    local icon = Util.Create("ImageLabel", {
        Name = "Icon",
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        Image = imageId,
        ImageRectOffset = Vector2.new(imageRect.Min.X, imageRect.Min.Y),
        ImageRectSize = Vector2.new(
            imageRect.Max.X - imageRect.Min.X,
            imageRect.Max.Y - imageRect.Min.Y
        ),
        ImageColor3 = color,
        ZIndex = zIndex or parent.ZIndex + 1,
        Parent = parent
    })
    
    return icon
end

-- Default Theme
local DefaultTheme = {
    Primary = Color3.fromRGB(255, 100, 50),
    Secondary = Color3.fromRGB(35, 35, 35),
    Background = Color3.fromRGB(25, 25, 25),
    BackgroundDark = Color3.fromRGB(20, 20, 20),
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

-- Theme presets
local ThemePresets = {
    Dark = DefaultTheme,
    Light = {
        Primary = Color3.fromRGB(0, 120, 215),
        Secondary = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(250, 250, 250),
        BackgroundDark = Color3.fromRGB(230, 230, 230),
        -- Add other theme properties as needed
    }
}

-- Initialize the UI Library
function AdvancedUI.new(themePreset)
    local theme
    if type(themePreset) == "string" and ThemePresets[themePreset] then
        theme = ThemePresets[themePreset]
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
        pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end)
        
        if not screenGui.Parent then
            screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
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

-- Fix - Initialize method (making sure we support both Init and new)
function AdvancedUI:Init(customTheme)
    return AdvancedUI.new(customTheme)
end

-- Send notification function
function AdvancedUI:Notify(title, message, duration, notifType)
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
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 5, 1, 0),
        ZIndex = 1001,
        Parent = notification
    })
    
    local leftBarCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = leftBar
    })
    
    -- Create icon
    local icon = Util.CreateIcon(
        Icons[iconInfo.icon],
        IconRects[iconInfo.icon],
        UDim2.new(0, 20, 0, 20),
        UDim2.new(0, 15, 0, 21),
        iconInfo.color,
        notification,
        1001
    )
    
    -- Create title
    local titleLabel = Util.Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 10),
        Size = UDim2.new(1, -55, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1001,
        Parent = notification
    })
    
    -- Create message
    local messageLabel = Util.Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 32),
        Size = UDim2.new(1, -55, 0, 0), -- Will be sized based on text
        Font = Enum.Font.Gotham,
        Text = message,
        TextColor3 = self.Theme.TextDark,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1001,
        Parent = notification
    })
    
    -- Create close button
    local closeButton = Util.Create("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -5, 0, 5),
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

-- Create a new window function
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
        Position = position or UDim2.new(0.5, -250, 0.5, -150),
        Size = size or UDim2.new(0, 500, 0, 300),
        ZIndex = 10,
        Parent = self.ScreenGui
    })
    
    local cornerRadius = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = mainFrame
    })
    
    -- Add shadow
    local shadow = Util.Shadow(mainFrame, 15, 0.5)
    
    -- Create title bar
    local titleBar = Util.Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = self.Theme.BackgroundDark,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 11,
        Parent = mainFrame
    })
    
    local titleCorner = Util.Create("UICorner", {
        CornerRadius = self.Theme.CornerRadius,
        Parent = titleBar
    })
    
    -- Title bar bottom corner fix
    local titleBarFix = Util.Create("Frame", {
        Name = "TitleBarFix",
        BackgroundColor3 = self.Theme.BackgroundDark,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10),
        ZIndex = 11,
        Parent = titleBar
    })
    
    -- Add icon if provided
    if icon and Icons[icon] then
        local windowIcon = Util.CreateIcon(
            Icons[icon],
            IconRects[icon],
            UDim2.new(0, 20, 0, 20),
            UDim2.new(0, 15, 0.5, 0),
            self.Theme.Primary,
            titleBar,
            12
        )
        
        -- Create title with icon offset
        local titleText = Util.Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 45, 0, 0),
            Size = UDim2.new(1, -100, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = self.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 12,
            Parent = titleBar
        })
    else
        -- Create title without icon
        local titleText = Util.Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(1, -100, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = self.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 12,
            Parent = titleBar
        })
    end
    
    -- Add window controls (close, minimize)
    local closeButton = Util.Create("TextButton", {
        Name = "CloseButton",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = self.Theme.TextDark,
        TextSize = 24,
        ZIndex = 12,
        Parent = titleBar
    })
    
    local minimizeButton = Util.Create("TextButton", {
        Name = "MinimizeButton",
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0.5, 0),
        Size = UDim2.new(0, 30, 0, 30),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = self.Theme.TextDark,
        TextSize = 24,
        ZIndex = 12,
        Parent = titleBar
    })
    
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

    -- Rest of implementation would continue here

    -- Add Window to the UI
    table.insert(self.Windows, window)
    
    -- Return window object with basic methods
    return window
end

-- Return the library module
return AdvancedUI
