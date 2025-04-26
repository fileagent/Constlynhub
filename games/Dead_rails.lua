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
    text = "Free Horse(Lobby Only)",
    callback = function()
game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_BuyClass"):FireServer("Horse")

    end,
})
Section:Slider({
    text = "Gun Aura Distance",
    min = 5,
    max = 150,
    -- [[Float = 0,]] Idk what it does
    callback = function(number)
        getgenv().GunAuraSettings = number
    end
})
-- ill create Custom One if i can sorry for skid it
-- [[Gun Aura unfinished!
local Camera = workspace.CurrentCamera
local args = {
    [1] = workspace:GetServerTimeNow(),
    [2] = game:GetService("Players").LocalPlayer.Character.Revolver,
    [3] = CFrame.new(Camera.CFrame.Position, workspace.RandomBuildings.GeneralStoreDestroyed.StandaloneZombiePart.Zombies.Model_Runner.Head.Position),
    [4] = {
        ["1"] = workspace.RandomBuildings.GeneralStoreDestroyed.StandaloneZombiePart.Zombies.Model_Runner:WaitForChild("Humanoid"),
        ["2"] = workspace.RandomBuildings.GeneralStoreDestroyed.StandaloneZombiePart.Zombies.Model_Runner:WaitForChild("Humanoid")
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Weapon"):WaitForChild("Shoot"):FireServer(unpack(args))

]] 
Section:Toggle({
    text = "Gun Aura",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoGunAura = boolean
        
        if getgenv().AutoGunAura then
            coroutine.wrap(function()
                while getgenv().AutoGunAura do
                task.wait(0.05)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShootRemote  = ReplicatedStorage.Remotes.Weapon.Shoot
local ReloadRemote = ReplicatedStorage.Remotes.Weapon.Reload

local Players = game:GetService("Players")
local workspace = game.Workspace
local Camera = workspace.CurrentCamera

local AutoHeadshotEnabled = true    -- What this does will explain itself lol
local AutoReloadEnabled   = true   -- What this does will explain itself lol
local GunAuraAllMobs      = true    -- What this does will explain itself lol

local SEARCH_RADIUS       = getgenv().GunAuraSettings   
local HEADSHOT_DELAY      = 0.15    -- What this does will explain itself lol

local SupportedWeapons = {
    "Revolver",
    "Rifle",
    "Sawed-Off Shotgun",
    "Shotgun"
}
local function isPlayerModel(m)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character == m then
            return true
        end
    end
    return false
end

local function getEquippedSupportedWeapon()
    local char = Players.LocalPlayer and Players.LocalPlayer.Character
    if not char then return nil end
    for _, name in ipairs(SupportedWeapons) do
        local tool = char:FindFirstChild(name)
        if tool then
            return tool
        end
    end
    return nil
end

local function findAllNPCsInRange()
    local npcs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and not isPlayerModel(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local head = obj:FindFirstChild("Head")
            if hum and head and hum.Health > 0 then
                local dist = (head.Position - Camera.CFrame.Position).Magnitude
                if dist <= SEARCH_RADIUS then
                    table.insert(npcs, {model = obj, hum = hum, head = head})
                end
            end
        end
    end
    return npcs
end
local function findClosestCategories()
    local bestModel, bestHumanoid, bestHead
    local minDist = SEARCH_RADIUS
    for model, data in pairs(ESPObjects or {}) do
        local cat = data.category
        if cat == "Zombies" or cat == "NightEnemies" or cat == "Cowboys" then
            local hum = model:FindFirstChildOfClass("Humanoid")
            local head = model:FindFirstChild("Head")
            if hum and head and hum.Health > 0 then
                local dist = (head.Position - Camera.CFrame.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    bestModel = model
                    bestHumanoid = hum
                    bestHead = head
                end
            end
        end
    end
    return bestModel, bestHumanoid, bestHead
end
        local tool = getEquippedSupportedWeapon()
        if tool then
            if GunAuraAllMobs then
                local npcs = findAllNPCsInRange()
                for _, npc in ipairs(npcs) do
                    local pelletTable = {}
                    if tool.Name == "Shotgun" or tool.Name == "Sawed-Off Shotgun" then
                        for i = 1, 6 do
                            pelletTable[tostring(i)] = npc.hum
                        end
                    else
                        pelletTable["1"] = npc.hum
                    end
                    local shootArgs = {
                        workspace:GetServerTimeNow(),
                        tool,
                        CFrame.new(Camera.CFrame.Position, npc.head.Position),
                        pelletTable
                    }
                    ShootRemote:FireServer(unpack(shootArgs))
                    if AutoReloadEnabled then
                        task.wait(0.1)
                        ReloadRemote:FireServer(workspace:GetServerTimeNow(), tool)
                    end
                end
            else
                local model, hum, head = findClosestCategories()
                if model and hum and head then
                    local pelletTable = {}
                    if tool.Name == "Shotgun" or tool.Name == "Sawed-Off Shotgun" then
                        for i = 1, 6 do
                            pelletTable[tostring(i)] = hum
                        end
                    else
                        pelletTable["1"] = hum
                    end
                    local shootArgs = {
                        workspace:GetServerTimeNow(),
                        tool,
                        CFrame.new(Camera.CFrame.Position, head.Position),
                        pelletTable
                    }
                    ShootRemote:FireServer(unpack(shootArgs))
                    if AutoReloadEnabled then
                        task.wait(0.1)
                        ReloadRemote:FireServer(workspace:GetServerTimeNow(), tool)
                    end
                end
            end
        end
        task.wait(HEADSHOT_DELAY)
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Grab Ammo + bond",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoGrabAmmoBond = boolean
        
        if getgenv().AutoGrabAmmoBond then
            coroutine.wrap(function()
                while getgenv().AutoGrabAmmoBond do
                task.wait(0.05)
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do 
   if v.name:find("Ammo") or v.name:find("Bond") or v.name:find("Shells") then
local args = {
    [1] = v
}

game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_ActivateObject"):FireServer(unpack(args))

   end
end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Use Bandage ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoUseBandage = boolean
        
        if getgenv().AutoUseBandage then
            coroutine.wrap(function()
                while getgenv().AutoUseBandage do
                task.wait(0.5)
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bandage") then
game:GetService("Players").LocalPlayer.Character:FindFirstChild("Bandage").Use:FireServer()
end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Grab Bandage",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoGrabBandage = boolean
        
        if getgenv().AutoGrabBandage then
            coroutine.wrap(function()
                while getgenv().AutoGrabBandage do
                task.wait(0.05)
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do 
   if v.name:find("Bandage") then

local args = {
    [1] = v
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Tool"):WaitForChild("PickUpTool"):FireServer(unpack(args))

   end
end
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Sack Store(Equip Sack) ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoSackStore = boolean
        
        if getgenv().AutoSackStore then
            coroutine.wrap(function()
                while getgenv().AutoSackStore do
                task.wait(0.5)
for i,v in pairs(workspace.RuntimeItems:GetChildren()) do 
if v.Name ~= "Moneybag" and v.Name ~= "Rock" and v.Name ~= "Bandage" then
local args = {
    [1] = v
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StoreItem"):FireServer(unpack(args))
end
end
                end
            end)()
        end
    end
})

Section:Toggle({
    text = "Auto Swing (OP with two wep)",
    state = false,
    callback = function(boolean)
        getgenv().AutoSwing = boolean
        
        if getgenv().AutoSwing then
            coroutine.wrap(function()
                while getgenv().AutoSwing do
                    local player = game:GetService("Players").LocalPlayer
                    local character = player.Character
                    
                    if character then
                        -- Find all tools with SwingEvent
                        for _, tool in pairs(character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("SwingEvent") then
                                tool.SwingEvent:FireServer(player:GetMouse().Hit.LookVector)
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)()
        end
    end
})
Section:Toggle({
    text = "Auto Collect Money ",
    state = false, -- Default boolean
    callback = function(boolean)
        getgenv().AutoCollectMoney = boolean
        
        if getgenv().AutoCollectMoney then
            coroutine.wrap(function()
                while getgenv().AutoCollectMoney do
                task.wait(0.5)
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do 
    if v.Name == "Moneybag" then
        if v:FindFirstChild("MoneyBag") and v.MoneyBag:FindFirstChild("CollectPrompt") then
            fireproximityprompt(v.MoneyBag.CollectPrompt)
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
