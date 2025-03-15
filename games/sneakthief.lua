local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "Sneak Thief"
})

local TabSection = Window:TabSection({
    text = "Sneak Thief"
})

local Tab = TabSection:Tab({
    text = "Main",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "Main"
})

Section:Button({
    text = "Steal All",
    callback = function()
-- Configuration

local maxAttempts = 400          -- Maximum number of steal attempts before pausing
local pauseTime = 3             -- Time to pause after reaching max attempts (in seconds)

local stealCount = 0
local successCount = 0
local failCount = 0

local function stealObject(object)
    if object and (object:IsA("BasePart") or object:IsA("MeshPart") or object:IsA("Part")) then
        local args = {
            [1] = object
        }
        
       
        local success, result = pcall(function()
            return game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("InteractionEvents"):WaitForChild("Steal"):InvokeServer(unpack(args))
        end)
        
        
        if success then
            successCount = successCount + 1
            print("Successfully stole:", object:GetFullName())
        else
            failCount = failCount + 1
            warn("Failed to steal:", object:GetFullName(), "Error:", result)
        end
        
        stealCount = stealCount + 1

        if stealCount % maxAttempts == 0 then
            print("Pausing for", pauseTime, "seconds after", stealCount, "attempts")
            print("Stats: Success:", successCount, "Failed:", failCount)
            wait(pauseTime)
        else
            
            task.wait()
        end
    end
end

local stealables = workspace:FindFirstChild("Stealables")
if not stealables then
    warn("Could not find 'Stealables' folder in workspace")
    return
end

print("Starting steal operation...")
for _, object in pairs(stealables:GetDescendants()) do
    stealObject(object)
end

print("Steal operation complete!")
print("Final Stats: Total attempts:", stealCount, "Success:", successCount, "Failed:", failCount)
    end,
})
