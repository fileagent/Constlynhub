local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "Trepasser"
})

local TabSection = Window:TabSection({
    text = "Trepasser"
})

local Tab = TabSection:Tab({
    text = "Main",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "This game SHIT."
})

Section:Button({
    text = "Button",
    callback = function()
        print("Clicked button")
    end,
})

-- Script for firing emergency exit proximity prompts using specific toggle format
local Players = game:GetService("Players")

-- Store all emergency exit proximity prompts
local proximityPrompts = {
    workspace.EmergencyExits["2"].EmergencyExit5.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits["3"].EmergencyExit6.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit2.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit3.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit4.Lever.Main.ProximityPrompt,
}

-- Variables for auto-firing system
local autoFireEnabled = false
local autoFireConnection = nil

-- Function to fire all proximity prompts with a delay to avoid lag
local function fireAllPrompts()
    for _, prompt in pairs(proximityPrompts) do
        -- Check if the proximity prompt exists before firing
        if prompt and prompt:IsA("ProximityPrompt") then
            -- Fire the proximity prompt
            fireproximityprompt(prompt)
            
            -- Wait a small amount to prevent lag (adjust as needed)
            task.wait(0.1)
        end
    end
end

-- Function to start auto-firing
local function startAutoFiring()
    if autoFireConnection then return end
    
    autoFireConnection = task.spawn(function()
        while autoFireEnabled do
            fireAllPrompts()
            task.wait(1) -- Wait between complete cycles
        end
    end)
end

-- Function to stop auto-firing
local function stopAutoFiring()
    if autoFireConnection then
        task.cancel(autoFireConnection)
        autoFireConnection = nil
    end
end

-- Using the toggle format you specified
Section:Toggle({
    text = "🚨 Auto Close All Doors",
    state = false, -- Default boolean
    callback = function(boolean)
        autoFireEnabled = boolean
        
        if autoFireEnabled then
            print("🚨 Auto-Fire Emergency Exits: ", boolean)
            startAutoFiring()
        else
            print("🚨 Auto-Fire Emergency Exits: ", boolean)
            stopAutoFiring()
        end
    end
})

-- Script for rapidly firing generator proximity prompt using toggle
local Players = game:GetService("Players")

-- Store the generator proximity prompt
local generatorPrompt = workspace.GameData.Generator.Generator.ProximityPrompt

-- Variables for auto-firing system
local autoFireEnabled = false
local autoFireConnection = nil

-- Function to fire the generator prompt very quickly
local function fireGeneratorPrompt()
    -- Check if the proximity prompt exists before firing
    if generatorPrompt and generatorPrompt:IsA("ProximityPrompt") then
        -- Fire the proximity prompt
        fireproximityprompt(generatorPrompt)
    end
end

-- Function to start rapid auto-firing
local function startAutoFiring()
    if autoFireConnection then return end
    
    autoFireConnection = task.spawn(function()
        while autoFireEnabled do
            fireGeneratorPrompt()
            -- Very short delay to prevent complete lockup
            task.wait(0.01) -- Super fast - adjust if needed
        end
    end)
end

-- Function to stop auto-firing
local function stopAutoFiring()
    if autoFireConnection then
        task.cancel(autoFireConnection)
        autoFireConnection = nil
    end
end

-- Using the toggle format you specified
Section:Toggle({
    text = "⚡ Auto Generator Fix",
    state = false, -- Default boolean
    callback = function(boolean)
        autoFireEnabled = boolean
        
        if autoFireEnabled then
            print("⚡ Generator Spam: ", boolean)
            startAutoFiring()
        else
            print("⚡ Generator Spam: ", boolean)
            stopAutoFiring()
        end
    end
})

-- Script to extend proximity prompt distance for doors
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")

-- List of proximity prompts to modify
local proximityPrompts = {
    -- Emergency exits
    workspace.EmergencyExits["2"].EmergencyExit5.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits["3"].EmergencyExit6.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit2.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit3.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit4.Lever.Main.ProximityPrompt,
    -- Generator
    workspace.GameData.Generator.Generator.ProximityPrompt
}

-- Function to extend proximity prompt distance
local function extendProximityDistance()
    for _, prompt in pairs(proximityPrompts) do
        if prompt and prompt:IsA("ProximityPrompt") then
            -- Set the max activation distance to 100 studs
            prompt.MaxActivationDistance = 100
            
            -- Optional: Make the prompt visible from further away too
            prompt.RequiresLineOfSight = false
            
            -- Optional: Make it easier to activate
            prompt.HoldDuration = 0.1
        end
    end
end

-- Script for instant proximity prompt activation
local Players = game:GetService("Players")

-- List of proximity prompts to modify
local proximityPrompts = {
    -- Emergency exits
    workspace.EmergencyExits["2"].EmergencyExit5.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits["3"].EmergencyExit6.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit2.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit3.Lever.Main.ProximityPrompt,
    workspace.EmergencyExits.EmergencyExit4.Lever.Main.ProximityPrompt,
    -- Generator
    workspace.GameData.Generator.Generator.ProximityPrompt
}

-- Function to fire proximity prompt instantly (using your provided function)
local function fireProximityPrompt(prompt, amount, skip)
    if prompt.ClassName == "ProximityPrompt" then
        amount = amount or 1
        local originalDuration = prompt.HoldDuration
        if skip then
            prompt.HoldDuration = 0
        end
        for i = 1, amount do
            prompt:InputHoldBegin()
            if not skip then
                wait(prompt.HoldDuration)
            end
            prompt:InputHoldEnd()
        end
        prompt.HoldDuration = originalDuration
    else
        error("Expected a ProximityPrompt object")
    end
end

-- Variables for auto-firing system
local autoFireEnabled = false
local autoFireConnection = nil

-- Function to fire all prompts instantly
local function fireAllPromptsInstantly()
    for _, prompt in pairs(proximityPrompts) do
        if prompt and prompt:IsA("ProximityPrompt") then
            -- Fire the proximity prompt instantly (amount=1, skip=true)
            fireProximityPrompt(prompt, 1, true)
            
            -- Small delay to prevent lag
            task.wait(0.1)
        end
    end
end

-- Function to start auto-firing
local function startAutoFiring()
    if autoFireConnection then return end
    
    autoFireConnection = task.spawn(function()
        while autoFireEnabled do
            fireAllPromptsInstantly()
            task.wait(0.5) -- Wait between cycles
        end
    end)
end

-- Function to stop auto-firing
local function stopAutoFiring()
    if autoFireConnection then
        task.cancel(autoFireConnection)
        autoFireConnection = nil
    end
end

-- Using the toggle format you specified
Section:Toggle({
    text = "⚡ Instant Interact",
    state = false, -- Default boolean
    callback = function(boolean)
        autoFireEnabled = boolean
        
        if autoFireEnabled then
            print("⚡ Instant Proximity: ", boolean)
            startAutoFiring()
        else
            print("⚡ Instant Proximity: ", boolean)
            stopAutoFiring()
        end
    end
})

-- Script to rapidly teleport to all proximity prompts
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Ensure we get the HumanoidRootPart when character respawns
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- List of proximity prompts and their parent objects
local teleportTargets = {
    -- Emergency exits
    workspace.EmergencyExits["2"].EmergencyExit5.Lever.Main,
    workspace.EmergencyExits["3"].EmergencyExit6.Lever.Main,
    workspace.EmergencyExits.EmergencyExit2.Lever.Main,
    workspace.EmergencyExits.EmergencyExit3.Lever.Main,
    workspace.EmergencyExits.EmergencyExit4.Lever.Main,
    -- Generator
    workspace.GameData.Generator.Generator
}

-- Function to fire proximity prompt
local function fireProximityPrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        fireproximityprompt(prompt)
    end
end

-- Teleport function
local function teleportAndActivate(target)
    if not target or not HumanoidRootPart then return end
    
    -- Get position from target
    local teleportPosition = target.Position
    
    -- Offset slightly to avoid getting stuck in objects
    teleportPosition = teleportPosition + Vector3.new(0, 2, 0)
    
    -- Teleport the player
    HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
    
    -- Try to find and fire the proximity prompt
    local prompt = target:FindFirstChildOfClass("ProximityPrompt")
    if not prompt then
        -- Look for prompt in children
        for _, child in pairs(target:GetChildren()) do
            prompt = child:FindFirstChildOfClass("ProximityPrompt")
            if prompt then break end
        end
    end
    
    -- Fire the prompt if found
    if prompt then
        task.wait(0.1) -- Brief wait to ensure teleport completes
        fireProximityPrompt(prompt)
    end
end

-- Variables for auto-teleporting
local autoTeleportEnabled = false
local autoTeleportConnection = nil

-- Function to rapidly teleport to all targets
local function rapidTeleportToAll()
    if autoTeleportConnection then return end
    
    autoTeleportConnection = task.spawn(function()
        while autoTeleportEnabled do
            for _, target in ipairs(teleportTargets) do
                if target then
                    teleportAndActivate(target)
                    task.wait(0.1) -- Ultra-fast 0.1 second delay
                end
            end
        end
    end)
end

-- Function to stop auto-teleporting
local function stopTeleporting()
    if autoTeleportConnection then
        task.cancel(autoTeleportConnection)
        autoTeleportConnection = nil
    end
end

-- Toggle for rapid teleporting
Section:Toggle({
    text = "⚡ Rapid TP & Activate All",
    state = false, -- Default boolean
    callback = function(boolean)
        autoTeleportEnabled = boolean
        
        if autoTeleportEnabled then
            print("⚡ Rapid Teleport: ", boolean)
            rapidTeleportToAll()
        else
            print("⚡ Rapid Teleport: ", boolean)
            stopTeleporting()
        end
    end
})

-- Function to fire a specific prompt
local function fireSpecificPrompt(promptObject)
    if promptObject and promptObject:IsA("ProximityPrompt") then
        fireProximityPrompt(promptObject, 1, true)
    end
end

-- Example: Fire generator only
-- Uncomment the line below to test firing just the generator
-- fireSpecificPrompt(workspace.GameData.Generator.Generator.ProximityPrompt)

-- Uncomment the next line if you want to apply the change immediately when the script runs
-- applyExtendedDistanceOnce()
