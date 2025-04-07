queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
repeat task.wait() until game:IsLoaded()
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
game:GetService("TeleportService"):Teleport(game.PlaceId)
end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	if char then
		local anti = char:FindFirstChild("Anti")
		if anti then
			anti.Disabled = true
		end

		local jyAnti = char:FindFirstChild("JyAntiCheat.lua [READ]")
		if jyAnti then
			jyAnti:Destroy()
		end

		local localScript = char:FindFirstChild("LocalScript")
		if localScript then
			localScript:Destroy()
		end
	end

	local antiCheat = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("Anti-Cheat")
	if antiCheat then
		antiCheat:Destroy()
	end
end)


local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local tweenInfo = TweenInfo.new(
    2.3,
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.Out
)

local positions = {
    CFrame.new(93, 45, 74),
    CFrame.new(93, 89, 75),
    CFrame.new(93, 176, 75),
    CFrame.new(93, 247, 73),
    CFrame.new(100.16658, 259.7258, 73.9058075, 0, 0, 1, 0, 1, -0, -1, 0, 0),
}

-- Function to tween the character when it's alive
local function startTweenLoop(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    coroutine.wrap(function()
        while character and character.Parent do
            for _, cframe in ipairs(positions) do
                if not rootPart or not rootPart.Parent then return end
                local goal = {CFrame = cframe}
                local tween = TweenService:Create(rootPart, tweenInfo, goal)
                tween:Play()
                tween.Completed:Wait()
            end
            task.wait()
        end
    end)()
end

-- Start when the script runs
if player.Character then
    startTweenLoop(player.Character)
end

-- Also connect to CharacterAdded for respawns
player.CharacterAdded:Connect(function(char)
    startTweenLoop(char)
end)
while true do
task.wait(1)
game:GetService("ReplicatedStorage"):WaitForChild("SpinSystem"):WaitForChild("Remotes"):WaitForChild("SpinRemote"):FireServer()
task.wait(0.05)
game:GetService("ReplicatedStorage"):WaitForChild("SpinSystem"):WaitForChild("Remotes"):WaitForChild("BackTrackRemote"):FireServer()
end

    queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/freebobux.lua'))()")
