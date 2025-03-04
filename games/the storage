local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()

-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "The Storage"
})

local TabSection = Window:TabSection({
    text = "Main"
})

local Tab = TabSection:Tab({
    text = "Main",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "✨ Main ✨"
})

-- Variables and Constants
local keyFinderEnabled = false
local autoPromptEnabled = false
local teleporterEnabled = false
local promptLoop = nil
local teleporterLoop = nil
local DETECTION_RADIUS = 10
local proximityPrompts = {}
local storageIndices = {}
local healthThreshold = 30 -- Default value for health threshold

-- Define safe position using the provided coordinates
local safePosition = CFrame.new(75.293251, 38.2000046, -8.09772873, 0.226353019, -1.78018684e-08, 0.974045336, 
                              -5.60959901e-09, 1, 1.95798062e-08, -0.974045336, -9.89595161e-09, 0.226353019)

-- Initialize storage indices
local function initializeStorageIndices()
    storageIndices = {}
    pcall(function()
        for i, _ in pairs(workspace.Storages:GetChildren()) do
            table.insert(storageIndices, i)
        end
    end)
   
    if #storageIndices == 0 then
        for i = 1, 50 do -- Default range if storages not found
            table.insert(storageIndices, i)
        end
    end
    print("📦 Found " .. #storageIndices .. " storage indices")
end

-- Collect all proximity prompts in the game
local function collectProximityPrompts()
    proximityPrompts = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            table.insert(proximityPrompts, obj)
        end
    end
    print("🔍 Found " .. #proximityPrompts .. " proximity prompts")
   
    -- Set up connection to detect new proximity prompts
    game.DescendantAdded:Connect(function(obj)
        if obj:IsA("ProximityPrompt") then
            table.insert(proximityPrompts, obj)
        end
    end)
end

-- Function to check if an object is a piano
local function isPiano(obj)
    -- Check if the object is named Piano
    if obj.Name == "Piano" then
        return true
    end
   
    -- Check if the object is in a piano path
    local parent = obj.Parent
    while parent do
        if parent.Name == "Piano" then
            return true
        end
        parent = parent.Parent
    end
   
    -- Additional check for the specific path mentioned
    local success, result = pcall(function()
        for _, storage in pairs(workspace.Storages:GetChildren()) do
            if storage.Contents and storage.Contents.Objects then
                for _, item in pairs(storage.Contents.Objects:GetChildren()) do
                    if item.Name == "Piano" and (item:IsDescendantOf(obj) or obj:IsDescendantOf(item)) then
                        return true
                    end
                end
            end
        end
        return false
    end)
   
    return success and result or false
end

-- Initialize data on script start
collectProximityPrompts()
initializeStorageIndices()

-- Key finder toggle
Section:Toggle({
    text = "🔑 Auto Find Keys 🔑",
    state = false,
    callback = function(state)
        keyFinderEnabled = state
       
        if keyFinderEnabled then
            -- Start the key finder loop
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
           
            -- Create a function to collect keys
            local function collectKeys()
                if not keyFinderEnabled then return end
               
                -- Store original position
                local originalPosition = humanoidRootPart.Position
               
                -- Search for keys in workspace
                for _, object in pairs(workspace:GetDescendants()) do
                    if not keyFinderEnabled then break end
                   
                    -- Check if the object name contains "Key" and is NOT a piano
                    if object:IsA("BasePart") and string.find(object.Name, "Key") and not isPiano(object) then
                        print("🔑 Found key: " .. object.Name)
                       
                        -- Teleport to the key
                        humanoidRootPart.CFrame = CFrame.new(object.Position)
                       
                        -- Wait 1 second
                        wait(1)
                       
                        -- Teleport back to the original position
                        humanoidRootPart.CFrame = CFrame.new(originalPosition)
                       
                        -- Wait a brief moment before searching for the next key
                        wait(0.5)
                    end
                end
               
                -- Wait before searching again to prevent excessive resource usage
                if keyFinderEnabled then
                    wait(5)
                    print("🔎 Searching for keys again...")
                    collectKeys() -- Recursively call the function
                end
            end
           
            spawn(collectKeys) -- Start the key collection process in a new thread
            print("✅ Key Finder Enabled! (Ignoring Piano Keys)")
        else
            print("❌ Key Finder Disabled!")
        end
    end
})

Section:Toggle({
    text = "🛡️ Auto Safe When Low 🛡️",
    state = false,
    callback = function(state)
        teleportEnabled = state
       
        if teleportEnabled then
            -- Initialize
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local connection
           
            -- Function to handle low health
            local function checkHealth()
                if not teleportEnabled then return end
               
                if humanoid.Health <= healthThreshold then
                    print("⚠️ Health Low: " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth)
                    print("🔄 Teleporting to safe location...")
                   
                    -- Get HumanoidRootPart (needed for teleport)
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        -- Teleport to safe position
                        humanoidRootPart.CFrame = safePosition
                        print("✅ Teleported to safety!")
                       
                        -- Cooldown to prevent teleport spam
                        wait(3)
                    else
                        print("❌ Couldn't teleport - HumanoidRootPart not found")
                    end
                end
            end
           
            -- Connect health changed event
            connection = humanoid.HealthChanged:Connect(function()
                checkHealth()
            end)
           
            -- Handle character death/respawn
            player.CharacterAdded:Connect(function(newCharacter)
                if not teleportEnabled then return end
               
                character = newCharacter
                humanoid = newCharacter:WaitForChild("Humanoid")
               
                -- Reconnect health changed event for new character
                if connection then connection:Disconnect() end
                connection = humanoid.HealthChanged:Connect(function()
                    checkHealth()
                end)
            end)
           
            -- Start periodic check loop as backup
            teleportLoop = task.spawn(function()
                while teleportEnabled do
                    checkHealth()
                    wait(0.5)
                end
            end)
           
            print("✅ Low Health Teleport Enabled! Threshold: " .. healthThreshold .. " HP")
        else
            -- Clean up
            if connection then
                connection:Disconnect()
                connection = nil
            end
           
            if teleportLoop then
                task.cancel(teleportLoop)
                teleportLoop = nil
            end
           
            print("❌ Low Health Teleport Disabled!")
        end
    end
})

Section:Toggle({
    text = "🔓 Auto Key/Storage 🔓",
    state = false,
    callback = function(state)
        autoPromptEnabled = state
       
        if autoPromptEnabled then
            -- Initialize player and character
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
           
            -- Character respawn handling
            local charConnection
            charConnection = player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            end)
           
            -- Start the prompt checking loop
            promptLoop = task.spawn(function()
                while autoPromptEnabled do
                    for _, prompt in ipairs(proximityPrompts) do
                        if not autoPromptEnabled then break end
                       
                        -- Check if prompt and parent still exist
                        if prompt and prompt.Parent and prompt:IsA("ProximityPrompt") then
                            local promptPart = prompt.Parent
                           
                            -- Only process BaseParts (which have Position)
                            if promptPart:IsA("BasePart") then
                                -- Skip distance check if character is dead
                                if not (character and humanoidRootPart and humanoidRootPart.Parent) then
                                    break
                                end
                               
                                local distance = (promptPart.Position - humanoidRootPart.Position).Magnitude
                                if distance <= DETECTION_RADIUS then
                                    fireproximityprompt(prompt)
                                    task.wait()
                                end
                            end
                        end
                    end
                    task.wait(0.1) -- Reduced check frequency
                end
               
                -- Clean up
                if charConnection then
                    charConnection:Disconnect()
                end
            end)
           
            print("✅ Auto Storage Opener Enabled!")
        else
            if promptLoop then
                task.cancel(promptLoop)
                promptLoop = nil
            end
            print("❌ Auto Storage Opener Disabled!")
        end
    end
})

Section:Toggle({
    text = "🚀 Auto Teleport to Storages 🚀",
    state = false,
    callback = function(state)
        teleporterEnabled = state
       
        if teleporterEnabled then
            -- Initialize player and character
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
           
            -- Character respawn handling
            local charConnection
            charConnection = player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            end)
           
            -- Function to teleport to storages
            local function teleportToStorages()
                local index = 1
               
                while teleporterEnabled do
                    if not character or not humanoidRootPart or not humanoidRootPart.Parent then
                        wait(1) -- Wait for character to respawn
                        character = player.Character
                        if character then
                            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                        end
                        continue
                    end
                   
                    -- Get current storage to teleport to
                    local storageIndex = storageIndices[index]
                    local success, storage = pcall(function()
                        return workspace.Storages:GetChildren()[storageIndex]
                    end)
                   
                    if success and storage and not storage:GetAttribute("Owner") then
                        print("📦 Teleporting to Storage #" .. storageIndex)
                       
                        -- Attempt to teleport to storage
                        pcall(function()
                            -- Try to find a primary part or any part to teleport to
                            local targetPart
                           
                            if storage.PrimaryPart then
                                targetPart = storage.PrimaryPart
                            else
                                -- Find any BasePart in the storage
                                for _, part in pairs(storage:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        targetPart = part
                                        break
                                    end
                                end
                            end
                           
                            if targetPart then
                                humanoidRootPart.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0))
                            end
                        end)
                    else
                        print("❌ Failed to access Storage #" .. storageIndex)
                    end
                   
                    -- Move to next storage in the list
                    index = index + 1
                    if index > #storageIndices then
                        index = 1 -- Loop back to the first storage
                    end
                   
                    -- Wait for cooldown
                    local countdown = 4
                    while countdown > 0 and teleporterEnabled do
                        print("⏱️ Next teleport in " .. countdown .. " seconds")
                        wait(1)
                        countdown = countdown - 1
                    end
                end
                
                -- Clean up
                if charConnection then
                    charConnection:Disconnect()
                end
            end
           
            -- Start the teleport loop in a new thread
            teleporterLoop = task.spawn(teleportToStorages)
            print("✅ Storage Teleporter Enabled!")
        else
            -- Clean up the teleporter loop
            if teleporterLoop then
                task.cancel(teleporterLoop)
                teleporterLoop = nil
            end
            print("❌ Storage Teleporter Disabled!")
        end
    end
})

-- Create a global variable to control teleport state
_G.teleporterEnabled = false
-- Create a global variable for teleport speed
_G.teleportSpeed = 1

-- Add slider for teleport speed


-- Add toggle for teleport functionality
Section:Toggle({
    text = "🚀 Auto Teleport to All Loot Items 🚀",
    state = false,
    callback = function(state)
        -- Set the global teleporter state
        _G.teleporterEnabled = state
        
        if state then
            -- Initialize player and character
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            
            -- Character respawn handling
            local charConnection
            charConnection = player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            end)
            
            -- Function to find all loot items in all storages
            local function findAllLootItems()
                local lootItems = {}
                
                for i, storage in pairs(workspace.Storages:GetChildren()) do
                    -- Check if storage has Contents.Loot
                    pcall(function()
                        if storage.Contents and storage.Contents:FindFirstChild("Loot") then
                            -- Get all items inside Loot
                            for _, lootItem in pairs(storage.Contents.Loot:GetChildren()) do
                                table.insert(lootItems, {
                                    item = lootItem,
                                    storageIndex = i,
                                    name = lootItem.Name
                                })
                            end
                        end
                    end)
                end
                
                return lootItems
            end
            
            -- Function to teleport to loot items
            local function teleportToLootItems()
                while _G.teleporterEnabled do
                    if not _G.teleporterEnabled then 
                        break 
                    end
                    
                    if not character or not humanoidRootPart or not humanoidRootPart.Parent then
                        wait(1) -- Wait for character to respawn
                        character = player.Character
                        if character then
                            humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                        end
                        continue
                    end
                    
                    -- Find all loot items
                    local lootItems = findAllLootItems()
                    print("🔍 Found " .. #lootItems .. " loot items across all storages")
                    
                    -- Teleport to each loot item
                    for i, lootData in ipairs(lootItems) do
                        if not _G.teleporterEnabled then 
                            print("⛔ Teleporter disabled - stopping loop")
                            break 
                        end
                        
                        if not character or not humanoidRootPart or not humanoidRootPart.Parent then
                            break -- Break and restart the main loop if character is lost
                        end
                        
                        local lootItem = lootData.item
                        
                        -- Attempt to teleport to loot item
                        pcall(function()
                            -- Try to find a part to teleport to
                            local targetPart
                            
                            if lootItem:IsA("BasePart") then
                                targetPart = lootItem
                            elseif lootItem:IsA("Model") and lootItem.PrimaryPart then
                                targetPart = lootItem.PrimaryPart
                            else
                                -- Find any BasePart in the loot item
                                for _, part in pairs(lootItem:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        targetPart = part
                                        break
                                    end
                                end
                            end
                            
                            if targetPart then
                                print("📦 Teleporting to: " .. lootData.name .. " (Storage #" .. lootData.storageIndex .. ") - Item " .. i .. "/" .. #lootItems)
                                humanoidRootPart.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0))
                                
                                -- Wait based on teleport speed setting
                                wait(_G.teleportSpeed)
                            end
                        end)
                    end
                    
                    -- Check again if teleporter was disabled
                    if not _G.teleporterEnabled then 
                        print("⛔ Teleporter disabled after cycle - stopping loop")
                        break 
                    end
                    
                    -- Wait before refreshing loot list (shorter wait for faster refreshes)
                    wait(1)
                end
                
                -- Clean up
                if charConnection then
                    charConnection:Disconnect()
                    charConnection = nil
                end
                
                print("🛑 Teleport loop terminated")
            end
            
            -- Use coroutine instead of spawn for better control
            coroutine.wrap(function()
                print("✅ Loot Teleporter Enabled!")
                teleportToLootItems()
            end)()
            
        else
            -- This will properly stop the teleporter loop
            _G.teleporterEnabled = false
            print("❌ Loot Teleporter Disabled!")
        end
    end
})

Section:Slider({
    text = "⚡ Teleport Speed",
    min = 0.1,
    max = 3,
    float = 0.1,
    default = 1,
    callback = function(value)
        _G.teleportSpeed = value
        print("🔄 Teleport Speed set to: " .. value .. " seconds")
    end
})

Section:Slider({
    text = "🛡️ Health Safe",
    min = 1,
    max = 100,
    default = 30,
    callback = function(value)
        healthThreshold = value
        print("Health threshold set to: " .. value .. " HP")
    end
})

Section:Slider({
    text = "🔑Storage Detection",
    min = 5,
    max = 30,
    default = 10,
    callback = function(number)
        DETECTION_RADIUS = number
        print("Detection radius set to: " .. number)
    end
})
