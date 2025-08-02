local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function getplot()
    return LocalPlayer.Team
end

local playerplots = getplot().Name

function getallteddy()
    for _, v in pairs(workspace.Plots:GetChildren()) do 
        if v.Name == playerplots then 
            for _, Collectibles in pairs(v.Collectibles:GetChildren()) do 
                print("Collecting:", Collectibles.Name)
                
                local mainPart = Collectibles:FindFirstChild("Main")
                if mainPart then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, mainPart, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, mainPart, 1)
                end
            end
        end
    end
end

function autoplay(mode, wave, saves)
    local waveNumber = tonumber(wave)
    if not waveNumber then
        warn("Invalid wave number: " .. tostring(wave))
        return
    end
    
    game:GetService("ReplicatedStorage"):WaitForChild("ClientServerRemotes"):WaitForChild("LoadBuild"):FireServer(saves)
    task.wait(0.1)
    
    game:GetService("ReplicatedStorage"):WaitForChild("ClientServerRemotes"):WaitForChild("StartWave"):FireServer(waveNumber, mode, false, true)
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Neverlose/source.lua"))()

local Window = Library:Window({
    text = "Toy Soldier Z"
})

local TabSection = Window:TabSection({
    text = "Main Controls"
})

local Tab = TabSection:Tab({
    text = "Automation",
    icon = "rbxassetid://7999345313",
})

local Section = Tab:Section({
    text = "Game Controls"
})

local savesfile = {}
for _, allsaves in pairs(game:GetService("Players").LocalPlayer.Stats.SaveSlots:GetChildren()) do 
    table.insert(savesfile, allsaves.Name)
end

getgenv().SelectedMode = "Easy"
getgenv().SelectedWave = "1"
getgenv().SelectedSave = savesfile[1] or nil

Section:Dropdown({
    text = "Which Save File",
    list = savesfile,
    default = savesfile[1] or "None", 
    callback = function(String)
        getgenv().SelectedSave = String
    end
})

Section:Dropdown({
    text = "Mode",
    list = {"Easy", "Medium", "Hard", "ToyBreaker"},
    default = "Easy",
    callback = function(String)
        getgenv().SelectedMode = String
    end
})

Section:Textbox({
    text = "Wave Number",
    value = "1",
    callback = function(String)
        getgenv().SelectedWave = String
    end
})

Section:Toggle({
    text = "Auto Collect Teddy",
    state = false,
    callback = function(boolean)
        getgenv().GetAllteddybear = boolean
        
        if getgenv().GetAllteddybear then
            spawn(function()
                while getgenv().GetAllteddybear do
                    task.wait(1) 
                    getallteddy()
                end
            end)
        end
    end
})

Section:Toggle({
    text = "Auto Play(AllWave)",
    state = false,
    callback = function(boolean)
        getgenv().AutoPlayallwave = boolean
        
        if getgenv().AutoPlayallwave then
            spawn(function()
                local currentWave = tonumber(getgenv().SelectedWave) or 1
                
                while getgenv().AutoPlayallwave do
                    if getgenv().SelectedMode and getgenv().SelectedSave then
                        autoplay(getgenv().SelectedMode, tostring(currentWave), getgenv().SelectedSave)
                        task.wait(10)
                        currentWave = currentWave + 1
                        
                        if currentWave > 50 then
                            getgenv().AutoPlayallwave = false
                            break
                        end
                    else
                        warn("Please select Mode and Save File before enabling Auto Play")
                        getgenv().AutoPlayallwave = false
                        break
                    end
                end
            end)
        end
    end
})

Section:Toggle({
    text = "Auto Play(Selected Wave)",
    state = false,
    callback = function(boolean)
        getgenv().AutoPlay = boolean
        
        if getgenv().AutoPlay then
            spawn(function()
                while getgenv().AutoPlay do
                    if getgenv().SelectedMode and getgenv().SelectedWave and getgenv().SelectedSave then
                        autoplay(getgenv().SelectedMode, getgenv().SelectedWave, getgenv().SelectedSave)
                        task.wait(5)
                    else
                        warn("Please select Mode, Wave, and Save File before enabling Auto Play")
                        getgenv().AutoPlay = false
                        break
                    end
                end
            end)
        end
    end
})
