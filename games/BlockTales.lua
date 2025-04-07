local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Neverlose/source.lua"))()
-- Toggle UI: Library:Toggle()
local vim = game:GetService("VirtualInputManager")
local Window = Library:Window({
    text = "Better Than Others"
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
Section:Toggle({
    text = "Auto Dodge Attack(BETA SOMETIME WORK) ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoDodgeAttack = boolean
        
        if getgenv().AutoDodgeAttack then
            coroutine.wrap(function()
                while getgenv().AutoDodgeAttack do
                    task.wait()
                    local player = game:GetService("Players").LocalPlayer
                    local FPlayers = workspace:FindFirstChild("FPlayers")
                    
                    if FPlayers then
                        local character = FPlayers:FindFirstChild(player.Name)
                        
                        if character and character:FindFirstChild("Model") and character.Model:FindFirstChild("HumanoidRootPart") then
                            local rootPart = character.Model.HumanoidRootPart
                            for i, v in pairs(workspace.Enemies:GetChildren()) do
                                if v:FindFirstChild("Model") and v.Model:FindFirstChild("HumanoidRootPart") then
                                    local distance = (rootPart.Position - v.Model.HumanoidRootPart.Position).Magnitude
                                    if distance < 10 and v.Name ~= "Helmet Noob" then
                                    task.wait(0.9)
                --local vim = game:GetService("VirtualInputManager")
                                     vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                     vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                     elseif distance < 10 and v.Name == "Helmet Noob"  then
                                     task.wait(1.3)
                                     vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                     vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end
                                end
                            end
                        end
                    end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Dodge Projectile ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoDodgeProjectile = boolean
        
        if getgenv().AutoDodgeProjectile then
            coroutine.wrap(function()
                while getgenv().AutoDodgeProjectile do
                    task.wait()
                    local player = game:GetService("Players").LocalPlayer
                    local FPlayers = workspace:FindFirstChild("FPlayers")
                    
                    if FPlayers then
                        local character = FPlayers:FindFirstChild(player.Name)
                        
                        if character and character:FindFirstChild("Model") and character.Model:FindFirstChild("HumanoidRootPart") then
                            local rootPart = character.Model.HumanoidRootPart
                            for i, v in pairs(workspace.BattleDump:GetChildren()) do
                                if v:IsA("Part") and v.Name ~= "Superball" then
                                    if (rootPart.Position - v.Position).Magnitude < 7 then
                                        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                    end
                                end
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
