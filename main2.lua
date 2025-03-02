colorContainer.Size = UDim2.new(1, 0, 0, 70 + 240)
                pickerPanel.Size = UDim2.new(1, -20, 0, 230)
                pickerPanel.Visible = true
                
                -- Reset to last valid color when opening
                InitializePicker()
            else
                Tween(colorContainer, {Size = UDim2.new(1, 0, 0, 70)}, 0.3)
                
                -- Hide panel after animation
                spawn(function()
                    wait(0.3)
                    if not isOpen then
                        pickerPanel.Visible = false
                        pickerPanel.Size = UDim2.new(1, -20, 0, 0)
                    end
                end)
            end
        end
        
        colorButton.MouseButton1Click:Connect(function()
            TogglePicker()
            CreateRipple(colorButton)
        end)
        
        colorButton.MouseEnter:Connect(function()
            Tween(colorButton, {Size = UDim2.fromOffset(44, 44)}, 0.2)
        end)
        
        colorButton.MouseLeave:Connect(function()
            Tween(colorButton, {Size = UDim2.fromOffset(40, 40)}, 0.2)
        end)
        
        -- Hue slider interaction
        hueSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local hue = UpdateHue(input.Position.X)
                
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    hue = UpdateHue(Mouse.X)
                end)
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if connection then connection:Disconnect() end
                    end
                end)
            end
        end)
        
        -- Color space interaction
        colorSpace.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local s, v = UpdateColorSpace(input.Position.X, input.Position.Y)
                
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    s, v = UpdateColorSpace(Mouse.X, Mouse.Y)
                end)
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        if connection then connection:Disconnect() end
                    end
                end)
            end
        end)
        
        -- Button interactions
        confirmButton.MouseEnter:Connect(function()
            Tween(confirmButton, {BackgroundTransparency = 0.2}, 0.2)
        end)
        
        confirmButton.MouseLeave:Connect(function()
            Tween(confirmButton, {BackgroundTransparency = 0}, 0.2)
        end)
        
        confirmButton.MouseButton1Click:Connect(function()
            CreateRipple(confirmButton)
            lastValidColor = selectedColor
            colorButton.BackgroundColor3 = selectedColor
            UpdateRGBText(selectedColor)
            TogglePicker()
            
            if callback then
                callback(selectedColor)
            end
        end)
        
        cancelButton.MouseEnter:Connect(function()
            Tween(cancelButton, {BackgroundTransparency = 0.2}, 0.2)
        end)
        
        cancelButton.MouseLeave:Connect(function()
            Tween(cancelButton, {BackgroundTransparency = 0}, 0.2)
        end)
        
        cancelButton.MouseButton1Click:Connect(function()
            CreateRipple(cancelButton)
            selectedColor = lastValidColor
            colorButton.BackgroundColor3 = lastValidColor
            UpdateRGBText(lastValidColor)
            TogglePicker()
        end)
        
        local colorPickerObj = {
            Container = colorContainer,
            Color = selectedColor,
            SetColor = function(color)
                selectedColor = color
                lastValidColor = color
                colorButton.BackgroundColor3 = color
                UpdateRGBText(color)
                currentH, currentS, currentV = RGBtoHSV(color)
                
                if isOpen then
                    -- Update UI elements
                    hueDragger.Position = UDim2.new(currentH, 0, 0.5, 0)
                    colorSpace.BackgroundColor3 = HSVtoRGB(currentH, 1, 1)
                    colorDragger.Position = UDim2.new(currentS, 0, 1 - currentV, 0)
                end
                
                if callback then
                    callback(color)
                end
            end,
            GetColor = function()
                return selectedColor
            end
        }
        
        return colorPickerObj
    end
    
    function windowObj:AddLabel(text, textSize, textColor)
        local label = Instance.new("TextLabel")
        label.Name = "Label_" .. text:sub(1, 20)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Font = FONT.REGULAR
        label.TextColor3 = textColor or COLORS.TEXT_PRIMARY
        label.TextSize = textSize or 16
        label.TextWrapped = true
        label.Text = text
        label.Parent = contentContainer
        
        local labelObj = {
            Label = label,
            SetText = function(newText)
                label.Text = newText
            end
        }
        
        return labelObj
    end
    
    function windowObj:AddHeading(text, textSize)
        local heading = Instance.new("TextLabel")
        heading.Name = "Heading_" .. text:sub(1, 20)
        heading.BackgroundTransparency = 1
        heading.Size = UDim2.new(1, 0, 0, 35)
        heading.Font = FONT.TITLE
        heading.TextColor3 = COLORS.PRIMARY
        heading.TextSize = textSize or 22
        heading.TextXAlignment = Enum.TextXAlignment.Left
        heading.TextWrapped = true
        heading.Text = text
        heading.Parent = contentContainer
        
        local headingObj = {
            Heading = heading,
            SetText = function(newText)
                heading.Text = newText
            end
        }
        
        return headingObj
    end
    
    function windowObj:AddDivider(padding)
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.BackgroundColor3 = COLORS.PRIMARY
        divider.BorderSizePixel = 0
        divider.Size = UDim2.new(1, 0, 0, 1)
        divider.Parent = contentContainer
        
        if padding then
            local paddingContainer = Instance.new("Frame")
            paddingContainer.Name = "DividerPadding"
            paddingContainer.BackgroundTransparency = 1
            paddingContainer.Size = UDim2.new(1, 0, 0, padding + 1)
            paddingContainer.Parent = contentContainer
            
            divider.Parent = paddingContainer
            divider.Position = UDim2.new(0, 0, 0.5, 0)
            divider.AnchorPoint = Vector2.new(0, 0.5)
            
            return paddingContainer
        end
        
        return divider
    end
    
    function windowObj:AddNotification(title, message, notificationType, duration)
        notificationType = notificationType or "info"
        duration = duration or 5
        
        -- Create notification container
        local notification = Instance.new("Frame")
        notification.Name = "Notification"
        notification.BackgroundColor3 = COLORS.CARD
        notification.BorderSizePixel = 0
        notification.Position = UDim2.new(1, 350, 1, -100)
        notification.Size = UDim2.new(0, 300, 0, 80)
        notification.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = notification
        
        local shadow = CreateShadow(notification, UDim2.new(1, 40, 1, 40))
        shadow.ImageTransparency = 0.5
        
        -- Type-specific color and icon
        local typeColor, typeIcon
        if notificationType == "success" then
            typeColor = COLORS.SUCCESS
            typeIcon = Icons.Success
        elseif notificationType == "warning" then
            typeColor = COLORS.WARNING
            typeIcon = Icons.Warning
        elseif notificationType == "error" then
            typeColor = COLORS.ERROR
            typeIcon = Icons.Close
        else
            typeColor = COLORS.PRIMARY
            typeIcon = Icons.Info
        end
        
        -- Accent bar
        local accentBar = Instance.new("Frame")
        accentBar.Name = "AccentBar"
        accentBar.BackgroundColor3 = typeColor
        accentBar.BorderSizePixel = 0
        accentBar.Position = UDim2.new(0, 0, 0, 0)
        accentBar.Size = UDim2.new(0, 4, 1, 0)
        accentBar.Parent = notification
        
        local accentCorner = Instance.new("UICorner")
        accentCorner.CornerRadius = UDim.new(0, 8)
        accentCorner.Parent = accentBar
        
        -- Icon
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0, 15, 0, 15)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Image = typeIcon
        icon.ImageColor3 = typeColor
        icon.Parent = notification
        
        -- Title
        local notificationTitle = Instance.new("TextLabel")
        notificationTitle.Name = "Title"
        notificationTitle.BackgroundTransparency = 1
        notificationTitle.Position = UDim2.new(0, 45, 0, 10)
        notificationTitle.Size = UDim2.new(1, -55, 0, 20)
        notificationTitle.Font = FONT.SUBTITLE
        notificationTitle.TextColor3 = COLORS.TEXT_PRIMARY
        notificationTitle.TextSize = 16
        notificationTitle.TextXAlignment = Enum.TextXAlignment.Left
        notificationTitle.Text = title
        notificationTitle.Parent = notification
        
        -- Message
        local notificationMessage = Instance.new("TextLabel")
        notificationMessage.Name = "Message"
        notificationMessage.BackgroundTransparency = 1
        notificationMessage.Position = UDim2.new(0, 45, 0, 35)
        notificationMessage.Size = UDim2.new(1, -55, 0, 35)
        notificationMessage.Font = FONT.REGULAR
        notificationMessage.TextColor3 = COLORS.TEXT_SECONDARY
        notificationMessage.TextSize = 14
        notificationMessage.TextXAlignment = Enum.TextXAlignment.Left
        notificationMessage.TextYAlignment = Enum.TextYAlignment.Top
        notificationMessage.TextWrapped = true
        notificationMessage.Text = message
        notificationMessage.Parent = notification
        
        -- Close button
        local closeButton = Instance.new("ImageButton")
        closeButton.Name = "CloseButton"
        closeButton.BackgroundTransparency = 1
        closeButton.Position = UDim2.new(1, -25, 0, 10)
        closeButton.Size = UDim2.new(0, 15, 0, 15)
        closeButton.Image = Icons.Close
        closeButton.ImageColor3 = COLORS.TEXT_SECONDARY
        closeButton.Parent = notification
        
        -- Progress bar
        local progressBar = Instance.new("Frame")
        progressBar.Name = "ProgressBar"
        progressBar.BackgroundColor3 = typeColor
        progressBar.BorderSizePixel = 0
        progressBar.Position = UDim2.new(0, 0, 1, -2)
        progressBar.Size = UDim2.new(1, 0, 0, 2)
        progressBar.Parent = notification
        
        local progressCorner = Instance.new("UICorner")
        progressCorner.CornerRadius = UDim.new(0, 2)
        progressCorner.Parent = progressBar
        
        -- Slide in animation
        Tween(notification, {Position = UDim2.new(1, -320, 1, -100)}, 0.5, EASING.BACK)
        
        -- Progress bar animation
        Tween(progressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)
        
        -- Close button functionality
        closeButton.MouseButton1Click:Connect(function()
            CreateRipple(closeButton)
            Tween(notification, {Position = UDim2.new(1, 350, 1, -100)}, 0.5, EASING.BACK, Enum.EasingDirection.In)
            spawn(function()
                wait(0.6)
                notification:Destroy()
            end)
        end)
        
        -- Auto close after duration
        spawn(function()
            wait(duration)
            if notification and notification.Parent then
                Tween(notification, {Position = UDim2.new(1, 350, 1, -100)}, 0.5, EASING.BACK, Enum.EasingDirection.In)
                wait(0.6)
                if notification and notification.Parent then
                    notification:Destroy()
                end
            end
        end)
        
        return notification
    end
    
    function windowObj:AddTabSystem()
        local tabContainer = Instance.new("Frame")
        tabContainer.Name = "TabContainer"
        tabContainer.BackgroundColor3 = COLORS.CARD
        tabContainer.Size = UDim2.new(1, 0, 1, 0)
        tabContainer.Parent = contentContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = tabContainer
        
        local tabHeader = Instance.new("Frame")
        tabHeader.Name = "TabHeader"
        tabHeader.BackgroundColor3 = COLORS.PRIMARY
        tabHeader.Size = UDim2.new(1, 0, 0, 36)
        tabHeader.Parent = tabContainer
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 8)
        headerCorner.Parent = tabHeader
        
        local headerBottomFrame = Instance.new("Frame")
        headerBottomFrame.Name = "HeaderBottom"
        headerBottomFrame.BackgroundColor3 = COLORS.PRIMARY
        headerBottomFrame.BorderSizePixel = 0
        headerBottomFrame.Position = UDim2.new(0, 0, 1, -8)
        headerBottomFrame.Size = UDim2.new(1, 0, 0, 8)
        headerBottomFrame.Parent = tabHeader
        
        local tabButtons = Instance.new("ScrollingFrame")
        tabButtons.Name = "TabButtons"
        tabButtons.BackgroundTransparency = 1
        tabButtons.BorderSizePixel = 0
        tabButtons.Size = UDim2.new(1, 0, 1, 0)
        tabButtons.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabButtons.ScrollBarThickness = 0
        tabButtons.Parent = tabHeader
        
        local buttonLayout = Instance.new("UIListLayout")
        buttonLayout.FillDirection = Enum.FillDirection.Horizontal
        buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
        buttonLayout.Padding = UDim.new(0, 5)
        buttonLayout.Parent = tabButtons
        
        local buttonPadding = Instance.new("UIPadding")
        buttonPadding.PaddingLeft = UDim.new(0, 10)
        buttonPadding.PaddingRight = UDim.new(0, 10)
        buttonPadding.Parent = tabButtons
        
        local tabPages = Instance.new("Frame")
        tabPages.Name = "TabPages"
        tabPages.BackgroundTransparency = 1
        tabPages.Position = UDim2.new(0, 0, 0, 36)
        tabPages.Size = UDim2.new(1, 0, 1, -36)
        tabPages.Parent = tabContainer
        
        local activePage = nil
        local activeButton = nil
        local tabs = {}
        
        -- Tab system methods
        local tabSystem = {
            Container = tabContainer,
            Tabs = tabs
        }
        
        function tabSystem:AddTab(title, icon)
            -- Create tab button
            local tabButton = Instance.new("TextButton")
            tabButton.Name = "Tab_" .. title
            tabButton.BackgroundTransparency = 1
            tabButton.Size = UDim2.new(0, 100, 1, 0)
            tabButton.Font = FONT.REGULAR
            tabButton.TextColor3 = COLORS.TEXT_PRIMARY
            tabButton.TextSize = 14
            tabButton.Text = ""
            tabButton.LayoutOrder = #tabs + 1
            tabButton.Parent = tabButtons
            
            local tabTitle = Instance.new("TextLabel")
            tabTitle.Name = "Title"
            tabTitle.BackgroundTransparency = 1
            tabTitle.Position = icon and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 0, 0, 0)
            tabTitle.Size = icon and UDim2.new(1, -30, 1, 0) or UDim2.new(1, 0, 1, 0)
            tabTitle.Font = FONT.REGULAR
            tabTitle.TextColor3 = COLORS.TEXT_PRIMARY
            tabTitle.TextSize = 14
            tabTitle.Text = title
            tabTitle.Parent = tabButton
            
            if icon then
                local tabIcon = Instance.new("ImageLabel")
                tabIcon.Name = "Icon"
                tabIcon.BackgroundTransparency = 1
                tabIcon.Position = UDim2.new(0, 5, 0.5, 0)
                tabIcon.AnchorPoint = Vector2.new(0, 0.5)
                tabIcon.Size = UDim2.new(0, 20, 0, 20)
                tabIcon.Image = icon
                tabIcon.Parent = tabButton
            end
            
            local selectionIndicator = Instance.new("Frame")
            selectionIndicator.Name = "SelectionIndicator"
            selectionIndicator.BackgroundColor3 = COLORS.ACCENT
            selectionIndicator.BorderSizePixel = 0
            selectionIndicator.Position = UDim2.new(0, 0, 1, -2)
            selectionIndicator.Size = UDim2.new(1, 0, 0, 2)
            selectionIndicator.Visible = false
            selectionIndicator.Parent = tabButton
            
            -- Create tab page
            local tabPage = Instance.new("ScrollingFrame")
            tabPage.Name = "Page_" .. title
            tabPage.BackgroundTransparency = 1
            tabPage.BorderSizePixel = 0
            tabPage.Size = UDim2.new(1, 0, 1, 0)
            tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabPage.ScrollBarThickness = 4
            tabPage.ScrollingDirection = Enum.ScrollingDirection.Y
            tabPage.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
            tabPage.ScrollBarImageColor3 = COLORS.PRIMARY
            tabPage.Visible = false
            tabPage.Parent = tabPages
            
            local pageLayout = Instance.new("UIListLayout")
            pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            pageLayout.Padding = UDim.new(0, 10)
            pageLayout.Parent = tabPage
            
            local pagePadding = Instance.new("UIPadding")
            pagePadding.PaddingLeft = UDim.new(0, 10)
            pagePadding.PaddingRight = UDim.new(0, 10)
            pagePadding.PaddingTop = UDim.new(0, 10)
            pagePadding.PaddingBottom = UDim.new(0, 10)
            pagePadding.Parent = tabPage
            
            -- Update canvas size when elements are added
            pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
            end)
            
            -- Handle tab selection
            tabButton.MouseButton1Click:Connect(function()
                CreateRipple(tabButton)
                
                -- Deselect current tab
                if activeButton then
                    Tween(activeButton, {BackgroundTransparency = 1}, 0.3)
                    activeButton.SelectionIndicator.Visible = false
                end
                
                if activePage then
                    activePage.Visible = false
                end
                
                -- Select new tab
                activeButton = tabButton
                activePage = tabPage
                
                Tween(activeButton, {BackgroundTransparency = 0.8}, 0.3)
                activeButton.SelectionIndicator.Visible = true
                activePage.Visible = true
            end)
            
            -- Hover effects
            tabButton.MouseEnter:Connect(function()
                if tabButton ~= activeButton then
                    Tween(tabButton, {BackgroundTransparency = 0.9}, 0.3)
                end
            end)
            
            tabButton.MouseLeave:Connect(function()
                if tabButton ~= activeButton then
                    Tween(tabButton, {BackgroundTransparency = 1}, 0.3)
                end
            end)
            
            -- Tab object
            local tab = {
                Button = tabButton,
                Page = tabPage,
                Title = title,
                Select = function()
                    tabButton.MouseButton1Click:Fire()
                end
            }
            
            -- Methods to add elements to the tab
            for method, func in pairs(windowObj) do
                if method:sub(1, 3) == "Add" and method ~= "AddTabSystem" and method ~= "AddNotification" then
                    tab[method] = function(_, ...)
                        return func(tab, ...)
                    end
                end
            end
            
            tab.AddButton = function(_, text, callback)
                local button = windowObj:AddButton(text, callback)
                button.Parent = tabPage
                return button
            end
            
            tab.AddSlider = function(_, text, min, max, default, callback)
                local slider = windowObj:AddSlider(text, min, max, default, callback)
                slider.Container.Parent = tabPage
                return slider
            end
            
            tab.AddToggle = function(_, text, default, callback)
                local toggle = windowObj:AddToggle(text, default, callback)
                toggle.Container.Parent = tabPage
                return toggle
            end
            
            tab.AddTextbox = function(_, text, placeholder, callback)
                local textbox = windowObj:AddTextbox(text, placeholder, callback)
                textbox.Container.Parent = tabPage
                return textbox
            end
            
            tab.AddDropdown = function(_, text, options, default, callback)
                local dropdown = windowObj:AddDropdown(text, options, default, callback)
                dropdown.Container.Parent = tabPage
                return dropdown
            end
            
            tab.AddColorPicker = function(_, text, default, callback)
                local colorPicker = windowObj:AddColorPicker(text, default, callback)
                colorPicker.Container.Parent = tabPage
                return colorPicker
            end
            
            tab.AddLabel = function(_, text, textSize, textColor)
                local label = windowObj:AddLabel(text, textSize, textColor)
                label.Parent = tabPage
                return label
            end
            
            tab.AddHeading = function(_, text, textSize)
                local heading = windowObj:AddHeading(text, textSize)
                heading.Parent = tabPage
                return heading
            end
            
            tab.AddDivider = function(_, padding)
                local divider = windowObj:AddDivider(padding)
                divider.Parent = tabPage
                return divider
            end
            
            -- Add tab to tabs list
            table.insert(tabs, tab)
            
            -- Set as active if it's the first tab
            if #tabs == 1 then
                tab.Select()
            end
            
            return tab
        end
        
        return tabSystem
    end
    
    function windowObj:SetTheme(theme)
        if type(theme) ~= "table" then return end
        
        -- Update color constants with new theme
        for key, value in pairs(theme) do
            if COLORS[key] then
                COLORS[key] = value
            end
        end
        
        -- Update existing UI elements
        -- This is just a basic implementation - you'd need to update all elements
        window.BackgroundColor3 = COLORS.BACKGROUND
        titleBar.BackgroundColor3 = COLORS.PRIMARY
        titleBottomFrame.BackgroundColor3 = COLORS.PRIMARY
    end
    
    return windowObj
end

-- Developer's Notes & References:
-- BangersUI was developed to provide a clean, modern UI solution for Roblox development
-- Includes all essential UI components with smooth animations and a consistent design language
-- Feel free to customize colors, styles, and components to fit your game's aesthetic
-- For questions or support, visit the documentation or contact the developer

-- Return the library
return BangersUI
