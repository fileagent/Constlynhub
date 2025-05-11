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
    text = "Store Skinwalker",
    callback = function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StoreRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Store")
for _, obj in ipairs(workspace.GameObjects:GetChildren()) do
	if obj:IsA("Model") and sk:FindFirstChild("HumanoidRootPart")  then
		StoreRemote:FireServer(obj)
	end
end
for _, sk in ipairs(workspace.Runners.Skinwalkers:GetChildren()) do
	if sk:IsA("Model") and sk:FindFirstChild("Humanoid") and sk.Humanoid.Health <= 0 and sk:FindFirstChild("HumanoidRootPart") then
		StoreRemote:FireServer(sk)
	end
end

    end,
})
Section:Toggle({
    text = "Auto Store ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoStore = boolean
        
        if getgenv().AutoStore then
            coroutine.wrap(function()
                while getgenv().AutoStore do
                task.wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StoreRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Store")
--[[for _, obj in ipairs(workspace.GameObjects:GetChildren()) do
	if obj:IsA("Model") and sk:FindFirstChild("HumanoidRootPart")  then
		StoreRemote:FireServer(obj)
	end
end]]
for _, sk in ipairs(workspace.Runners.Skinwalkers:GetChildren()) do
	if sk:IsA("Model") and sk:FindFirstChild("Humanoid") and sk.Humanoid.Health <= 0 and sk:FindFirstChild("HumanoidRootPart") then
		StoreRemote:FireServer(sk)
	end
end
for _, nw in ipairs(workspace.Nightwalkers:GetChildren()) do
	if nw:IsA("Model") and nw:FindFirstChild("Humanoid") and nw.Humanoid.Health <= 0 and nw:FindFirstChild("HumanoidRootPart") then
		StoreRemote:FireServer(nw)
	end
end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Shoot Skinwalker/Nightwalker",
    state = false,
    callback = function(state)
        getgenv().AutoShootSkinwalkerAndNightwalker = state

        if state then
            coroutine.wrap(function()
                local sniperRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SniperShot")
                while getgenv().AutoShootSkinwalkerAndNightwalker do
                    task.wait(1)

                    local function autoShoot(folder)
    for _, entity in ipairs(folder:GetChildren()) do
        local humanoid = entity:FindFirstChild("Humanoid")
        local hrp = entity:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp and humanoid.Health > 0 then
            local origin = hrp.Position + Vector3.new(0, 5, 0)
            local target = hrp.Position
            sniperRemote:FireServer(origin, target, hrp)
            task.wait(0.1)
        end
    end
end


                    local runners = workspace:FindFirstChild("Runners")
                    if runners then
                        local skinwalkerFolder = runners:FindFirstChild("Skinwalkers")
                        if skinwalkerFolder then autoShoot(skinwalkerFolder) end
                    end

                    local nightwalkerFolder = workspace:FindFirstChild("Nightwalkers")
                    if nightwalkerFolder then autoShoot(nightwalkerFolder) end
                end
            end)()
        end
    end
})



Section:Toggle({
    text = "Auto Pick Up Cash ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoPickUpCash = boolean
        
        if getgenv().AutoPickUpCash then
            coroutine.wrap(function()
                while getgenv().AutoPickUpCash do
                task.wait()
for i,v in pairs(workspace.GameObjects:GetChildren()) do
if v:IsA("Part") and v.Name:find("Money") then
fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt"))
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
