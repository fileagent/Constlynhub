local Library = {}

local NeverloseVersion = "v1.1A."

local TweenService = game:GetService("TweenService")
local input = game:GetService("UserInputService")

for i,v in next, game.CoreGui:GetChildren() do
    if v:IsA("ScreenGui") and v.Name == "Neverlose" then
        v:Destroy() 
    end
end

local themouse = game.Players.LocalPlayer:GetMouse()

local function Notify(tt, tx)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = tt,
        Text = tx,
        Duration = 5
    })
end

local function Dragify(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X / 2, framePos.Y.Scale, framePos.Y.Offset + delta.Y / 2)
        end
    end)
end

local function round(num, bracket)
    bracket = bracket or 1
    local a = math.floor(num / bracket + (math.sign(num) * 0.5)) * bracket
    if a < 0 then
        a = a + bracket
    end
    return a
end

local function ScaleUI(element)
    element.Size = UDim2.new(element.Size.X.Scale / 2, element.Size.X.Offset / 2, element.Size.Y.Scale / 2, element.Size.Y.Offset / 2)
    element.Position = UDim2.new(element.Position.X.Scale, element.Position.X.Offset / 2, element.Position.Y.Scale, element.Position.Y.Offset / 2)
end

function Library:Window(options)
    options.text = options.text or "NEVERLOSE"

    local SG = Instance.new("ScreenGui")
    local Body = Instance.new("Frame")
    local bodyCorner = Instance.new("UICorner")
    
    SG.Parent = game.CoreGui
    SG.Name = "Neverlose"
    
    Body.Name = "Body"
    Body.Parent = SG
    Body.AnchorPoint = Vector2.new(0.5, 0.5)
    Body.BackgroundColor3 = Color3.fromRGB(9, 8, 13)
    Body.BorderSizePixel = 0
    Body.Position = UDim2.new(0.465730786, 0, 0.5, 0)
    Body.Size = UDim2.new(0, 329, 0, 258)
    ScaleUI(Body)
    
    bodyCorner.CornerRadius = UDim.new(0, 2)
    bodyCorner.Name = "bodyCorner"
    bodyCorner.Parent = Body

    local SideBar = Instance.new("Frame")
    local sidebarCorner = Instance.new("UICorner")
    local sbLine = Instance.new("Frame")

    SideBar.Name = "SideBar"
    SideBar.Parent = Body
    SideBar.BackgroundColor3 = Color3.fromRGB(26, 36, 48)
    SideBar.BorderSizePixel = 0
    SideBar.Size = UDim2.new(0, 93, 0, 258)
    ScaleUI(SideBar)
    
    sidebarCorner.CornerRadius = UDim.new(0, 2)
    sidebarCorner.Name = "sidebarCorner"
    sidebarCorner.Parent = SideBar
    
    sbLine.Name = "sbLine"
    sbLine.Parent = SideBar
    sbLine.BackgroundColor3 = Color3.fromRGB(15, 23, 36)
    sbLine.BorderSizePixel = 0
    sbLine.Position = UDim2.new(0.99490571, 0, 0, 0)
    sbLine.Size = UDim2.new(0, 1, 0, 258)
    ScaleUI(sbLine)
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = SideBar
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.061, 0, 0.021, 0)
    Title.Size = UDim2.new(0, 81, 0, 13)
    Title.Font = Enum.Font.ArialBold
    Title.Text = options.text
    Title.TextColor3 = Color3.fromRGB(234, 239, 245)
    Title.TextSize = 14.000
    Title.TextWrapped = true
    ScaleUI(Title)
    
    local allPages = Instance.new("Frame")
    local tabContainer = Instance.new("Frame")

    allPages.Name = "allPages"
    allPages.Parent = Body
    allPages.BackgroundTransparency = 1.000
    allPages.Position = UDim2.new(0.295, 0, 0.100, 0)
    allPages.Size = UDim2.new(0, 232, 0, 232)
    ScaleUI(allPages)
    
    tabContainer.Name = "tabContainer"
    tabContainer.Parent = SideBar
    tabContainer.BackgroundTransparency = 1.000
    tabContainer.Position = UDim2.new(0, 0, 0.100, 0)
    tabContainer.Size = UDim2.new(0, 93, 0, 232)
    ScaleUI(tabContainer)
    
    return Library
end

return Library
