repeat task.wait() until game:IsLoaded()

local queueTeleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Standart = require(ReplicatedStorage:WaitForChild("StandartValues"))
Standart["maxSpeed"] = math.huge
Standart["kickReason"] = "discord.gg/A47xp4crDe"
Standart["maxJumpPower"] = math.huge
Standart["allowGyro"] = true
Standart["canNoclip"] = true
Standart["allowRootAnchor"] = true
Standart["canFly"] = true

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local anti = char:FindFirstChild("Anti")
        if anti then anti.Disabled = true end

        local jyAnti = char:FindFirstChild("JyAntiCheat.lua [READ]")
        if jyAnti then jyAnti:Destroy() end

        local localScript = char:FindFirstChild("LocalScript")
        if localScript then localScript:Destroy() end
    end

    local ps = LocalPlayer:FindFirstChild("PlayerScripts")
    if ps then
        local ac = ps:FindFirstChild("Anti-Cheat")
        if ac then ac:Destroy() end
    end
end)
-- unused Tween Info(OLDEST)
--[[
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local positions = {
    CFrame.new(93, 45, 74),
    CFrame.new(93, 89, 75),
    CFrame.new(93, 176, 75),
    CFrame.new(93, 247, 73),
    CFrame.new(100.16658, 259.7258, 73.9058075)
}
]]
local function Autofarm(character)
    coroutine.wrap(function()
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if not rootPart or not humanoid then return end

        local alive = true
        humanoid.Died:Connect(function()
            alive = false
        end)

        while alive and character and character.Parent do
            pcall(function()
                for _, v in ipairs(workspace:WaitForChild("TeleportPads"):GetChildren()) do
                    if v:IsA("BasePart") and v.Name == "obbyback" and v.BrickColor ~= BrickColor.new("Bright red") then
                        rootPart.CFrame = CFrame.new(v.Position)
                        task.wait(0.01)
                    end
                end
            end)
            task.wait(0.1)
        end
    end)()
end

if Players.LocalPlayer.Character then
    Autofarm(Players.LocalPlayer.Character)
end
Players.LocalPlayer.CharacterAdded:Connect(Autofarm)


--[[coroutine.wrap(function()
    while true do
        task.wait(3)
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = 0
            end
        end)
    end
end)()]]

coroutine.wrap(function()
    local spinRemote = ReplicatedStorage:WaitForChild("SpinSystem"):WaitForChild("Remotes"):WaitForChild("SpinRemote")
    local backtrackRemote = ReplicatedStorage:WaitForChild("SpinSystem"):WaitForChild("Remotes"):WaitForChild("BackTrackRemote")

    while true do
        task.wait(0.01)
        pcall(function()
            spinRemote:FireServer()
            backtrackRemote:FireServer()
        end)
    end
end)()

if queueTeleport then
    queueTeleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/freebobux.lua'))()")
end
