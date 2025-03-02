--[[
    NeoUI Library
    A modern, animated UI library for Roblox
    
    Features:
    - Smooth animations and transitions
    - Dynamic shadows and glow effects
    - Modern design with custom fonts
    - Responsive elements with satisfying feedback
    - Comprehensive element set (buttons, toggles, sliders, etc.)
]]

local NeoUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")

-- Constants
local FONT = Enum.Font.GothamBold
local TITLE_FONT = Enum.Font.GothamBlack
local ACCENT_COLOR = Color3.fromRGB(0, 170, 255)
local BACKGROUND_COLOR = Color3.fromRGB(25, 25, 30)
local SECONDARY_COLOR = Color3.fromRGB(35, 35, 40)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local SHADOW_COLOR = Color3.fromRGB(0, 0, 0)
local HOVER_COLOR_OFFSET = Color3.fromRGB(15, 15, 15)
local CORNER_RADIUS = UDim.new(0, 6)
local BLUR_SIZE = 15

-- Animation configurations
local ANIMATION_SPEED = 0.25
local ANIMATION_STYLE = Enum.EasingStyle.Quart
local ANIMATION_DIRECTION = Enum.EasingDirection.Out

-- Tween Info presets
local TweenInfo_Fast = TweenInfo.new(0.15, ANIMATION_STYLE, ANIMATION_DIRECTION)
local TweenInfo_Default = TweenInfo.new(ANIMATION_SPEED, ANIMATION_STYLE, ANIMATION_DIRECTION)
local TweenInfo_Slow = TweenInfo.new(0.5, ANIMATION_STYLE, ANIMATION_DIRECTION)

-- Load resources
local Icons = {
    Close = "rbxassetid://10723407389",
    Settings = "rbxassetid://3605022185",
    Home = "rbxassetid://6026568198",
    Warning = "rbxassetid://6031071053",
    Toggle_On = "rbxassetid://6031068426",
    Toggle_Off = "rbxassetid://6031068433",
    Arrow = "rbxassetid://6034818372",
}

-- Utilities
local function Round(number, decimalPlaces)
    local mult = 10^(decimalPlaces or 0)
    return math.floor(number * mult + 0.5) / mult
end

local function DarkenColor(color, amount)
    return Color3.new(
        math.clamp(color.R - amount, 0, 1),
        math.clamp(color.G - amount, 0, 1),
        math.clamp(color.B - amount, 0, 1)
    )
end

local function LightenColor(color, amount)
    return Color3.new(
        math.clamp(color.R + amount, 0, 1),
        math.clamp(color.G + amount, 0, 1),
        math.clamp(color.B + amount, 0, 1)
    )
end

local function CreateShadow(parent, layers, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(1, layers * 2, 1, layers * 2)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = SHADOW_COLOR
    shadow.ImageTransparency = transparency
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function CreateGlow(parent, size, color, transparency)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.Size = UDim2.new(1, size * 2, 1, size * 2)
    glow.ZIndex = parent.ZIndex - 2
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or ACCENT_COLOR
    glow.ImageTransparency = transparency or 0.85
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.Parent = parent
    return glow
end

local function ApplyCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or CORNER_RADIUS
    corner.Parent = instance
    return corner
end

local function CreateRipple(parent)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ApplyCorners(ripple, UDim.new(1, 0))
    ripple.Parent = parent
    
    local position = UserInputService:GetMouseLocation() - parent.AbsolutePosition
    ripple.Position = UDim2.new(0, position.X, 0, position.Y)
    
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    local tween = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Create main UI container
function NeoUI:New(config)
    config = config or {}
    local name = config.Name or "NeoUI"
    local keybind = config.Keybind or "RightShift"
    
    -- Create a unique random ID for the GUI
    local id = HttpService:GenerateGUID(false)
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NeoUI_" .. id
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Handle CoreGui restrictions
    local parentGui
    pcall(function()
        parentGui = CoreGui
        screenGui.Parent = parentGui
    end)
    if not screenGui.Parent then
        parentGui = Player:WaitForChild("PlayerGui")
        screenGui.Parent = parentGui
    end
    
    -- Create loading animation
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.BackgroundColor3 = BACKGROUND_COLOR
    loadingFrame.BackgroundTransparency = 0.3
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.ZIndex = 10000
    loadingFrame.Parent = screenGui
    
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 0
    blurEffect.Parent = game:GetService("Lighting")
    TweenService:Create(blurEffect, TweenInfo_Default, {Size = BLUR_SIZE}):Play()
    
    local loadingContainer = Instance.new("Frame")
    loadingContainer.Name = "LoadingContainer"
    loadingContainer.BackgroundColor3 = BACKGROUND_COLOR
    loadingContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    loadingContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingContainer.Size = UDim2.new(0, 280, 0, 120)
    loadingContainer.ZIndex = 10001
    ApplyCorners(loadingContainer)
    CreateShadow(loadingContainer, 15, 0.5)
    loadingContainer.Parent = loadingFrame
    
    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Name = "Title"
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.Position = UDim2.new(0, 0, 0, 15)
    loadingTitle.Size = UDim2.new(1, 0, 0, 30)
    loadingTitle.Font = TITLE_FONT
    loadingTitle.Text = name
    loadingTitle.TextColor3 = TEXT_COLOR
    loadingTitle.TextSize = 22
    loadingTitle.ZIndex = 10002
    loadingTitle.Parent = loadingContainer
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Name = "LoadingBar"
    loadingBar.BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.05)
    loadingBar.Position = UDim2.new(0.5, 0, 0.6, 0)
    loadingBar.AnchorPoint = Vector2.new(0.5, 0)
    loadingBar.Size = UDim2.new(0.8, 0, 0, 6)
    loadingBar.ZIndex = 10002
    ApplyCorners(loadingBar, UDim.new(0, 3))
    loadingBar.Parent = loadingContainer
    
    local loadingFill = Instance.new("Frame")
    loadingFill.Name = "Fill"
    loadingFill.BackgroundColor3 = ACCENT_COLOR
    loadingFill.Size = UDim2.new(0, 0, 1, 0)
    loadingFill.ZIndex = 10003
    ApplyCorners(loadingFill, UDim.new(0, 3))
    loadingFill.Parent = loadingBar
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "Status"
    loadingText.BackgroundTransparency = 1
    loadingText.Position = UDim2.new(0, 0, 0.75, 0)
    loadingText.Size = UDim2.new(1, 0, 0, 20)
    loadingText.Font = FONT
    loadingText.Text = "Loading..."
    loadingText.TextColor3 = TEXT_COLOR
    loadingText.TextSize = 14
    loadingText.ZIndex = 10002
    loadingText.Parent = loadingContainer
    
    -- Animate the loading bar
    local loadingTween = TweenService:Create(loadingFill, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    loadingTween:Play()
    
    -- Create main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.BackgroundColor3 = BACKGROUND_COLOR
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Visible = false
    ApplyCorners(mainFrame)
    CreateShadow(mainFrame, 20, 0.5)
    CreateGlow(mainFrame, 30, ACCENT_COLOR, 0.9)
    mainFrame.Parent = screenGui
    
    -- Create title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = DarkenColor(BACKGROUND_COLOR, 0.03)
    titleBar.BorderSizePixel = 0
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.ZIndex = 2
    
    local corner = ApplyCorners(titleBar)
    
    local bottomCover = Instance.new("Frame")
    bottomCover.Name = "BottomCover"
    bottomCover.BackgroundColor3 = titleBar.BackgroundColor3
    bottomCover.BorderSizePixel = 0
    bottomCover.Position = UDim2.new(0, 0, 1, -10)
    bottomCover.Size = UDim2.new(1, 0, 0, 10)
    bottomCover.ZIndex = titleBar.ZIndex
    bottomCover.Parent = titleBar
    
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Font = TITLE_FONT
    titleText.Text = name
    titleText.TextColor3 = TEXT_COLOR
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.ZIndex = 2
    titleText.Parent = titleBar
    
    -- Create close button
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseButton"
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -35, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(0, 0.5)
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Image = Icons.Close
    closeBtn.ImageColor3 = TEXT_COLOR
    closeBtn.ZIndex = 3
    closeBtn.Parent = titleBar
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo_Fast, {ImageColor3 = Color3.fromRGB(255, 80, 80)}):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo_Fast, {ImageColor3 = TEXT_COLOR}):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(mainFrame, TweenInfo_Default, {Position = UDim2.new(0.5, 0, 1.5, 0)}):Play()
        TweenService:Create(blurEffect, TweenInfo_Default, {Size = 0}):Play()
        wait(ANIMATION_SPEED)
        screenGui:Destroy()
        blurEffect:Destroy()
    end)
    
    -- Make window draggable
    local dragging = false
    local dragStart
    local startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundColor3 = DarkenColor(BACKGROUND_COLOR, 0.03)
    tabContainer.BorderSizePixel = 0
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.Size = UDim2.new(0, 140, 1, -40)
    tabContainer.ZIndex = 2
    tabContainer.Parent = mainFrame
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Vertical
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabContainer
    
    local tabsPadding = Instance.new("UIPadding")
    tabsPadding.PaddingTop = UDim.new(0, 10)
    tabsPadding.Parent = tabContainer
    
    -- Content container
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundColor3 = BACKGROUND_COLOR
    contentFrame.BorderSizePixel = 0
    contentFrame.Position = UDim2.new(0, 140, 0, 40)
    contentFrame.Size = UDim2.new(1, -140, 1, -40)
    contentFrame.ZIndex = 1
    contentFrame.Parent = mainFrame
    
    -- Toggle GUI with keybind
    local toggled = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode[keybind] then
            toggled = not toggled
            if toggled then
                TweenService:Create(mainFrame, TweenInfo_Default, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
                TweenService:Create(blurEffect, TweenInfo_Default, {Size = BLUR_SIZE}):Play()
            else
                TweenService:Create(mainFrame, TweenInfo_Default, {Position = UDim2.new(0.5, 0, 1.5, 0)}):Play()
                TweenService:Create(blurEffect, TweenInfo_Default, {Size = 0}):Play()
            end
        end
    end)
    
    -- Window object
    local windowObj = {}
    windowObj.Pages = {}
    windowObj.CurrentPage = nil
    
    -- Add page function
    function windowObj:AddPage(name, icon)
        local pageIcon = icon or Icons.Home
        
        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.BackgroundColor3 = DarkenColor(BACKGROUND_COLOR, 0.05)
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(0.9, 0, 0, 40)
        tabButton.Font = FONT
        tabButton.Text = "  " .. name
        tabButton.TextColor3 = TEXT_COLOR
        tabButton.TextSize = 14
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.ZIndex = 2
        ApplyCorners(tabButton)
        tabButton.Parent = tabContainer
        
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.BackgroundTransparency = 1
        tabIcon.Position = UDim2.new(0, 10, 0.5, 0)
        tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        tabIcon.Size = UDim2.new(0, 18, 0, 18)
        tabIcon.Image = pageIcon
        tabIcon.ImageColor3 = TEXT_COLOR
        tabIcon.ZIndex = 3
        tabIcon.Parent = tabButton
        
        local tabSelection = Instance.new("Frame")
        tabSelection.Name = "Selection"
        tabSelection.BackgroundColor3 = ACCENT_COLOR
        tabSelection.BorderSizePixel = 0
        tabSelection.Position = UDim2.new(0, 0, 0.5, 0)
        tabSelection.AnchorPoint = Vector2.new(0, 0.5)
        tabSelection.Size = UDim2.new(0, 3, 0.7, 0)
        tabSelection.ZIndex = 3
        tabSelection.Visible = false
        ApplyCorners(tabSelection, UDim.new(0, 2))
        tabSelection.Parent = tabButton
        
        -- Create page container
        local pageContainer = Instance.new("ScrollingFrame")
        pageContainer.Name = name .. "Page"
        pageContainer.BackgroundTransparency = 1
        pageContainer.BorderSizePixel = 0
        pageContainer.Size = UDim2.new(1, 0, 1, 0)
        pageContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        pageContainer.ScrollBarThickness = 3
        pageContainer.ScrollBarImageColor3 = ACCENT_COLOR
        pageContainer.Visible = false
        pageContainer.ZIndex = 2
        pageContainer.Parent = contentFrame
        
        local pageLayout = Instance.new("UIListLayout")
        pageLayout.FillDirection = Enum.FillDirection.Vertical
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 10)
        pageLayout.Parent = pageContainer
        
        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.PaddingBottom = UDim.new(0, 10)
        pagePadding.Parent = pageContainer
        
        -- Auto-update canvas size
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            pageContainer.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Page object
        local pageObj = {}
        pageObj.Name = name
        pageObj.Container = pageContainer
        
        -- Add section function
        function pageObj:AddSection(title)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = title .. "Section"
            sectionFrame.BackgroundColor3 = SECONDARY_COLOR
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Size = UDim2.new(0.95, 0, 0, 40) -- Will be resized based on content
            sectionFrame.ZIndex = 2
            ApplyCorners(sectionFrame)
            CreateShadow(sectionFrame, 4, 0.7)
            sectionFrame.Parent = pageContainer
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Position = UDim2.new(0, 15, 0, 0)
            sectionTitle.Size = UDim2.new(1, -15, 0, 30)
            sectionTitle.Font = TITLE_FONT
            sectionTitle.Text = title
            sectionTitle.TextColor3 = TEXT_COLOR
            sectionTitle.TextSize = 15
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.ZIndex = 3
            sectionTitle.Parent = sectionFrame
            
            local sectionContentFrame = Instance.new("Frame")
            sectionContentFrame.Name = "Content"
            sectionContentFrame.BackgroundTransparency = 1
            sectionContentFrame.Position = UDim2.new(0, 0, 0, 30)
            sectionContentFrame.Size = UDim2.new(1, 0, 0, 0) -- Will be resized based on content
            sectionContentFrame.ZIndex = 2
            sectionContentFrame.Parent = sectionFrame
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.FillDirection = Enum.FillDirection.Vertical
            sectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 8)
            sectionLayout.Parent = sectionContentFrame
            
            local sectionPadding = Instance.new("UIPadding")
            sectionPadding.PaddingTop = UDim.new(0, 8)
            sectionPadding.PaddingBottom = UDim.new(0, 8)
            sectionPadding.Parent = sectionContentFrame
            
            -- Auto-resize section
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionContentFrame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 16)
                sectionFrame.Size = UDim2.new(0.95, 0, 0, sectionContentFrame.Size.Y.Offset + 30)
            end)
            
            -- Section object
            local sectionObj = {}
            sectionObj.Container = sectionContentFrame
            
            -- Add button function
            function sectionObj:AddButton(text, callback)
                callback = callback or function() end
                
                local buttonFrame = Instance.new("Frame")
                buttonFrame.Name = text .. "Button"
                buttonFrame.BackgroundTransparency = 1
                buttonFrame.Size = UDim2.new(0.95, 0, 0, 35)
                buttonFrame.ZIndex = 3
                buttonFrame.Parent = sectionContentFrame
                
                local button = Instance.new("TextButton")
                button.Name = "Button"
                button.BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.1)
                button.BorderSizePixel = 0
                button.Position = UDim2.new(0, 0, 0, 0)
                button.Size = UDim2.new(1, 0, 1, 0)
                button.Font = FONT
                button.Text = text
                button.TextColor3 = TEXT_COLOR
                button.TextSize = 14
                button.ZIndex = 3
                button.ClipsDescendants = true
                ApplyCorners(button)
                CreateShadow(button, 4, 0.8)
                button.Parent = buttonFrame
                
                -- Button animations
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo_Fast, {BackgroundColor3 = LightenColor(SECONDARY_COLOR, 0.05)}):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo_Fast, {BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.1)}):Play()
                end)
                
                button.MouseButton1Down:Connect(function()
                    TweenService:Create(button, TweenInfo_Fast, {BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.15)}):Play()
                    CreateRipple(button)
                end)
                
                button.MouseButton1Up:Connect(function()
                    TweenService:Create(button, TweenInfo_Fast, {BackgroundColor3 = LightenColor(SECONDARY_COLOR, 0.05)}):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                local btnObj = {}
                
                function btnObj:SetText(newText)
                    button.Text = newText
                end
                
                function btnObj:SetCallback(newCallback)
                    callback = newCallback
                end
                
                return btnObj
            end
            
            -- Add toggle function
            function sectionObj:AddToggle(text, default, callback)
                default = default or false
                callback = callback or function() end
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = text .. "Toggle"
                toggleFrame.BackgroundTransparency = 1
                toggleFrame.Size = UDim2.new(0.95, 0, 0 
                toggleFrame.Size = UDim2.new(0.95, 0, 0, 35)
                toggleFrame.ZIndex = 3
                toggleFrame.Parent = sectionContentFrame
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Name = "Label"
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Position = UDim2.new(0, 10, 0, 0)
                toggleLabel.Size = UDim2.new(1, -50, 1, 0)
                toggleLabel.Font = FONT
                toggleLabel.Text = text
                toggleLabel.TextColor3 = TEXT_COLOR
                toggleLabel.TextSize = 14
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.ZIndex = 3
                toggleLabel.Parent = toggleFrame
                
                local toggleBtn = Instance.new("Frame")
                toggleBtn.Name = "ToggleButton"
                toggleBtn.BackgroundColor3 = default and ACCENT_COLOR or DarkenColor(SECONDARY_COLOR, 0.2)
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Position = UDim2.new(1, -40, 0.5, 0)
                toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
                toggleBtn.Size = UDim2.new(0, 40, 0, 20)
                toggleBtn.ZIndex = 3
                ApplyCorners(toggleBtn, UDim.new(0, 10))
                toggleBtn.Parent = toggleFrame
                
                local toggleCircle = Instance.new("Frame")
                toggleCircle.Name = "Circle"
                toggleCircle.BackgroundColor3 = TEXT_COLOR
                toggleCircle.Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
                toggleCircle.Size = UDim2.new(0, 16, 0, 16)
                toggleCircle.ZIndex = 4
                ApplyCorners(toggleCircle, UDim.new(1, 0))
                CreateShadow(toggleCircle, 3, 0.7)
                toggleCircle.Parent = toggleBtn
                
                local toggled = default
                
                local function updateToggle()
                    toggled = not toggled
                    
                    local newPos = toggled and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                    local newColor = toggled and ACCENT_COLOR or DarkenColor(SECONDARY_COLOR, 0.2)
                    
                    TweenService:Create(toggleCircle, TweenInfo_Default, {Position = newPos}):Play()
                    TweenService:Create(toggleBtn, TweenInfo_Default, {BackgroundColor3 = newColor}):Play()
                    
                    callback(toggled)
                end
                
                toggleBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        updateToggle()
                    end
                end)
                
                local toggleObj = {}
                
                function toggleObj:SetState(state)
                    if state ~= toggled then
                        updateToggle()
                    end
                end
                
                function toggleObj:GetState()
                    return toggled
                end
                
                return toggleObj
            end
            
            -- Add slider function
            function sectionObj:AddSlider(text, config, callback)
                config = config or {}
                local min = config.min or 0
                local max = config.max or 100
                local default = config.default or min
                local increment = config.increment or 1
                callback = callback or function() end
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = text .. "Slider"
                sliderFrame.BackgroundTransparency = 1
                sliderFrame.Size = UDim2.new(0.95, 0, 0, 50)
                sliderFrame.ZIndex = 3
                sliderFrame.Parent = sectionContentFrame
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "Label"
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Position = UDim2.new(0, 10, 0, 0)
                sliderLabel.Size = UDim2.new(1, -20, 0, 20)
                sliderLabel.Font = FONT
                sliderLabel.Text = text
                sliderLabel.TextColor3 = TEXT_COLOR
                sliderLabel.TextSize = 14
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.ZIndex = 3
                sliderLabel.Parent = sliderFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "Value"
                valueLabel.BackgroundTransparency = 1
                valueLabel.Position = UDim2.new(1, -30, 0, 0)
                valueLabel.Size = UDim2.new(0, 30, 0, 20)
                valueLabel.Font = FONT
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = ACCENT_COLOR
                valueLabel.TextSize = 14
                valueLabel.ZIndex = 3
                valueLabel.Parent = sliderFrame
                
                local sliderBg = Instance.new("Frame")
                sliderBg.Name = "Background"
                sliderBg.BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.2)
                sliderBg.BorderSizePixel = 0
                sliderBg.Position = UDim2.new(0, 10, 0, 30)
                sliderBg.Size = UDim2.new(1, -20, 0, 5)
                sliderBg.ZIndex = 3
                ApplyCorners(sliderBg, UDim.new(0, 3))
                sliderBg.Parent = sliderFrame
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "Fill"
                sliderFill.BackgroundColor3 = ACCENT_COLOR
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.ZIndex = 4
                ApplyCorners(sliderFill, UDim.new(0, 3))
                sliderFill.Parent = sliderBg
                
                local sliderKnob = Instance.new("Frame")
                sliderKnob.Name = "Knob"
                sliderKnob.BackgroundColor3 = TEXT_COLOR
                sliderKnob.Position = UDim2.new(1, 0, 0.5, 0)
                sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
                sliderKnob.Size = UDim2.new(0, 14, 0, 14)
                sliderKnob.ZIndex = 5
                ApplyCorners(sliderKnob, UDim.new(1, 0))
                CreateShadow(sliderKnob, 3, 0.7)
                sliderKnob.Parent = sliderFill
                
                local currentValue = default
                
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newValue = min + ((max - min) * pos)
                    
                    -- Apply increment if specified
                    if increment then
                        newValue = min + (math.floor((newValue - min) / increment + 0.5) * increment)
                    end
                    
                    newValue = math.clamp(newValue, min, max)
                    currentValue = newValue
                    
                    -- Update UI
                    sliderFill.Size = UDim2.new((newValue - min) / (max - min), 0, 1, 0)
                    valueLabel.Text = tostring(Round(newValue, 2))
                    
                    callback(newValue)
                end
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        updateSlider(input)
                        local connection
                        connection = RunService.RenderStepped:Connect(function()
                            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                                updateSlider({Position = Vector2.new(Mouse.X, 0)})
                            else
                                connection:Disconnect()
                            end
                        end)
                    end
                end)
                
                local sliderObj = {}
                
                function sliderObj:SetValue(value)
                    value = math.clamp(value, min, max)
                    currentValue = value
                    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    valueLabel.Text = tostring(Round(value, 2))
                    callback(value)
                end
                
                function sliderObj:GetValue()
                    return currentValue
                end
                
                return sliderObj
            end
            
            -- Add dropdown function
            function sectionObj:AddDropdown(text, options, default, callback)
                options = options or {}
                default = default or options[1]
                callback = callback or function() end
                
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = text .. "Dropdown"
                dropdownFrame.BackgroundTransparency = 1
                dropdownFrame.Size = UDim2.new(0.95, 0, 0, 55)
                dropdownFrame.ZIndex = 3
                dropdownFrame.Parent = sectionContentFrame
                
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Name = "Label"
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                dropdownLabel.Size = UDim2.new(1, -20, 0, 20)
                dropdownLabel.Font = FONT
                dropdownLabel.Text = text
                dropdownLabel.TextColor3 = TEXT_COLOR
                dropdownLabel.TextSize = 14
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownLabel.ZIndex = 3
                dropdownLabel.Parent = dropdownFrame
                
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Name = "Button"
                dropdownButton.BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.1)
                dropdownButton.BorderSizePixel = 0
                dropdownButton.Position = UDim2.new(0, 10, 0, 25)
                dropdownButton.Size = UDim2.new(1, -20, 0, 30)
                dropdownButton.Font = FONT
                dropdownButton.Text = default
                dropdownButton.TextColor3 = TEXT_COLOR
                dropdownButton.TextSize = 14
                dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                dropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
                dropdownButton.ZIndex = 3
                ApplyCorners(dropdownButton)
                CreateShadow(dropdownButton, 4, 0.8)
                dropdownButton.Parent = dropdownFrame
                
                local paddingLeft = Instance.new("UIPadding")
                paddingLeft.PaddingLeft = UDim.new(0, 10)
                paddingLeft.Parent = dropdownButton
                
                local dropdownIcon = Instance.new("ImageLabel")
                dropdownIcon.Name = "Icon"
                dropdownIcon.BackgroundTransparency = 1
                dropdownIcon.Position = UDim2.new(1, -25, 0.5, 0)
                dropdownIcon.AnchorPoint = Vector2.new(0, 0.5)
                dropdownIcon.Size = UDim2.new(0, 16, 0, 16)
                dropdownIcon.Image = Icons.Arrow
                dropdownIcon.Rotation = 0
                dropdownIcon.ZIndex = 4
                dropdownIcon.Parent = dropdownButton
                
                local dropdownListFrame = Instance.new("Frame")
                dropdownListFrame.Name = "ListFrame"
                dropdownListFrame.BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.05)
                dropdownListFrame.BorderSizePixel = 0
                dropdownListFrame.Position = UDim2.new(0, 0, 1, 5)
                dropdownListFrame.Size = UDim2.new(1, 0, 0, 0)
                dropdownListFrame.ClipsDescendants = true
                dropdownListFrame.ZIndex = 5
                dropdownListFrame.Visible = false
                ApplyCorners(dropdownListFrame)
                CreateShadow(dropdownListFrame, 4, 0.8)
                dropdownListFrame.Parent = dropdownButton
                
                local dropdownList = Instance.new("ScrollingFrame")
                dropdownList.Name = "List"
                dropdownList.BackgroundTransparency = 1
                dropdownList.BorderSizePixel = 0
                dropdownList.Size = UDim2.new(1, 0, 1, 0)
                dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                dropdownList.ScrollBarThickness = 3
                dropdownList.ScrollBarImageColor3 = ACCENT_COLOR
                dropdownList.ZIndex = 5
                dropdownList.Parent = dropdownListFrame
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.FillDirection = Enum.FillDirection.Vertical
                listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Padding = UDim.new(0, 5)
                listLayout.Parent = dropdownList
                
                local listPadding = Instance.new("UIPadding")
                listPadding.PaddingTop = UDim.new(0, 5)
                listPadding.PaddingBottom = UDim.new(0, 5)
                listPadding.Parent = dropdownList
                
                -- Add options to dropdown
                local selectedOption = default
                local isOpen = false
                
                local function updateDropdown()
                    dropdownButton.Text = selectedOption
                    callback(selectedOption)
                end
                
                local function toggleDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        dropdownListFrame.Visible = true
                        TweenService:Create(dropdownIcon, TweenInfo_Default, {Rotation = 180}):Play()
                        TweenService:Create(dropdownListFrame, TweenInfo_Default, {Size = UDim2.new(1, 0, 0, math.min(120, #options * 30))}):Play()
                    else
                        TweenService:Create(dropdownIcon, TweenInfo_Default, {Rotation = 0}):Play()
                        TweenService:Create(dropdownListFrame, TweenInfo_Default, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                        wait(ANIMATION_SPEED)
                        if not isOpen then
                            dropdownListFrame.Visible = false
                        end
                    end
                end
                
                for i, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Name = option
                    optionButton.BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.1)
                    optionButton.BackgroundTransparency = 1
                    optionButton.BorderSizePixel = 0
                    optionButton.Size = UDim2.new(0.95, 0, 0, 25)
                    optionButton.Font = FONT
                    optionButton.Text = option
                    optionButton.TextColor3 = TEXT_COLOR
                    optionButton.TextSize = 14
                    optionButton.ZIndex = 6
                    ApplyCorners(optionButton)
                    optionButton.Parent = dropdownList
                    
                    -- Hover animations
                    optionButton.MouseEnter:Connect(function()
                        TweenService:Create(optionButton, TweenInfo_Fast, {BackgroundTransparency = 0.5}):Play()
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        TweenService:Create(optionButton, TweenInfo_Fast, {BackgroundTransparency = 1}):Play()
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        updateDropdown()
                        toggleDropdown()
                    end)
                end
                
                -- Update canvas size
                listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    dropdownList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
                end)
                
                dropdownButton.MouseButton1Click:Connect(function()
                    toggleDropdown()
                    CreateRipple(dropdownButton)
                end)
                
                local dropdownObj = {}
                
                function dropdownObj:SetOption(option)
                    if table.find(options, option) then
                        selectedOption = option
                        updateDropdown()
                    end
                end
                
                function dropdownObj:GetOption()
                    return selectedOption
                end
                
                function dropdownObj:UpdateOptions(newOptions)
                    options = newOptions
                    
                    -- Clear existing options
                    for _, child in pairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Add new options
                    for i, option in ipairs(options) do
                        local optionButton = Instance.new("TextButton")
                        optionButton.Name = option
                        optionButton.BackgroundColor3 = DarkenColor(SECONDARY_COLOR, 0.1)
                        optionButton.BackgroundTransparency = 1
                        optionButton.BorderSizePixel = 0
                        optionButton.Size = UDim2.new(0.95, 0, 0, 25)
                        optionButton.Font = FONT
                        optionButton.Text = option
                        optionButton.TextColor3 = TEXT_COLOR
                        optionButton.TextSize = 14
                        optionButton.ZIndex = 6
                        ApplyCorners(optionButton)
                        optionButton.Parent = dropdownList
                        
                        optionButton.MouseEnter:Connect(function()
                            TweenService:Create(optionButton, TweenInfo_Fast, {BackgroundTransparency = 0.5}):Play()
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            TweenService:Create(optionButton, TweenInfo_Fast, {BackgroundTransparency = 1}):Play()
                        end)
                        
                        optionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            updateDropdown()
                            toggleDropdown()
                        end)
                    end
                    
                    -- Update selected option if it no longer exists
                    if not table.find(options, selectedOption) and #options > 0 then
                        selectedOption = options[1]
                        updateDropdown()
                    end
                end
                
                return dropdownObj
            end
            
            return sectionObj
        end
        
        -- Tab button events
        tabButton.MouseButton1Click:Connect(function()
            CreateRipple(tabButton)
            
            -- Deselect current page
            if windowObj.CurrentPage then
                windowObj.CurrentPage.Container.Visible = false
                windowObj.CurrentPage.Button.Selection.Visible = false
                TweenService:Create(windowObj.CurrentPage.Button, TweenInfo_Fast, {BackgroundColor3 = DarkenColor(BACKGROUND_COLOR, 0.05)}):Play()
            end
            
            -- Select this page
            pageContainer.Visible = true
            tabSelection.Visible = true
            TweenService:Create(tabButton, TweenInfo_Fast, {BackgroundColor3 = ACCENT_COLOR}):Play()
            
            windowObj.CurrentPage = pageObj
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if windowObj.CurrentPage ~= pageObj then
                TweenService:Create(tabButton, TweenInfo_Fast, {BackgroundColor3 = LightenColor(BACKGROUND_COLOR, 0.03)}):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if windowObj.CurrentPage ~= pageObj then
                TweenService:Create(tabButton, TweenInfo_Fast, {BackgroundColor3 = DarkenColor(BACKGROUND_COLOR, 0.05)}):Play()
            end
        end)
        
        -- Store the page object
        pageObj.Button = tabButton
        table.insert(windowObj.Pages, pageObj)
        
        -- Select first page automatically
        if #windowObj.Pages == 1 then
            tabButton.MouseButton1Click:Fire()
        end
        
        return pageObj
    end
    
    -- Hide loading screen and show UI
    spawn(function()
        wait(1) -- Simulate loading time
        loadingTween:Cancel()
        TweenService:Create(loadingFill, TweenInfo_Default, {Size = UDim2.new(1, 0, 1, 0)}):Play()
        wait(0.3)
        loadingText.Text = "Ready!"
        wait(0.5)
        TweenService:Create(loadingFrame, TweenInfo_Default, {BackgroundTransparency = 1}):Play()
        TweenService:Create(loadingContainer, TweenInfo_Default, {Position = UDim2.new(0.5, 0, 0.6, 0), BackgroundTransparency = 1}):Play()
        wait(ANIMATION_SPEED)
        loadingFrame:Destroy()
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo_Default, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    end)
    
    return windowObj
end

return NeoUI
