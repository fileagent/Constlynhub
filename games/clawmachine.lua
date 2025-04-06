local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "Window"
})

local TabSection = Window:TabSection({
    text = "TabSection"
})

local Tab = TabSection:Tab({
    text = "Tab",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "Section"
})

Section:Button({
    text = "Button",
    callback = function()
        print("Clicked button")
    end,
})

Section:Toggle({
    text = "AutoFight Boss",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoFightForBoss = boolean
        
        if getgenv().AutoFightForBoss then
            coroutine.wrap(function()
                while getgenv().AutoFightForBoss do
                game:GetService("RunService").heartbeat:Wait()
for i=1,3 do 
local args = {
    [1] = i,
    [2] = false
}

game:GetService("ReplicatedStorage"):WaitForChild("__remotes"):WaitForChild("BossService"):WaitForChild("AttackConv"):FireServer(unpack(args))
end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "AutoPlushie(Useless)",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoPlushie = boolean
        
        if getgenv().AutoPlushie then
            coroutine.wrap(function()
                while getgenv().AutoPlushie do
                game:GetService("RunService").heartbeat:Wait()

    local CurrentZone = localPlayer:GetAttribute("CurrentZone")
    if not CurrentZone then continue end

    local obstacles = workspace.Obstacles[CurrentZone]:GetChildren()
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then continue end

    local rootPart = character.HumanoidRootPart
    local nearestObstacle = nil
    local minDistance = math.huge

    -- Find the nearest obstacle
    for _, obstacle in pairs(obstacles) do
        if obstacle:FindFirstChild("Root") and obstacle:FindFirstChild("IsAlive") and obstacle.IsAlive.Value then
            local distance = (obstacle.Root.Position - rootPart.Position).Magnitude
            if distance < 100 and distance < minDistance then
                nearestObstacle = obstacle
                minDistance = distance
            end
        end
    end

    -- If a valid nearest obstacle is found, attack it
    if nearestObstacle then
        for _, plush in pairs(localPlayer.PlayerGui.ScreenGui.Gui.Inventory.ScrollingFrame.Frame:GetChildren()) do
            if plush:IsA("Frame") then
                local args1 = {
                    [1] = { [1] = plush:GetAttribute("UID") },
                    [2] = nearestObstacle:GetAttribute("UniqueId")
                }
                obstacleService:WaitForChild("SendPlushesToObstacle"):FireServer(unpack(args1))

                local args2 = {
                    [1] = nearestObstacle:GetAttribute("UniqueId"),
                    [2] = "   "
                }
                obstacleService:WaitForChild("ClawAttackObstacle"):FireServer(unpack(args2))

                -- Collect rewards if available
                local hasRewards = nearestObstacle:FindFirstChild("HasRewards")
                if hasRewards then
                    for _, reward in pairs(hasRewards:GetChildren()) do
                        if reward:IsA("BoolValue") and reward.Value then
                            local args3 = {
                                [1] = nearestObstacle:GetAttribute("UniqueId"),
                                [2] = reward.Name
                            }
                            collectiblesService:WaitForChild("Collect"):FireServer(unpack(args3))
                        end
                    end
                end

                break -- Stop after attacking one obstacle
            end
        end
    end
                end
            end)()
        end
    end
})
Section:Slider({
    text = "Slider",
    min = 10,
    max = 100,
    -- [[Float = 0,]] Idk what it does
    callback = function(number)
        print(number)
    end
})

Section:Dropdown({
    text = "Dropdown",
    list = {"Apple", "Banana","Coconut"},
    default = "Apple",
    callback = function(String)
        print(String)
    end
})

Section:Textbox({
    text = "Textbox",
    value = "Default",
    callback = function(String)
        print(String)
    end
})

Section:Colorpicker({
    text = "Colorpicker",
    color = Color3.new(1,1,1),
    callback = function(HSV)
        print(HSV)
    end
})

--[[
    blacklisted keybind:
        Return
        Space
        Tab
        W,A,S,D,I,O
        Unknown
]]

Section:Keybind({
    text = "Keybind",
    default = Enum.KeyCode.Z,
    callback = function(defaultBind)
        print("Triggered keybind")
        print(defaultBind)
    end
})
