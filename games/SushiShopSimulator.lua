local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Neverlose/source.lua"))()
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
    text = "Auto Clean Dishes",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoCleanDishes = boolean
        
        if getgenv().AutoCleanDishes then
            coroutine.wrap(function()
                while getgenv().AutoCleanDishes do
               fireclickdetector(workspace.Game.Sink2:FindFirstChildWhichIsA("ClickDetector"))
fireclickdetector(workspace.Game.Sink1:FindFirstChildWhichIsA("ClickDetector"))
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Create Sushi",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoCreateSushi = boolean
        
        if getgenv().AutoCreateSushi then
            coroutine.wrap(function()
                while getgenv().AutoCreateSushi do
                game:GetService("RunService").heartbeat:Wait()
fireclickdetector(workspace.Game["23483"]:FindFirstChildWhichIsA("ClickDetector"))
fireclickdetector(workspace.Game["68215628"]:FindFirstChildWhichIsA("ClickDetector"))
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
