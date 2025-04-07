local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Neverlose/source.lua"))()
-- Toggle UI: Library:Toggle()
local vim = game:GetService("VirtualInputManager")
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
--[[Section:Toggle({
    text = "Auto Dodge Attack (BETA)",
    state = false,
    callback = function(state)
        getgenv().AutoDodgeAttack = state

        if state then
            coroutine.wrap(function()
                local vim = game:GetService("VirtualInputManager")
                local players = game:GetService("Players")
                local player = players.LocalPlayer

                while getgenv().AutoDodgeAttack do
                    task.wait()
                    if game:GetService("Players").LocalPlayer.PlayerGui.HUD.Battle.DOITNOW2.Visible == true then
                    local FPlayers = workspace:FindFirstChild("FPlayers")
                    if not FPlayers then continue end

                    local character = FPlayers:FindFirstChild(player.Name)
                    if not (character and character:FindFirstChild("Model") and character.Model:FindFirstChild("HumanoidRootPart")) then continue end

                    local rootPart = character.Model.HumanoidRootPart

                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        local enemyModel = enemy:FindFirstChild("Model")
                        local enemyRoot = enemyModel and enemyModel:FindFirstChild("HumanoidRootPart")
                        local Shield = enemyModel and enemyModel:FindFirstChild("Shield")

                        if enemyRoot then
                            local distance = (rootPart.Position - enemyRoot.Position).Magnitude

                            if distance < 7 then
                                if enemy.Name == "Helmet Noob" then
                                    task.wait(1.25)
                                elseif  enemy.Name == "Blue Noob" then
                                    task.wait(1.35)
                                elseif  enemy.Name == "Red Noob" then
                                    task.wait(1.1)
                                elseif enemy.Name == "Noobador" then
                                    task.wait(0.6)
                                elseif enemy.name == "Smugupine" then
                                    task.wait(1.69)
                                elseif enemy.name == "Devious Rat" then
                                    task.wait(1.72)
                                elseif enemy.name == "Ant Army" then
                                    task.wait(1.92)
                                elseif enemy.name == "Supreme Ant" then
                                    task.wait(0.54)
                                 elseif enemy.name == "Hungry Wolf" then
                                    task.wait(0.65)
                                 elseif enemy.name == "Snory Bear" then 
                                    task.wait(1.76)
                                 
                                 elseif enemy.name == "Loyal Knight" then
                                     task.wait(0.7)
                                 elseif enemy.name == "Cruel King" then
                                     task.wait(2)
                                 
                                 elseif enemy.name == "Sentient Statue" then
                                     task.wait(0.84)
                                     vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                                     task.wait(0.64)
                                 elseif enemy.name == "Banished Knight" then
                                     task.wait(0.28)
                                 elseif enemy.name == "Flying Mantis" then
                                     task.wait(1.24)
                                 elseif enemy.name == "Cheeky Eagle" then
                                     task.wait(1.1)
                                else
                                    task.wait(0.85)
                                end
                                
                                vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            end
                            if Shield then 
    local distance = (rootPart.Position - Shield.Position).Magnitude
    if distance < 6 then 
        task.wait(0.1)
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        task.wait()
    end
end

                            end
                        end
                    end
                end
            end)()
        end
    end
})]]
Section:Toggle({
    text = "Auto Dodge Attack V2 (BETA)",
    state = false,
    callback = function(state)
        getgenv().AutoDodgeAttackv2 = state

        if state then
            coroutine.wrap(function()
                local vim = game:GetService("VirtualInputManager")
                local players = game:GetService("Players")
                local player = players.LocalPlayer
                local enemiesFolder = workspace:WaitForChild("Enemies")

                local dodgeDelays = {
                    ["Helmet Noob"] = 1.25,
                    ["Blue Noob"] = 1.35,
                    ["Red Noob"] = 1.1,
                    ["Noobador"] = 0.6,
                    ["Smugupine"] = 1.69,
                    ["Devious Rat"] = 1.72,
                    ["Ant Army"] = 1.92,
                    ["Supreme Ant"] = 0.54,
                    ["Hungry Wolf"] = 0.65,
                    ["Snory Bear"] = 1.76,
                    ["Loyal Knight"] = 0.7,
                    ["Cruel King"] = 2,
                    ["Sentient Statue"] = 0.84,
                    ["Banished Knight"] = 0.28,
                    ["Flying Mantis"] = 1.24,
                    ["Cheeky Eagle"] = 1.2,
                    ["Mosquito Swarm"] = 0.82,
                    ["Gaur"] = 0 -- Add Gaur here with 0 delay
                }

                local function click()
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end

                while getgenv().AutoDodgeAttackv2 do
                    task.wait()

                    local gui = player:FindFirstChild("PlayerGui")
                    if not gui then continue end

                    local battleGui = gui:FindFirstChild("HUD") and gui.HUD:FindFirstChild("Battle")
                    if not (battleGui and battleGui:FindFirstChild("DOITNOW2") and battleGui.DOITNOW2.Visible) then
                        continue
                    end

                    local fPlayers = workspace:FindFirstChild("FPlayers")
                    if not fPlayers then continue end

                    local character = fPlayers:FindFirstChild(player.Name)
                    local rootPart = character and character:FindFirstChild("Model") and character.Model:FindFirstChild("HumanoidRootPart")
                    if not rootPart then continue end

                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local enemyModel = enemy:FindFirstChild("Model")
                        local enemyRoot = enemyModel and enemyModel:FindFirstChild("HumanoidRootPart")
                        local shield = enemyModel and enemyModel:FindFirstChild("Shield")
                        local altPart = nil

                        if enemy.Name == "Gaur" then
                            altPart = enemyModel and enemyModel:FindFirstChild("Head")
                        end

                        local partToCheck = altPart or enemyRoot
                        if partToCheck then
                            local dist = (rootPart.Position - partToCheck.Position).Magnitude
                            if dist < 7 then
                                local waitTime = dodgeDelays[enemy.Name] or 0.85
                                task.wait(waitTime)

                                if enemy.Name == "Sentient Statue" then
                                    click()
                                    task.wait(0.64)
                                else
                                    click()
                                end
                            end
                        end

                        if shield then
                            local shieldDist = (rootPart.Position - shield.Position).Magnitude
                            if shieldDist < 6 then
                                task.wait(0.1)
                                click()
                                task.wait()
                            end
                        end
                    end
                end
            end)()
        end
    end
})

--[[Section:Toggle({
    text = "Auto Dodge Attack V2(BETA)",
    state = false,
    callback = function(state)
        getgenv().AutoDodgeAttackv2 = state

        if state then
            coroutine.wrap(function()
                local vim = game:GetService("VirtualInputManager")
                local players = game:GetService("Players")
                local player = players.LocalPlayer
                local enemiesFolder = workspace:WaitForChild("Enemies")

                local dodgeDelays = {
                    ["Helmet Noob"] = 1.25,
                    ["Blue Noob"] = 1.35,
                    ["Red Noob"] = 1.1,
                    ["Noobador"] = 0.6,
                    ["Smugupine"] = 1.69,
                    ["Devious Rat"] = 1.72,
                    ["Ant Army"] = 1.92,
                    ["Supreme Ant"] = 0.54,
                    ["Hungry Wolf"] = 0.65,
                    ["Snory Bear"] = 1.76,
                    ["Loyal Knight"] = 0.7,
                    ["Cruel King"] = 2,
                    ["Sentient Statue"] = 0.84,
                    ["Banished Knight"] = 0.28,
                    ["Flying Mantis"] = 1.24,
                    ["Cheeky Eagle"] = 1
                }
                local DodgeDelaysSpecial = {
                    ["Gaur"] = 0
                }
                local function click()
                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end

                while getgenv().AutoDodgeAttackv2 do
                    task.wait()

                    local gui = player:FindFirstChild("PlayerGui")
                    if not gui then continue end

                    local battleGui = gui:FindFirstChild("HUD") and gui.HUD:FindFirstChild("Battle")
                    if not (battleGui and battleGui:FindFirstChild("DOITNOW2") and battleGui.DOITNOW2.Visible) then
                        continue
                    end

                    local fPlayers = workspace:FindFirstChild("FPlayers")
                    if not fPlayers then continue end

                    local character = fPlayers:FindFirstChild(player.Name)
                    local rootPart = character and character:FindFirstChild("Model") and character.Model:FindFirstChild("HumanoidRootPart")
                    if not rootPart then continue end

                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local enemyModel = enemy:FindFirstChild("Model")
                        local enemyRoot = enemyModel and enemyModel:FindFirstChild("HumanoidRootPart")
                        local shield = enemyModel and enemyModel:FindFirstChild("Shield")

                        if enemyRoot then
                            local dist = (rootPart.Position - enemyRoot.Position).Magnitude
                            if dist < 7 then
                                local waitTime = dodgeDelays[enemy.Name] or 0.85
                                task.wait(waitTime)

                                if enemy.Name == "Sentient Statue" then
                                    click()
                                    task.wait(0.64)
                                else
                                    click()
                                end
                            end
                        end

                        if shield then
                            local shieldDist = (rootPart.Position - shield.Position).Magnitude
                            if shieldDist < 6 then
                                task.wait(0.1)
                                click()
                                task.wait()
                            end
                        end
                    end
                end
            end)()
        end
    end
})]]

--[[Section:Toggle({
    text = "Auto Dodge AttackV2 (BETA)",
    state = false,
    callback = function(state)
        getgenv().AutoDodgeAttackV2 = state

        if state then
            coroutine.wrap(function()
                local vim = game:GetService("VirtualInputManager")
                local players = game:GetService("Players")
                local player = players.LocalPlayer
                local runService = game:GetService("RunService")

                while getgenv().AutoDodgeAttack do
                    task.wait()

                    -- Check network (WiFi) status
                    local ping = stats().Network.ServerStatsItem["Data Ping"]:GetValue()
                    if ping > 400 then continue end -- Skip if ping is too high

                    local gui = player:FindFirstChild("PlayerGui")
                    local doitNowGui = gui and gui:FindFirstChild("HUD") and gui.HUD:FindFirstChild("Battle") and gui.HUD.Battle:FindFirstChild("DOITNOW2")

                    if doitNowGui and doitNowGui.Visible then
                        local fPlayers = workspace:FindFirstChild("FPlayers")
                        if not fPlayers then continue end

                        local character = fPlayers:FindFirstChild(player.Name)
                        if not (character and character:FindFirstChild("Model") and character.Model:FindFirstChild("HumanoidRootPart")) then continue end

                        local rootPart = character.Model.HumanoidRootPart

                        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                            local enemyModel = enemy:FindFirstChild("Model")
                            local enemyRoot = enemyModel and enemyModel:FindFirstChild("HumanoidRootPart")

                            if enemyRoot then
                                local distance = (rootPart.Position - enemyRoot.Position).Magnitude

                                if distance < 6.2 then
                                    -- Reaction delay based on enemy type
                                    local delayMap = {
                                        ["Helmet Noob"] = 1.25,
                                        ["Blue Noob"] = 1.35,
                                        ["Red Noob"] = 1.1,
                                        ["Noobador"] = 0.6
                                    }

                                    task.wait(delayMap[enemy.Name] or 0.9)

                                    -- Simulate dodge click
                                    vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                    vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)

                                    break -- Only dodge once per detection
                                end
                            end
                        end
                    end
                end
            end)()
        end
    end
})]]

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
