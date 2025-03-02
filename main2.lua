--[[
    Nebula UI Library - Simplified Version
    A lightweight UI library for Roblox
]]

local Nebula = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Utility Functions
local Utility = {}

function Utility:Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

function Utility:Tween(instance, properties, duration, style, direction, callback)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, style, direction),
        properties
    )
    
    tween:Play()
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    return tween
end

function Utility:DraggableFrame(frame, dragArea)
    local dragging, dragInput, dragStart, startPos
    
    dragArea = dragArea or frame
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
end

function Utility:Ripple(parent, startPosition)
    local ripple = Utility:Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        Position = UDim2.new(0, startPosition.X - parent.AbsolutePosition.X, 0, startPosition.Y - parent.AbsolutePosition.Y),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = parent,
        BorderSizePixel = 0
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    
    Utility:Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
        ripple:Destroy()
    end)
end

-- Core Configuration
Nebula.Config = {
    WindowCount = 0,
    DefaultTheme = {
        BackgroundColor = Color3.fromRGB(25, 25, 35),
        SidebarColor = Color3.fromRGB(30, 30, 45),
        ContentColor = Color3.fromRGB(35, 35, 50),
        AccentColor = Color3.fromRGB(114, 137, 218), -- Discord Blurple
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(45, 45, 65),
        ElementBorderColor = Color3.fromRGB(50, 50, 70),
        InactiveColor = Color3.fromRGB(160, 160, 180),
        HighlightColor = Color3.fromRGB(130, 150, 230)
    },
    Font = Enum.Font.GothamMedium
}

-- Main Library Functions
function Nebula:New(options)
    options = options or {}
    local windowName = options.Name or "Nebula UI"
    local theme = options.Theme or self.Config.DefaultTheme
    
    -- Initialize library instance
    local libraryInstance = setmetatable({}, {__index = self})
    libraryInstance.WindowId = self.Config.WindowCount + 1
    self.Config.WindowCount = self.Config.WindowCount + 1
    libraryInstance.Pages = {}
    libraryInstance.Theme = theme
    libraryInstance.Flags = {}
    libraryInstance.WindowToggled = true
    
    -- Key bind configuration
    libraryInstance.Keybind = options.Keybind or "RightShift"
    
    -- Create main GUI
    libraryInstance.ScreenGui = Utility:Create("ScreenGui", {
        Name = "NebulaUI_" .. windowName:gsub(" ", "_"),
        Parent = game:GetService("CoreGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Create main window
    libraryInstance.MainWindow = Utility:Create("Frame", {
        Name = "MainWindow",
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = theme.BackgroundColor,
        BorderSizePixel = 0,
        Parent = libraryInstance.ScreenGui
    })
    
    -- Add UI Corner
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = libraryInstance.MainWindow
    })
    
    -- Create titlebar
    libraryInstance.TitleBar = Utility:Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.SidebarColor,
        BorderSizePixel = 0,
        Parent = libraryInstance.MainWindow
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = libraryInstance.TitleBar
    })
    
    -- Only round the top corners
    Utility:Create("Frame", {
        Name = "TitleBarBottomCover",
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = theme.SidebarColor,
        BorderSizePixel = 0,
        Parent = libraryInstance.TitleBar
    })
    
    -- Title text
    libraryInstance.Title = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = theme.TextColor,
        TextSize = 18,
        Font = self.Config.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = libraryInstance.TitleBar
    })
    
    -- Close button
    libraryInstance.CloseButton = Utility:Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundTransparency = 1,
        Text = "✕",
        TextColor3 = theme.TextColor,
        TextSize = 18,
        Font = self.Config.Font,
        Parent = libraryInstance.TitleBar
    })
    
    -- Minimize button
    libraryInstance.MinimizeButton = Utility:Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -65, 0, 5),
        BackgroundTransparency = 1,
        Text = "−",
        TextColor3 = theme.TextColor,
        TextSize = 24,
        Font = self.Config.Font,
        Parent = libraryInstance.TitleBar
    })
    
    -- Create sidebar
    libraryInstance.Sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = theme.SidebarColor,
        BorderSizePixel = 0,
        Parent = libraryInstance.MainWindow
    })
    
    -- Create content area
    libraryInstance.ContentArea = Utility:Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -140, 1, -40),
        Position = UDim2.new(0, 140, 0, 40),
        BackgroundColor3 = theme.ContentColor,
        BorderSizePixel = 0,
        Parent = libraryInstance.MainWindow
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = libraryInstance.ContentArea
    })
    
    -- Only round the right corners
    Utility:Create("Frame", {
        Name = "ContentAreaLeftCover",
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.ContentColor,
        BorderSizePixel = 0,
        Parent = libraryInstance.ContentArea
    })
    
    -- Create tab container
    libraryInstance.TabContainer = Utility:Create("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = libraryInstance.Sidebar
    })
    
    Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = libraryInstance.TabContainer
    })
    
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = libraryInstance.TabContainer
    })
    
    -- Make window draggable
    Utility:DraggableFrame(libraryInstance.MainWindow, libraryInstance.TitleBar)
    
    -- Handle close button
    libraryInstance.CloseButton.MouseButton1Click:Connect(function()
        libraryInstance:Destroy()
    end)
    
    -- Handle minimize button
    libraryInstance.MinimizeButton.MouseButton1Click:Connect(function()
        libraryInstance:Toggle()
    end)
    
    -- Toggle keybind functionality
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.KeyCode == Enum.KeyCode[libraryInstance.Keybind] then
            libraryInstance:Toggle()
        end
    end)
    
    return libraryInstance
end

function Nebula:Toggle(forcedState)
    if forcedState ~= nil then
        self.WindowToggled = forcedState
    else
        self.WindowToggled = not self.WindowToggled
    end
    
    if self.WindowToggled then
        Utility:Tween(self.MainWindow, {
            Size = UDim2.new(0, 600, 0, 400),
            Position = UDim2.new(0.5, -300, 0.5, -200)
        }, 0.3)
    else
        Utility:Tween(self.MainWindow, {
            Size = UDim2.new(0, 600, 0, 40),
            Position = UDim2.new(0.5, -300, 0.5, -20)
        }, 0.3)
    end
end

function Nebula:Destroy()
    Utility:Tween(self.MainWindow, {
        Size = UDim2.new(0, 600, 0, 0),
        Position = UDim2.new(0.5, -300, 0.5, 0)
    }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, function()
        self.ScreenGui:Destroy()
    end)
end

function Nebula:AddPage(title, icon)
    local pageIndex = #self.Pages + 1
    
    -- Create tab button in sidebar
    local tabButton = Utility:Create("TextButton", {
        Name = "Tab_" .. title,
        Size = UDim2.new(1, -20, 0, 36),
        Position = UDim2.new(0, 10, 0, 10 + (pageIndex - 1) * 41),
        BackgroundColor3 = self.Theme.ElementColor,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = self.TabContainer
    })
    
    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = tabButton
    })
    
    local tabLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, icon and -40 or -20, 1, 0),
        Position = UDim2.new(0, icon and 35 or 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextSize = 14,
        Font = self.Config.Font,
        TextColor3 = self.Theme.TextColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tabButton
    })
    
    if icon then
        Utility:Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 10, 0.5, -10),
            BackgroundTransparency = 1,
            Image = icon,
            Parent = tabButton
        })
    end
    
    -- Create page container
    local pageContainer = Utility:Create("ScrollingFrame", {
        Name = "Page_" .. title,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = self.Theme.AccentColor,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = pageIndex == 1,
        Parent = self.ContentArea
    })
    
    Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 15),
        Parent = pageContainer
    })
    
    Utility:Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10),
        Parent = pageContainer
    })
    
    -- Tab button functionality
    tabButton.MouseButton1Click:Connect(function()
        -- Hide all pages
        for _, page in ipairs(self.Pages) do
            page.Container.Visible = false
            Utility:Tween(page.Button, {
                BackgroundColor3 = self.Theme.ElementColor
            }, 0.2)
        end
        
        -- Show current page
        pageContainer.Visible = true
        Utility:Tween(tabButton, {
            BackgroundColor3 = self.Theme.AccentColor
        }, 0.2)
    end)
    
    -- Set active if this is the first page
    if pageIndex == 1 then
        Utility:Tween(tabButton, {
            BackgroundColor3 = self.Theme.AccentColor
        }, 0.2)
    end
    
    -- Create page object
    local page = {
        Button = tabButton,
        Container = pageContainer,
        Sections = {},
        Parent = self
    }
    
    -- Add section method
    function page:AddSection(title)
        local sectionFrame = Utility:Create("Frame", {
            Name = "Section_" .. title,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = self.Parent.Theme.ElementColor,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = self.Container
        })
        
        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = sectionFrame
        })
        
        Utility:Create("TextLabel", {
            Name = "SectionTitle",
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextSize = 16,
            Font = Nebula.Config.Font,
            TextColor3 = self.Parent.Theme.TextColor,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sectionFrame
        })
        
        Utility:Create("Frame", {
            Name = "Divider",
            Size = UDim2.new(1, -20, 0, 1),
            Position = UDim2.new(0, 10, 0, 30),
            BackgroundColor3 = self.Parent.Theme.AccentColor,
            BorderSizePixel = 0,
            Transparency = 0.7,
            Parent = sectionFrame
        })
        
        local sectionContent = Utility:Create("Frame", {
            Name = "Content",
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.new(0, 10, 0, 40),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = sectionFrame
        })
        
        Utility:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = sectionContent
        })
        
        local section = {
            Frame = sectionFrame,
            Container = sectionContent,
            Parent = self
        }
        
        -- Add UI element methods to section
        function section:AddButton(text, callback)
            callback = callback or function() end
            
            local button = Utility:Create("TextButton", {
                Name = "Button_" .. text,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = self.Parent.Parent.Theme.ElementColor,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = self.Container
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = button
            })
            
            Utility:Create("TextLabel", {
                Name = "ButtonText",
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextSize = 14,
                Font = Nebula.Config.Font,
                TextColor3 = self.Parent.Parent.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = button
            })
            
            -- Button effects
            button.MouseEnter:Connect(function()
                Utility:Tween(button, {
                    BackgroundColor3 = self.Parent.Parent.Theme.HighlightColor
                }, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Utility:Tween(button, {
                    BackgroundColor3 = self.Parent.Parent.Theme.ElementColor
                }, 0.2)
            end)
            
            button.MouseButton1Down:Connect(function()
                Utility:Tween(button, {
                    BackgroundColor3 = self.Parent.Parent.Theme.AccentColor
                }, 0.1)
            end)
            
            button.MouseButton1Up:Connect(function()
                Utility:Tween(button, {
                    BackgroundColor3 = self.Parent.Parent.Theme.HighlightColor
                }, 0.1)
            end)
            
            button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            return button
        end
        
        function section:AddToggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            
            local toggle = Utility:Create("Frame", {
                Name = "Toggle_" .. text,
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Parent = self.Container
            })
            
            local toggleButton = Utility:Create("Frame", {
                Name = "ToggleButton",
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(0, 0, 0.5, -12),
                BackgroundColor3 = default and self.Parent.Parent.Theme.AccentColor or self.Parent.Parent.Theme.ElementColor,
                BorderSizePixel = 0,
                Parent = toggle
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = toggleButton
            })
            
            Utility:Create("TextLabel", {
                Name = "ToggleText",
                Size = UDim2.new(1, -34, 1, 0),
                Position = UDim2.new(0, 34, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextSize = 14,
                Font = Nebula.Config.Font,
                TextColor3 = self.Parent.Parent.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = toggle
            })
            
            local toggled = default
            
            local function updateToggle()
                Utility:Tween(toggleButton, {
                    BackgroundColor3 = toggled and self.Parent.Parent.Theme.AccentColor or self.Parent.Parent.Theme.ElementColor
                }, 0.2)
                callback(toggled)
            end
            
            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    toggled = not toggled
                    updateToggle()
                end
            end)
            
            return toggle
        end
        
        function section:AddSlider(text, config, callback)
            config = config or {}
            config.min = config.min or 0
            config.max = config.max or 100
            config.default = config.default or config.min
            callback = callback or function() end
            
            local slider = Utility:Create("Frame", {
                Name = "Slider_" .. text,
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1,
                Parent = self.Container
            })
            
            Utility:Create("TextLabel", {
                Name = "SliderText",
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextSize = 14,
                Font = Nebula.Config.Font,
                TextColor3 = self.Parent.Parent.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = slider
            })
            
            local sliderBg = Utility:Create("Frame", {
                Name = "SliderBg",
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundColor3 = self.Parent.Parent.Theme.ElementColor,
                BorderSizePixel = 0,
                Parent = slider
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = sliderBg
            })
            
            local sliderFill = Utility:Create("Frame", {
                Name = "SliderFill",
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = self.Parent.Parent.Theme.AccentColor,
                BorderSizePixel = 0,
                Parent = sliderBg
            })
            
            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = sliderFill
            })
            
            local sliderValue = Utility:Create("TextLabel", {
                Name = "SliderValue",
                Size = UDim2.new(1, 0, 0, 15),
                Position = UDim2.new(0, 0, 0, 35),
                BackgroundTransparency = 1,
                Text = tostring(config.default),
                TextSize = 14,
                Font = Nebula.Config.Font,
                TextColor3 = self.Parent.Parent.Theme.TextColor,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = slider
            })
            
            local value = config.default
            local percent = (value - config.min) / (config.max - config.min)
            
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderValue.Text = tostring(value)
            
            local function updateSlider(input)
                local mousePos = input.Position.X
                local relativePos = mousePos - sliderBg.AbsolutePosition.X
                local percent = math.clamp(relativePos / sliderBg.AbsoluteSize.X, 0, 1)
                
                value = config.min + (config.max - config.min) * percent
                if config.increment then
                    value = math.floor(value / config.increment + 0.5) * config.increment
                    percent = (value - config.min) / (config.max - config.min)
                end
                
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                sliderValue.Text = tostring(math.floor(value * 100) / 100)
                callback(value)
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSlider(input)
                    local connection
                    connection = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            updateSlider(input)
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            connection:Disconnect()
                        end
                    end)
                end
            end)
            
            return slider
        end
        
        table.insert(self.Sections, section)
        return section
    end
    
    table.insert(self.Pages, page)
    return page
end

return Nebula
