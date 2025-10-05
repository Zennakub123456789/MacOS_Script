local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/qqqqd3783-collab/MacOS_UI/refs/heads/main/Main.lua"))()

local Window = MacUI:Window({
    Title = "My Amazing Script",
    Theme = "Dark",
    LoadingTitle = "Loading",
    LoadingSubtitle = "Please wait...",
    ToggleUIKeybind = "RightControl",
    ShowText = "Menu",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MyConfig"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Enter Key",
        Subtitle = "Join Discord for key",
        Key = {"TestKey123", "Premium456"},
        KeyLink = "https://discord.gg/yourserver",
        SaveKey = true
    }
})

local MainTab = Window:Tab("Main", "rbxassetid://7733779610")

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

local idledConnection = nil

getgenv().AntiAFK = false

local AntiAFKToggle = MainTab:Toggle({
    Title = "Anti AFK",
    Default = false,
    Flag = "AntiAFK",
    Callback = function(value)
        getgenv().AntiAFK = value

        if value then
            task.spawn(function()
                idledConnection = player.Idled:Connect(function()
                    if getgenv().AntiAFK then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end
                end)
                
                while getgenv().AntiAFK do
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    task.wait(60)
                end
            end)

        else
            if idledConnection then
                idledConnection:Disconnect()
                idledConnection = nil
            end
        end
    end
})

local AutoTab = Window:Tab("Auto", "rbxassetid://7733779610")

AutoTab:Section("Auto Fram Brainrots")

AutoTab:Section("-[Use Auto Fram Brainrots on PRIVATE SERVERS Only")

local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

getgenv().TeleportToBrainrot = false

local AutoTeleportToggle = AutoTab:Toggle({
    Title = "Auto Farm Brainrot",
    Default = false,
    Flag = "TeleportToBrainrot",
    Callback = function(value)
        
        getgenv().TeleportToBrainrot = value

        if value then
            task.spawn(function()
                local plotFound = false
                for i = 1, 6 do
                    local plot = workspace.Plots:FindFirstChild(tostring(i))
                    if plot and plot:GetAttribute("Owner") == player.Name then
                        local spawner = plot:FindFirstChild("SpawnerUI", true)
                        if spawner and spawner:IsA("BasePart") and player.Character then
                            player.Character:MoveTo(spawner.Position)
                            plotFound = true
                            break
                        end
                    end
                end
                
                if plotFound then
                    task.wait(1.5)
                end

                local chosen
                while getgenv().TeleportToBrainrot do
                    if not player.Character then 
                        task.wait(1) 
                        continue
                    end

                    local brainrots = workspace:WaitForChild("ScriptedMap"):WaitForChild("Brainrots")
                    local list = brainrots:GetChildren()

                    if not chosen or not chosen.Parent then
                        if #list > 0 then
                            chosen = list[math.random(1, #list)]
                        else
                            chosen = nil
                        end
                    end

                    if chosen and chosen.Parent then
                        player.Character:MoveTo(chosen:GetPivot().Position)
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

AutoTab:Section("Auto Hit")

local Label = AutoTab:Label({
    Text = "1 = 0.01 / 50 = 0.5"
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().AttackSpeed = 0.25

local SpeedSlider = AutoTab:Slider({
    Title = "Hit Speed",
    Description = "ปรับความเร็วในการโจมตี (น้อย = เร็วขึ้น)",
    Min = 1,
    Max = 50,
    Default = 25,
    Suffix = "s",
    Rounding = 2,
    Flag = "AttackSpeedSlider",
    Callback = function(value)
        getgenv().AttackSpeed = value / 100
    end
})

getgenv().AutoFarm = false

local AutoFarmToggle = AutoTab:Toggle({
    Title = "Auto Hit",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        getgenv().AutoFarm = value
        
        if value then
            task.spawn(function()
                while getgenv().AutoFarm do
                    local bat = player.Backpack:FindFirstChild("Basic Bat") 
                                or (player.Character and player.Character:FindFirstChild("Basic Bat"))
                    
                    if bat and player.Character and player.Character:FindFirstChild("Humanoid") then
                        local humanoid = player.Character.Humanoid
                        
                        if not player.Character:FindFirstChild("Basic Bat") then
                            humanoid:EquipTool(bat)
                            task.wait(0.1)
                        end

                        if player.Character:FindFirstChild("Basic Bat") then
                            bat:Activate()
                        end
                    end
                    
                    task.wait(getgenv().AttackSpeed) 
                end
            end)
        end
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Label = AutoTab:Label({
    Text = "1 = 1 sec / 600 = 10 min"
})

getgenv().EquipDelay = 60

local DelaySlider = AutoTab:Slider({
    Title = "Equip Delay",
    Description = "Set Speed to Equip Best Brainrots",
    Min = 1,
    Max = 600,
    Default = 60,
    Suffix = "s",
    Rounding = 0,
    Flag = "EquipDelaySlider",
    Callback = function(value)
        getgenv().EquipDelay = value
    end
})

getgenv().AutoEquipBest = false

local AutoEquipToggle = AutoTab:Toggle({
    Title = "Auto Equip Best Brainrots",
    Default = false,
    Flag = "AutoEquipBest",
    Callback = function(value)
        getgenv().AutoEquipBest = value

        if value then
            task.spawn(function()
                while getgenv().AutoEquipBest do
                    game:GetService("ReplicatedStorage").Remotes.EquipBestBrainrots:FireServer()
                    
                    task.wait(getgenv().EquipDelay) 
                end
            end)
        end
    end
})
