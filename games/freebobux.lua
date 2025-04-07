repeat task.wait() until game:IsLoaded()

local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

-- Anti error message teleport loop
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Anti-cheat remover
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

    local antiCheat = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("Anti-Cheat")
    if antiCheat then antiCheat:Destroy() end
end)

-- Tween loop logic
local tweenInfo = TweenInfo.new(
    2,
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.Out
)

local positions = {
    CFrame.new(93, 45, 74),
    CFrame.new(93, 89, 75),
    CFrame.new(93, 176, 75),
    CFrame.new(93, 247, 73),
    CFrame.new(100.16658, 259.7258, 73.9058075)
}

local function startTweenLoop(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    coroutine.wrap(function()
        while character and character.Parent do
            for _, cframe in ipairs(positions) do
                if not rootPart or not rootPart.Parent then return end
                local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = cframe})
                tween:Play()
                tween.Completed:Wait()
            end
            task.wait()
        end
    end)()
end

if LocalPlayer.Character then
    startTweenLoop(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(startTweenLoop)

-- Spin + BackTrack loop
coroutine.wrap(function()
    while true do
        task.wait(1)
        local spinRemote = ReplicatedStorage:WaitForChild("SpinSystem"):WaitForChild("Remotes"):WaitForChild("SpinRemote")
        local backtrackRemote = ReplicatedStorage:WaitForChild("SpinSystem"):WaitForChild("Remotes"):WaitForChild("BackTrackRemote")

        spinRemote:FireServer()
        task.wait(0.05)
        backtrackRemote:FireServer()
    end
end)()

-- Queue teleport on teleportation
if queueteleport then
    queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/freebobux.lua'))()")
end
