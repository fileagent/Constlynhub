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
    text = "Free Pet(notify)",
    callback = function()
local args = {
    [1] = "FreeNotifyLegendary"
}

game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))

    end,
})

Section:Toggle({
    text = "Auto Doggy Jump Win ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoDoggyJumpWinner = boolean
        
        if getgenv().AutoDoggyJumpWinner then
            coroutine.wrap(function()
                while getgenv().AutoDoggyJumpWinner do
                task.wait()
local args = {
    [1] = "DoggyJumpWin",
    [2] = 3
}

game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))

                end
            end)()
        end
    end
})

Section:Toggle({
    text = "Auto Sell + blow Bubble ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoBlowSellBubble = boolean
        
        if getgenv().AutoBlowSellBubble then
            coroutine.wrap(function()
                while getgenv().AutoBlowSellBubble do
                task.wait()
for i=1,5 do 
game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("BlowBubble")
game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("SellBubble")
end
                end
            end)()
        end
    end
})

Section:Toggle({
    text = "Auto Blow Bubble ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoBlowBubble = boolean
        
        if getgenv().AutoBlowBubble then
            coroutine.wrap(function()
                while getgenv().AutoBlowBubble do
                task.wait()
for i=1,5 do 
game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer("BlowBubble")
end
                end
            end)()
        end
    end
})
Section:Slider({
    text = "Distance(auto collect)",
    min = 1,
    max = 20,
    -- [[Float = 0,]] Idk what it does
    callback = function(number)
       getgenv().Distance = number
    end
})
Section:Toggle({
    text = "Auto Collect",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoCollect = boolean
        
        if getgenv().AutoCollect then
            coroutine.wrap(function()
                while getgenv().AutoCollect do
                task.wait()
local distance = getgenv().Distance or 10 -- edit if you want op/owner post max are 45 
for _,GetChuncker in pairs(workspace.Rendered:GetChildren()) do 
if GetChuncker.Name == "Chunker" then
local Chunker = GetChuncker
for i,v in pairs(Chunker:GetChildren()) do 
if v:FindFirstChildWhichIsA("MeshPart") and (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChildWhichIsA("MeshPart").Position).Magnitude < distance or v:FindFirstChildWhichIsA("Part") and v:FindFirstChildWhichIsA("Part"):FindFirstChild("PointLight") and (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - v:FindFirstChildWhichIsA("Part").Position).Magnitude < distance then


game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Pickups"):WaitForChild("CollectPickup"):FireServer(v.Name)
task.wait(0.1)
v:Destroy() -- prevent lags
end
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
