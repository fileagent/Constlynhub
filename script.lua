local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()

-- Toggle UI: Library:Toggle()
function deleteforantilags()
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
     
end
function antilags()
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
function autofarmorderdinner()
    for i, v in pairs(workspace.Main.BotFolder.Locations:GetChildren()) do 
        local args
        
        args = { [1] = "Fries", [2] = 16232900 }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
        task.wait()

        args = { [1] = v }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(unpack(args))
        task.wait()

        args = { [1] = "Burger", [2] = 16232900 }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
        task.wait()

        args = { [1] = v }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(unpack(args))
        task.wait()

        args = { [1] = "Soda", [2] = 16232900 }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
        task.wait()

        args = { [1] = v }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(unpack(args))
        task.wait()

        args = { [1] = "Salad", [2] = 16232900 }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
        task.wait()

        args = { [1] = v }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(unpack(args))
    end

    for i, v in pairs(workspace.Main.BotFolder.Tables:GetChildren()) do
        local args = { [1] = v }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("InteractTable"):InvokeServer(unpack(args))
    end

    local bossLocation = workspace.Main.BotFolder.BossLocation
    local foodItems = {"Fries", "Burger", "Soda", "Salad"}

    for _, item in ipairs(foodItems) do
        local args = { [1] = item, [2] = 16232900 }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("SetHolding"):InvokeServer(unpack(args))
        task.wait()
        
        local args = { [1] = bossLocation }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("GiveBot"):InvokeServer(unpack(args))
        task.wait()
    end
end

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
    text = "Teleport to Unreleased Bakery | 🎁",
    callback = function()
        game:GetService("TeleportService"):Teleport(15989668274)
    end,
})

Section:Button({
    text = "Teleport To Unreleased Dinner | 🎁 ",
    callback = function()
        game:GetService("TeleportService"):Teleport(16142203369)
    end,
})

Section:Toggle({
    text = "AutoFarm | ✨",
    state = false, -- Default boolean
    callback = function(state)
        getgenv().autofarmorder = state
        if getgenv().autofarmorder then
            if not getgenv().autofarmConnection then
                getgenv().autofarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().autofarmorder then
                        autofarmorderdinner()
                    else
                        
                        task.wait(2)
                        getgenv().autofarmConnection:Disconnect()
                        getgenv().autofarmConnection = nil
                    end
                end)
            end
        elseif getgenv().autofarmConnection then
            task.wait(2)
            getgenv().autofarmConnection:Disconnect()
            getgenv().autofarmConnection = nil
        end
    end
})

Section:Toggle({
    text = "AntiLag | 🎯",
    state = false, -- Default boolean
    callback = function(state)
        getgenv().antilag = state
        if getgenv().antilag then
            deleteforantilags()
            if not getgenv().antilagConnection then
                getgenv().antilagConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().antilag then
                        antilags()
                    else
                      
                        task.wait(2)
                        getgenv().antilagConnection:Disconnect()
                        getgenv().antilagConnection = nil
                    end
                end)
            end
        elseif getgenv().antilagConnection then
            
            task.wait(2)
            getgenv().antilagConnection:Disconnect()
            getgenv().antilagConnection = nil
        end
    end
})

Section:Toggle({
    text = "Auto Crates [LOBBY] | 🍴",
    state = false, -- Default boolean
    callback = function(state)
        getgenv().autocrates = state
        if getgenv().autocrates then
            if not getgenv().autocratesConnection then
                getgenv().autocratesConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().autocrates then
                        local args1 = {
    [1] = "Diner",
    [2] = "Burger",
    [3] = "Money"
}
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args1))


local args2 = {
    [1] = "Diner",
    [2] = "Salad",
    [3] = "Money"
}
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args2))


local args3 = {
    [1] = "Diner",
    [2] = "Soda",
    [3] = "Money"
}
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args3))


local args4 = {
    [1] = "Diner",
    [2] = "Fries",
    [3] = "Money"
}
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Remote"):WaitForChild("AttemptCrate"):InvokeServer(unpack(args4))

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
