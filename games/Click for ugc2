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
    text = "Redeem All Code",
    callback = function()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Codes:GetChildren()) do 
local args = {
    [1] = v.Name
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UseCode"):FireServer(unpack(args))
task.wait(0.5)
end
    end,
})

Section:Toggle({
    text = "Auto Spin ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoSpin = boolean
        
        if getgenv().AutoSpin then
            coroutine.wrap(function()
                while getgenv().AutoSpin do
                task.wait()
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpinWheel"):FireServer()

                end
            end)()
        end
    end
})
Section:Toggle({
    text = "AutoClick",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoClick = boolean
        
        if getgenv().AutoClick then
            coroutine.wrap(function()
                while getgenv().AutoClick do
                task.wait()
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Click"):FireServer()

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
