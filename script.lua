local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
game:GetService("ReplicatedStorage").Events.Local.Alert:Fire("ConstlynHub","THX for using ours script")
-- Toggle UI: Library:Toggle()

-- Function to delete objects for anti-lag
function deleteForAntiLags()
    if not getgenv().onlyonetime then
    if game.PlaceId == 15812335463 or game.PlaceId == 16872617739 then
    local targets = {
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
end
function deleteForAntiLags1()
    if not getgenv().onlyonetime1 then
if game.PlaceId == 15812335463 or game.PlaceId == 16872617739 then
    local targets = {
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
    for _, obj in ipairs(targets) do
        if obj then
            obj:Destroy()
        end
    end
            getgenv().onlyonetime1 = true
        elseif getgenv().onlyonetime1 then
            return
        end
    end
end
-- Function to handle anti-lag by cleaning player-generated models
function antiLags()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local character = player.Character
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Model") and (item.Name == "Fries" or item.Name == "Salad" or item.Name == "Burger" or item.Name == "Soda") then
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
   elseif game.PlaceId == 71853648817494 or game.PlaceId == 16819089066 then
              local foodItems = {"Ramen", "Japanese_Drink", "Sushi","Nigiri"}
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

-- Creating GUI with sections, functionality, and controls
local Window = Library:Window({ text = "Window" })
local TabSection = Window:TabSection({ text = "TabSection" })
local Tab = TabSection:Tab({
    text = "Tab",
    icon = "rbxassetid://7999345313"
})
local Section = Tab:Section({ text = "Section" })

Section:Button({
    text = "Teleport to Unreleased Bakery 🎁",
    callback = function()
        game:GetService("TeleportService"):Teleport(15989668274)
    end,
})

Section:Button({
    text = "Teleport To Unreleased Dinner 🎁",
    callback = function()
        game:GetService("TeleportService"):Teleport(16142203369)
    end,
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
            deleteForAntiLags1()
            getgenv().onlyonetime = true
            getgenv().onlyonetime1 = true
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
                        for _, item in ipairs(foodItems) do
                            local args = { "Diner", item, "Money" }
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args))
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

Section:Slider({
    text = "Slider",
    min = 10,
    max = 100,
    callback = function(number)
        print(number)
    end
})

Section:Dropdown({
    text = "Dropdown",
    list = {"Apple", "Banana", "Coconut"},
    default = "Apple",
    callback = function(selected)
        print(selected)
    end
})

Section:Textbox({
    text = "Textbox",
    value = "Default",
    callback = function(text)
        print(text)
    end
})

Section:Colorpicker({
    text = "Colorpicker",
    color = Color3.new(1, 1, 1),
    callback = function(color)
        print(color)
    end
})

Section:Keybind({
    text = "Keybind",
    default = Enum.KeyCode.Z,
    callback = function(key)
        print("Triggered Keybind: ", key)
    end
})
