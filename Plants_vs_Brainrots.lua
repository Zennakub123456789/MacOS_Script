local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/qqqqd3783-collab/MacOS_UI/refs/heads/main/Main.lua"))()

local Window = MacUI:Window({
    Title = "MacUI Demo",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Dark", -- "Default", "Dark", "Ocean"
    Icon = 0, -- Asset ID or URL (optional)
    
    LoadingTitle = "MacUI",
    LoadingSubtitle = "Loading...",
    
    ToggleUIKeybind = "RightControl",
    ShowText = "Menu",
    
    NotifyFromBottom = true,
    
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

local MainTab = Window:Tab("Main", "rbxassetid://128706247346129")

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

local AutoTab = Window:Tab("Auto", "rbxassetid://86084882582277")

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

local Players = game:GetService("Players")
local player = Players.LocalPlayer

getgenv().AttackSpeed = 0.25

local SpeedSlider = AutoTab:Slider({
    Title = "Hit Speed",
    Description = "Set Speed to Auto Hit",
    Min = 0,
    Max = 1,
    Default = 0.25,
    Suffix = "s",
    Rounding = 2,
    Flag = "AttackSpeedSlider",
    Callback = function(value)
        getgenv().AttackSpeed = value
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

AutoTab:Section("Auto Equip And Collect Money")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Label = AutoTab:Label({
    Text = "1 = 1 sec / 600 = 10 min"
})

getgenv().EquipDelay = 60

local DelaySlider = AutoTab:Slider({
    Title = "Equip Best Brainrots Delay",
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

local ShopTab = Window:Tab("Shop", "rbxassetid://11385419674")

ShopTab:Section("Auto Buy Seed")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeedRemote = ReplicatedStorage.Remotes.BuyItem

local AllSeeds = { "Cactus Seed", "Strawberry Seed", "Pumpkin Seed", "Sunflower Seed", "Dragon Fruit Seed", "Eggplant Seed", "Watermelon Seed", "Grape Seed", "Cocotank Seed", "Carnivorous Plant Seed", "Mr Carrot Seed", "Tomatrio Seed", "Shroombino Seed", "Mango Seed" }

getgenv().SelectedBuySeeds = {}
getgenv().AutoBuySeedSelected = false
getgenv().AutoBuySeedAll = false

local SeedDropdown = ShopTab:Dropdown({
    Title = "Select Seeds",
    Options = AllSeeds,
    Multi = true,
    Default = {},
    Callback = function(selected)
        getgenv().SelectedBuySeeds = selected
    end
})

local AutoBuySeedSelectedToggle = ShopTab:Toggle({
    Title = "Auto Buy Seed [Selected]",
    Default = false,
    Flag = "AutoBuySeedSelected",
    Callback = function(value)
        getgenv().AutoBuySeedSelected = value
        if value then
            task.spawn(function()
                while getgenv().AutoBuySeedSelected do
                    if #getgenv().SelectedBuySeeds > 0 then
                        for _, seed in ipairs(getgenv().SelectedBuySeeds) do
                            if not getgenv().AutoBuySeedSelected then break end
                            buySeedRemote:FireServer(seed, true)
                            task.wait(0.5)
                        end
                    else
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

local AutoBuyAllToggle = ShopTab:Toggle({
    Title = "Auto Buy Seed [All]",
    Default = false,
    Flag = "AutoBuySeedAll",
    Callback = function(value)
        getgenv().AutoBuySeedAll = value
        if value then
            task.spawn(function()
                while getgenv().AutoBuySeedAll do
                    for _, seed in ipairs(AllSeeds) do
                        if not getgenv().AutoBuySeedAll then break end
                        buySeedRemote:FireServer(seed, true)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

ShopTab:Section("Auto Buy Gear")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buyRemote = ReplicatedStorage.Remotes.BuyGear

local AllItems = { "Water Bucket", "Frost Grenade", "Banana Gun", "Frost Blower", "Carrot Launcher" }

getgenv().SelectedBuyItems = {}
getgenv().AutoBuySelected = false
getgenv().AutoBuyAll = false

local ItemDropdown = ShopTab:Dropdown({
    Title = "Select Gear",
    Options = AllItems,
    Multi = true,
    Default = {},
    Callback = function(selected)
        getgenv().SelectedBuyItems = selected
    end
})

local AutoBuySelectedToggle = ShopTab:Toggle({
    Title = "Auto Buy Gear [Selected]",
    Default = false,
    Flag = "AutoBuySelected",
    Callback = function(value)
        getgenv().AutoBuySelected = value

        if value then
            task.spawn(function()
                while getgenv().AutoBuySelected do
                    if #getgenv().SelectedBuyItems > 0 then
                        for _, item in ipairs(getgenv().SelectedBuyItems) do
                            if not getgenv().AutoBuySelected then break end
                            buyRemote:FireServer(item, true)
                            task.wait(0.5)
                        end
                    else
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

local AutoBuyAllToggle = ShopTab:Toggle({
    Title = "Auto Buy Gear [All]",
    Default = false,
    Flag = "AutoBuyAll",
    Callback = function(value)
        getgenv().AutoBuyAll = value

        if value then
            task.spawn(function()
                while getgenv().AutoBuyAll do
                    for _, item in ipairs(AllItems) do
                        if not getgenv().AutoBuyAll then break end
                        buyRemote:FireServer(item, true)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})
