local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/source.lua"))()
-- Toggle UI: Library:Toggle()

local Window = Library:Window({
    text = "Hybrid Cafe"
})

local TabSection = Window:TabSection({
    text = "Main"
})

local Tab = TabSection:Tab({
    text = "Main",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "trust me this game is shit 😭"
})

Section:Button({
    text = "Inf Stamina 🤑",
    callback = function()
game:GetService("Players").LocalPlayer:SetAttribute("InfStamina",true) 
    end,
})

Section:Toggle({
    text = "🔥 Attack All Entities [BROOM] 🔥",
    state = false, -- Default boolean
    callback = function(boolean)
        -- Variables for toggle state
        _G.AttackEntities = boolean
        
        -- Toggle function
        if _G.AttackEntities then
            -- Start attacking all entities
            _G.AttackConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local entities = workspace:FindFirstChild("Entities")
                if not entities then return end
                
                -- Attack all entities in all folders
                for _, entityFolder in pairs(entities:GetChildren()) do
                    if entityFolder:IsA("Folder") then
                        for _, entity in pairs(entityFolder:GetChildren()) do
                            if entity and entity:IsA("Model") then
                                local args = {
                                    [1] = entity
                                }
                                
                                -- Fire the remote to attack
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("MeleeHitscan"):FireServer(unpack(args))
                            end
                        end
                    end
                end
            end)
            
            -- Visual feedback
            print("🔥 Entity Attacker: ENABLED 🔥")
        else
            -- Stop attacking
            if _G.AttackConnection then
                _G.AttackConnection:Disconnect()
                _G.AttackConnection = nil
            end
            
            -- Visual feedback
            print("❄️ Entity Attacker: DISABLED ❄️")
        end
    end
})

Section:Toggle({
    text = "🍪 Auto Perfect Snacks 🎯",
    state = false, -- Default boolean
    callback = function(boolean)
        -- Variables for toggle state
        _G.AutoPerfect = boolean
        
        -- Toggle function
        if _G.AutoPerfect then
            -- Start auto perfect
            _G.PerfectConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local args = {
                    [1] = workspace:WaitForChild("SnackStation"):WaitForChild("Oven"),
                    [2] = 0.5
                }
                
                -- Fire the remote for perfect timing
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SendOvenPrecision"):FireServer(unpack(args))
            end)
            
            -- Visual feedback
            print("✨ Auto Perfect: ENABLED ✨")
        else
            -- Stop auto perfect
            if _G.PerfectConnection then
                _G.PerfectConnection:Disconnect()
                _G.PerfectConnection = nil
            end
            
            -- Visual feedback
            print("❌ Auto Perfect: DISABLED ❌")
        end
    end
})

Section:Toggle({
    text = "🔧 Auto Fix All 🛠️",
    state = false, -- Default boolean
    callback = function(boolean)
        -- Variables for toggle state
        _G.AutoFixAll = boolean
        
        -- Toggle function
        if _G.AutoFixAll then
            -- Start auto fix
            _G.FixAllConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("ReplicatedStorage").GameValues.AC_Broken.Value then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("AC_Fix"):FireServer()
                elseif game:GetService("ReplicatedStorage").GameValues.MachinesBroken.Value then
                    game:GetService("ReplicatedStorage").Remotes.Machine_Fix:FireServer()
                end
            end)
            
            -- Visual feedback
            print("🛠️ Auto Fix All: ENABLED 🛠️")
        else
            -- Stop auto fix
            if _G.FixAllConnection then
                _G.FixAllConnection:Disconnect()
                _G.FixAllConnection = nil
            end
            
            -- Visual feedback
            print("❌ Auto Fix All: DISABLED ❌")
        end
    end
})

-- Define the toggle function
local function AutoToppingFunction(boolean)
    -- Variable for toggle state
    _G.AutoTopping = boolean
    
    -- Toggle function
    if _G.AutoTopping then
        -- Start auto topping
        _G.ToppingConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if workspace.TopStation.TopMachine.CurrentCup.Value ~= nil then
                for _,Creamer in pairs(workspace.TopStation.TopMachine.CreamButtons:GetChildren()) do 
                    for _,Cream in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.TicketFrame.TicketHolder:GetChildren()) do
                        if Cream.TopSection.Cream.Image == Creamer.SurfaceGui.ImageLabel.Image then
                            fireclickdetector(Creamer:FindFirstChildWhichIsA("ClickDetector"))
                        end
                    end
                end

                for _,Syrup in pairs(workspace.TopStation.TopMachine.SyrupButtons:GetChildren()) do 
                    for _,SyrupImage in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.TicketFrame.TicketHolder:GetChildren()) do
                        if SyrupImage.TopSection.Syrup.Image == Syrup.SurfaceGui.ImageLabel.Image then
                            fireclickdetector(Syrup:FindFirstChildWhichIsA("ClickDetector"))
                        end
                    end
                end

                for _,Topping in pairs(workspace.TopStation.TopMachine.ToppingButtons:GetChildren()) do 
                    for _,TicketHolder in pairs(game:GetService("Players").LocalPlayer.PlayerGui.GameUI.TicketFrame.TicketHolder:GetChildren()) do
                        for _,ToppingSelect in pairs(TicketHolder.ToppingSection:GetChildren()) do 
                            if ToppingSelect:IsA("ImageLabel") and ToppingSelect.Image == Topping.SurfaceGui.ImageLabel.Image then
                                fireclickdetector(Topping:FindFirstChildWhichIsA("ClickDetector"))
                            end
                        end
                    end
                end

                task.wait()
                fireclickdetector(workspace.TopStation.TopMachine.FinishButton:FindFirstChildWhichIsA("ClickDetector"))
            end
        end)
        
        -- Visual feedback
        print("🧁 Auto Topping: ENABLED 🧁")
    else
        -- Stop auto topping
        if _G.ToppingConnection then
            _G.ToppingConnection:Disconnect()
            _G.ToppingConnection = nil
        end
        
        -- Visual feedback
        print("❌ Auto Topping: DISABLED ❌")
    end
end

Section:Toggle({
    text = "🖥️ Auto Order Claim",
    state = false,
    callback = function(boolean)
        _G.AutoComputer = boolean
        
        if _G.AutoComputer then
            _G.ComputerConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local prompt = workspace.Cafe.Computer.Screen.Attachment.ProximityPrompt
                if prompt then
                    fireproximityprompt(prompt, 1, true) -- Properly fire the prompt with required arguments
                end
                task.wait(0.5)
            end)
            print("🖥️ Auto Computer: ENABLED")
        else
            if _G.ComputerConnection then
                _G.ComputerConnection:Disconnect()
                _G.ComputerConnection = nil
            end
            print("❌ Auto Computer: DISABLED")
        end
    end
})

local isKillAuraEnabled = false

Section:Toggle({
    text = "⚔️ Kill Aura",
    state = false,
    callback = function(state)
        isKillAuraEnabled = state
        
        if isKillAuraEnabled then
            _G.KillAuraConnection = game:GetService("RunService").Heartbeat:Connect(function()
                for i,v in pairs(workspace.Entities:GetChildren()) do
                    local args = {[1] = v}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("MeleeHitscan"):FireServer(unpack(args))
                end
                task.wait(0.1) -- Add small delay to prevent overwhelming
            end)
            print("⚔️ Kill Aura: ENABLED") 
        else
            if _G.KillAuraConnection then
                _G.KillAuraConnection:Disconnect()
                _G.KillAuraConnection = nil
            end
            print("❌ Kill Aura: DISABLED")
        end
    end
})


-- Usage with your GUI
Section:Toggle({
    text = "🧁 Auto Instant Topping 🧁",
    state = false,
    callback = AutoToppingFunction
})

