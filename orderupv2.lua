local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()

game:GetService("ReplicatedStorage").Events.Local.Alert:Fire("ConstlynHub","THX for using our script")

-- Toggle UI: Library:Toggle()

-- Function to delete objects for anti-lag
function deleteForAntiLags()
    if not getgenv().onlyonetime then
        local targets = {}
        
        if game.PlaceId == 15812335463 or game.PlaceId == 16872617739 then
            targets = {
                workspace.Main.Kitchen.Buns,
                workspace.Main.Kitchen:GetChildren()[6],
                workspace.Main.Kitchen.Fryer,
                workspace.Main.Kitchen.Model,
                workspace.Main.Kitchen.Patty,
                workspace.Main.Kitchen:GetChildren()[12],
                workspace.Main.Kitchen.Plate,
                workspace.Main.Kitchen.Salad,
                workspace.Main.Kitchen.SodaMachine,
                workspace.Main.Kitchen.Stove,
                workspace.Main.Kitchen:GetChildren()[4],
                workspace.Main.Kitchen.Trash,
            }
        elseif game.PlaceId == 16819089066 or game.PlaceId == 16873261961 then
            targets = {
                workspace.Main.Kitchen:GetChildren()[17],
                workspace.Main.Kitchen.Bush_03,
                workspace.Main.Kitchen:GetChildren()[19],
                workspace.Main.Kitchen:GetChildren()[18],
                workspace.Main.Kitchen.Japanese_Drink,
                workspace.Main.Kitchen:GetChildren()[9],
                workspace.Main.Kitchen.MeatPrep,
                workspace.Main.Kitchen:GetChildren()[13],
                workspace.Main.Kitchen:GetChildren()[12],
                workspace.Main.Kitchen.NigiriPrep,
                workspace.Main.Kitchen:GetChildren()[2],
                workspace.Main.Kitchen.Plate,
                workspace.Main.Kitchen.RamenKit,
                workspace.Main.Kitchen.Stove,
                workspace.Main.Kitchen:GetChildren()[20],
                workspace.Main.Kitchen:GetChildren()[11],
                workspace.Main.Kitchen.SushiPrep,
                workspace.Main.Kitchen.Trash,
                workspace.Main.Kitchen.UncutMeat,
            }
        end

        for _, obj in ipairs(targets) do
            if obj then
                obj:Destroy()
            end
        end
        
        getgenv().onlyonetime = true
    elseif getgenv().onlyonetime then
        return
    end
end

-- Function to handle anti-lag by cleaning player-generated models
function antiLags()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local character = player.Character
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Model") and (item.Name == "Fries" or item.Name == "Salad" or item.Name == "Burger" or item.Name == "Soda" or item.Name == "Cake" or item.Name == "Sushi" or item.Name == "Nigiri" or item.Name == "Donut" or item.Name == "Pastery" or item.Name == "Drink" or item.Name == "Japanese_Drink" or item.Name == "Ramen" or item.Name == "Cleansing Tea") then
                    item:Destroy()
                end
            end
        end
    end
end

-- Function to handle automated farming for dinner orders
function autoFarmOrders()
    if game.PlaceId == 15812335463 or game.PlaceId == 16872617739 then
        local foodItems = {"Fries", "Burger", "Soda", "Salad"}
        
        for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
            for _, item in ipairs(foodItems) do
                local args = { [1] = item, [2] = 16232900 }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)
                task.wait()
            end
        end
        
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
        
        local bossLocation = workspace.Main.BotFolder.BossLocation
        for _, item in ipairs(foodItems) do
            local args = { [1] = item, [2] = 16232900 }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
            task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)
        end
        
    elseif game.PlaceId == 16819089066 then
        local foodItems = {"Ramen", "Japanese_Drink", "Sushi", "Nigiri"}
        
        for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
            for _, item in ipairs(foodItems) do
                local args = { [1] = item, [2] = 16232900 }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)
                task.wait()
            end
        end
        
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
        
        local bossLocation = workspace.Main.BotFolder.BossLocation
        for _, item in ipairs(foodItems) do
            local args = { [1] = item, [2] = 16232900 }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
            task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)
        end
        
    elseif game.PlaceId == 16873261961 or game.PlaceId == 15897687172 then
        local foodItems = {"Cake", "Drink", "Donut", "Pastery"}
        
        for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
            for _, item in ipairs(foodItems) do
                local args = { [1] = item, [2] = 16232900 }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                task.wait()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)
                task.wait()
            end
        end
        
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
        
        local bossLocation = workspace.Main.BotFolder.BossLocation
        for _, item in ipairs(foodItems) do
            local args = { [1] = item, [2] = 16232900 }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
            task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)
        end
    end
end
function autofarmordersv2()
return
end

-- Creating GUI with sections, functionality, and controls
local Window = Library:Window({ text = "ConstlynHub" })
local TabSection = Window:TabSection({ text = "order up" })

local Tab = TabSection:Tab({
    text = "Main",
    icon = "rbxassetid://7999345313"
})

local Section = Tab:Section({ text = "Features" })

Section:Button({
    text = "Teleport to Unreleased Dinner 🎁",
    callback = function()
        game:GetService("TeleportService"):Teleport(15989668274)
    end,
})

Section:Button({
    text = "Teleport To Unreleased Bakery 🎁",
    callback = function()
        game:GetService("TeleportService"):Teleport(16142203369)
    end,
})
Section:Toggle({
    text = "AutoFarm V2[Better wifi]✨",
    state = false,
    callback = function(state)
        getgenv().AutofarmV2 = state
        
        if getgenv().AutofarmV2 then
            coroutine.wrap(function()
                while getgenv().AutofarmV2 do
                    game:GetService("RunService").heartbeat:Wait()
                    
                    -- Process regular bot locations
                    for _, location in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do
                        for _, bot in pairs(location:GetChildren()) do 
                            if bot:IsA("Model") and bot:FindFirstChild("HumanoidRootPart") then
                                if (bot.HumanoidRootPart.Position - location.Hitbox.Position).Magnitude < 5 then
                                    local orderFolder = bot:FindFirstChildWhichIsA("Folder")
                                    if orderFolder then
                                        for _, order in pairs(orderFolder:GetChildren()) do
                                            local itemName = order.Name
                                            
                                            if itemName ~= "Anything" then
                                                local args = { [1] = itemName, [2] = 16232900 }
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                                                
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)

                                            else
                                                -- Handle "Anything" order type with a default item
                                                local defaultItem = "Salad"
                                                if game.PlaceId == 16819089066 or game.PlaceId == 16873261961 then
                                                    defaultItem = game.PlaceId == 16819089066 and "Sushi" or "Cake"
                                                end
                                                
                                                local args = { [1] = defaultItem, [2] = 16232900 }
                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))

                                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(location)

                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Process boss location
                    local bossLocation = workspace.Main.BotFolder.BossLocation
                    for _, bot in pairs(bossLocation:GetChildren()) do 
                        if bot:IsA("Model") and bot:FindFirstChild("HumanoidRootPart") then
                            if (bot.HumanoidRootPart.Position - bossLocation.Hitbox.Position).Magnitude < 10 then
                                local orderFolder = bot:FindFirstChildWhichIsA("Folder")
                                if orderFolder then
                                    for _, order in pairs(orderFolder:GetChildren()) do
                                        local itemName = order.Name
                                        
                                        if itemName ~= "Anything" then
                                            local args = { [1] = itemName, [2] = 16232900 }
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                                           
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)

                                        else
                                            -- Handle "Anything" order type with a default item for boss
                                            local defaultItem = "Salad"
                                            if game.PlaceId == 16819089066 or game.PlaceId == 16873261961 then
                                                defaultItem = game.PlaceId == 16819089066 and "Sushi" or "Cake"
                                            end
                                            
                                            local args = { [1] = defaultItem, [2] = 16232900 }
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
                                           
                                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(bossLocation)

                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Clean tables in a separate thread to not delay the main loop
                    task.spawn(function()
                        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
                        end
                    end)
                end
            end)()
        end
    end
})

Section:Toggle({
    text = "AutoFarm ✨",
    state = false,
    callback = function(state)
        getgenv().autofarmorder = state
        
        if getgenv().autofarmorder then
            if not getgenv().autofarmConnection then
                getgenv().autofarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().autofarmorder then
                        autoFarmOrders()
                    else
                        task.wait()
                        getgenv().autofarmConnection:Disconnect()
                        getgenv().autofarmConnection = nil
                    end
                end)
            end
        elseif getgenv().autofarmConnection then
            task.wait()
            getgenv().autofarmConnection:Disconnect()
            getgenv().autofarmConnection = nil
        end
    end
})

Section:Toggle({
    text = "AntiLag 🎯",
    state = false,
    callback = function(state)
        getgenv().antilag = state
        
        if getgenv().antilag then
            deleteForAntiLags()
            
            getgenv().onlyonetime = true
            if not getgenv().antilagConnection then
                getgenv().antilagConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().antilag then
                        antiLags()
                    else
                        task.wait()
                        getgenv().antilagConnection:Disconnect()
                        getgenv().antilagConnection = nil
                    end
                end)
            end
        elseif getgenv().antilagConnection then
            task.wait()
            getgenv().antilagConnection:Disconnect()
            getgenv().antilagConnection = nil
        end
    end
})

Section:Dropdown({
    text = "Select Crate",
    list = {"Diner", "Bakery", "Japanese"},
    default = "Diner",
    callback = function(selected)
        getgenv().NameOfRestourant = selected
    end
})

Section:Toggle({
    text = "Auto Crates [LOBBY] | 🍴",
    state = false,
    callback = function(state)
        getgenv().autocrates = state
        
        if getgenv().autocrates then
            if not getgenv().autocratesConnection then
                getgenv().autocratesConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().autocrates then
                        local foodItems = {"Burger", "Salad", "Soda", "Fries"}
                        local foodItems1 = {"Drinks", "Pastery", "Donut", "Cake"}
                        local foodItems2 = {"Sushi", "Nigiri", "Ramen", "Japanese_Drink"}
                        
                        if getgenv().NameOfRestourant == "Diner" then
                            for _, item in ipairs(foodItems) do
                                local args = { "Diner", item, "Money" }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args))
                            end
                        elseif getgenv().NameOfRestourant == "Bakery" then
                            for _, item1 in ipairs(foodItems1) do
                                local args = { "Bakery", item1, "Money" }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args))
                            end
                        elseif getgenv().NameOfRestourant == "Japanese" then
                            for _, item2 in ipairs(foodItems2) do
                                local args = { "Japanese", item2, "Money" }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args))
                            end
                        end
                    else
                        task.wait()
                        getgenv().autocratesConnection:Disconnect()
                        getgenv().autocratesConnection = nil
                    end
                end)
            end
        elseif getgenv().autocratesConnection then
            task.wait()
            getgenv().autocratesConnection:Disconnect()
            getgenv().autocratesConnection = nil
        end
    end
})

-- Add additional utility functions
local UtilitySection = Tab:Section({ text = "Utilities" })

UtilitySection:Button({
    text = "Instant Cleanup Tables",
    callback = function()
        for _, table in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(table)
        end
    end
})

UtilitySection:Button({
    text = "Refresh UI",
    callback = function()
        Library:Toggle()
        task.wait(0.5)
        Library:Toggle()
    end
})

-- Credits section
local CreditsSection = Tab:Section({ text = "Credits" })

-- Use TextBox or Button instead of Label since Label isn't implemented
CreditsSection:Button({
    text = "Script by ConstlynHub Team",
    callback = function() end -- Empty callback
})

CreditsSection:Button({
    text = "Updated: March 2025",
    callback = function() end -- Empty callback
})
