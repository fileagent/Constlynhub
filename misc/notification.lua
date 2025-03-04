-- Create a ModuleScript in ReplicatedStorage called "NotificationSystem"
local NotificationSystem = {}

NotificationSystem.Config = {
    MaxNotifications = 3,
    Duration = 5,
    Spacing = 80,
    StartPosition = UDim2.new(1, -260, 0, 10),
    EndPosition = UDim2.new(1, 10, 0, 10)
}

NotificationSystem.IconType = {
    Success = "9734227106",
    Warning = "9734237606",
    Error = "9734242082",
    Info = "9734232412",
    Coins = "9734247329",
    Achievement = "9734253113"
}

local activeNotifications = {}

function NotificationSystem.Notify(player, title, message, iconType)
    local iconId = NotificationSystem.IconType[iconType] or NotificationSystem.IconType.Info

    local notification = Instance.new("ScreenGui")
    notification.Name = "CustomNotification"
    notification.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 250, 0, 70)
    mainFrame.Position = UDim2.new(1, 0, 0, 10) -- Start off screen
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.Parent = notification
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = mainFrame
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 15, 0, 15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. iconId
    icon.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 170, 0, 25)
    titleLabel.Position = UDim2.new(0, 65, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.Parent = mainFrame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(0, 170, 0, 35)
    messageLabel.Position = UDim2.new(0, 65, 0, 30)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 12
    messageLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Text = message
    messageLabel.Parent = mainFrame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeButton.Text = "×"
    closeButton.Parent = mainFrame

    notification.Parent = player.PlayerGui

    table.insert(activeNotifications, {
        Gui = notification,
        Frame = mainFrame,
        StartTime = os.time()
    })

    if #activeNotifications > NotificationSystem.Config.MaxNotifications then
        local oldest = table.remove(activeNotifications, 1)
        oldest.Frame:TweenPosition(
            NotificationSystem.Config.EndPosition, 
            Enum.EasingDirection.Out, 
            Enum.EasingStyle.Quint, 
            0.5, 
            true
        )
        task.delay(0.5, function()
            oldest.Gui:Destroy()
        end)
    end
    

    for i, notif in ipairs(activeNotifications) do
        local yPos = 10 + (i-1) * NotificationSystem.Config.Spacing
        notif.Frame:TweenPosition(
            UDim2.new(NotificationSystem.Config.StartPosition.X.Scale, 
                      NotificationSystem.Config.StartPosition.X.Offset,
                      0, yPos), 
            Enum.EasingDirection.Out, 
            Enum.EasingStyle.Quint, 
            0.5, 
            true
        )
    end

    closeButton.MouseButton1Click:Connect(function()
        for i, notif in ipairs(activeNotifications) do
            if notif.Gui == notification then
                table.remove(activeNotifications, i)
                break
            end
        end
        
        mainFrame:TweenPosition(
            NotificationSystem.Config.EndPosition, 
            Enum.EasingDirection.Out, 
            Enum.EasingStyle.Quint, 
            0.5, 
            true
        )
        task.delay(0.5, function()
            notification:Destroy()
        end)
        task.delay(0.1, function()
            for i, notif in ipairs(activeNotifications) do
                local yPos = 10 + (i-1) * NotificationSystem.Config.Spacing
                notif.Frame:TweenPosition(
                    UDim2.new(NotificationSystem.Config.StartPosition.X.Scale, 
                          NotificationSystem.Config.StartPosition.X.Offset,
                          0, yPos), 
                    Enum.EasingDirection.Out, 
                    Enum.EasingStyle.Quint, 
                    0.5, 
                    true
                )
            end
        end)
    end)
    task.delay(NotificationSystem.Config.Duration, function()
        for i, notif in ipairs(activeNotifications) do
            if notif.Gui == notification then
                table.remove(activeNotifications, i)
                break
            end
        end
        
        mainFrame:TweenPosition(
            NotificationSystem.Config.EndPosition, 
            Enum.EasingDirection.Out, 
            Enum.EasingStyle.Quint, 
            0.5, 
            true
        )
        task.delay(0.5, function()
            notification:Destroy()
        end)
        
       
        task.delay(0.1, function()
            for i, notif in ipairs(activeNotifications) do
                local yPos = 10 + (i-1) * NotificationSystem.Config.Spacing
                notif.Frame:TweenPosition(
                    UDim2.new(NotificationSystem.Config.StartPosition.X.Scale, 
                          NotificationSystem.Config.StartPosition.X.Offset,
                          0, yPos), 
                    Enum.EasingDirection.Out, 
                    Enum.EasingStyle.Quint, 
                    0.5, 
                    true
                )
            end
        end)
    end)
    
    return notification
end

return NotificationSystem
