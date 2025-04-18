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
    text = "click to collect Token",
    callback = function()
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart -- Define the HumanoidRootPart

for i,v in pairs(workspace.Tokens:GetChildren()) do
local touchTransmitter = v:FindFirstChildOfClass("TouchTransmitter")
        if touchTransmitter then
            firetouchinterest(hrp, v, 0) -- Touch start
            task.wait(0.01)
            firetouchinterest(hrp, v, 1) -- Touch end
        end
end
    end,
})
Section:Toggle({
    text = "Auto Target Challenge ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoTargetChallenge = boolean
        
        if getgenv().AutoTargetChallenge then
            coroutine.wrap(function()
                while getgenv().AutoTargetChallenge do
                task.wait()
for i,v in pairs(workspace.Machines.TargetChallenge.PlayField:GetChildren()) do 
if v:FindFirstChildWhichIsA("ClickDetector") then
fireclickdetector(v:FindFirstChildWhichIsA("ClickDetector"))
end
end
                end
            end)()
        end
    end
})

Section:Toggle({
    text = "Auto Collect Token ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoCollectToken = boolean
        
        if getgenv().AutoCollectToken then
            coroutine.wrap(function()
                while getgenv().AutoCollectToken do
                task.wait()
local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart -- Define the HumanoidRootPart

for i,v in pairs(workspace.Tokens:GetChildren()) do
local touchTransmitter = v:FindFirstChildOfClass("TouchTransmitter")
        if touchTransmitter then
            firetouchinterest(hrp, v, 0) -- Touch start
            task.wait(0.01)
            firetouchinterest(hrp, v, 1) -- Touch end
        end
end
                end
            end)()
        end
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
