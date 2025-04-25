if game.PlaceId == 15798268709 then
  local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Neverlose/source.lua"))()
-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "The Sewer"
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
    text = "Test",
    callback = function()
print("EMPTY")
    end,
})
--[[Section:Toggle({
    text = "Auto Grab Dropped Item",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoGrabDroppedItem = boolean
        
        if getgenv().AutoGrabDroppedItem then
            coroutine.wrap(function()
                while getgenv().AutoGrabDroppedItem do
                task.wait(0.05)
for i,v in pairs(workspace.DynamicFurniture:GetChildren()) do 
if v.Name:find("BottlePack") then 
fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt")
end
end
                end
            end)()
        end
    end
})]]

Section:Toggle({
    text = "Auto Grab Bottle from machine",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoGrabBottleFromMachine = boolean
        
        if getgenv().AutoGrabBottleFromMachine then
            coroutine.wrap(function()
                while getgenv().AutoGrabBottleFromMachine do
                task.wait(0.2)
for i,v in pairs(workspace.DynamicFurniture:GetChildren()) do 
if v.Name:find("BottleCollector") then 
local args = {
    [1] = v
}

game:GetService("ReplicatedStorage"):WaitForChild("shared/network@GlobalEvents"):WaitForChild("collectBottleCollector"):FireServer(unpack(args))
end
end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto farm Scrap pile",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutofarmScrapfrompile = boolean
        
        if getgenv().AutofarmScrapfrompile then
            coroutine.wrap(function()
                while getgenv().AutofarmScrapfrompile do
                task.wait(0.2)
for i,v in pairs(workspace.DynamicFurniture:GetChildren()) do 
if v.Name == "ScrapPile" and v:FindFirstChild("Main") and v:FindFirstChild("Model")  then
    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Main.Position)
if  (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Main.Position).Magnitude < 20 then 
fireproximityprompt(v.Model:FindFirstChildWhichIsA("ProximityPrompt"))
end
end
end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Get Scrap from pile",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoGetScrapFromPile = boolean
        
        if getgenv().AutoGetScrapFromPile then
            coroutine.wrap(function()
                while getgenv().AutoGetScrapFromPile do
                task.wait(0.2)
for i,v in pairs(workspace.DynamicFurniture:GetChildren()) do 
if v.Name == "ScrapPile" then
if v:FindFirstChild("Model") and v:FindFirstChild("Main") and (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v.Main.Position).Magnitude < 20 then 
fireproximityprompt(v.Model:FindFirstChildWhichIsA("ProximityPrompt"))
end
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
end
