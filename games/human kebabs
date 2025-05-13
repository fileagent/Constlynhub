local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
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
    text = "Claim Party Badge",
    callback = function()
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure character and HumanoidRootPart exist
if character and character:FindFirstChild("HumanoidRootPart") then
    character.HumanoidRootPart.CFrame = CFrame.new(
        -1.04524517, 220.996063, -657.773621, 
        0.886734128, -1.59906588e-09, -0.462279767, 
        4.95522521e-08, 1, 9.159087e-08, 
        0.462279767, -1.04123757e-07, 0.886734128
    )
end
    end,
})


Section:Button({
    text = "Safe Place [FOR KILL ALL BC SOMEONE CAN EAT U]",
    callback = function()
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Ensure character and HumanoidRootPart exist
if character and character:FindFirstChild("HumanoidRootPart") then
    character.HumanoidRootPart.CFrame = CFrame.new(
      4.18335724, -457.000031, 281.962158, 0.993592262, 5.86198734e-09, 0.113023929, -5.92766058e-09, 1, 2.44997717e-10, -0.113023929, -9.13395359e-10, 0.993592262
    )
end
    end,
})

---- Section:Toggle({
 ----   text = "Toggle",
 ----   state = false, -- Default boolean
 ----   callback = function(boolean)
 ----       print("Toggle current: ",boolean)
 ----   end
----})

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteKill = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("SkewerHit")
local remoteEat = replicatedStorage:WaitForChild("Remotes"):WaitForChild("Client"):WaitForChild("EatSkewer")

local toggled = false

Section:Toggle({
    text = "💀 Kill & Eat All 🍖",
    state = false,
    callback = function(state)
        toggled = state
        if toggled then
            task.spawn(function() -- Runs the loop in a separate thread
                while toggled do
                    for _, player in ipairs(players:GetPlayers()) do
                        if player ~= players.LocalPlayer then -- Exclude yourself
                            remoteKill:FireServer(player) -- Attack player
                        end
                    end
                    remoteEat:FireServer() -- Eat skewer after attacking everyone
                    task.wait(0.5) -- Prevent excessive firing
                end
            end)
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local toggled = false

local function getRoot(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

Section:Toggle({
    text = "💥 Fling & TP All 🔄",
    state = false,
    callback = function(state)
        toggled = state
        if toggled then
            task.spawn(function()
                while toggled do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= localPlayer and player.Character then
                            local targetRoot = getRoot(player.Character)
                            local myCharacter = localPlayer.Character
                            local myRoot = getRoot(myCharacter)

                            if targetRoot and myRoot then
                                -- Teleport to player
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -3)

                                RunService.Heartbeat:Wait()
                                local vel, movel = myRoot.Velocity, 0.1

                                -- Wait for character and root to be valid
                                while not (myCharacter and myCharacter.Parent and myRoot and myRoot.Parent) do
                                    RunService.Heartbeat:Wait()
                                    myCharacter = localPlayer.Character
                                    myRoot = getRoot(myCharacter)
                                end

                                -- Fling mechanics
                                vel = myRoot.Velocity
                                myRoot.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

                                RunService.RenderStepped:Wait()
                                if myCharacter and myCharacter.Parent and myRoot and myRoot.Parent then
                                    myRoot.Velocity = vel
                                end

                                RunService.Stepped:Wait()
                                if myCharacter and myCharacter.Parent and myRoot and myRoot.Parent then
                                    myRoot.Velocity = vel + Vector3.new(0, movel, 0)
                                    movel = movel * -1
                                end

                                task.wait(0.2) -- Wait before moving to the next player
                            end
                        end
                    end
                end
            end)
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
