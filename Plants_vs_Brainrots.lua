local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/qqqqd3783-collab/MacOS_UI/refs/heads/main/Main.lua"))()

local imageUrl = "https://raw.githubusercontent.com/Zennakub123456789/picture/main/TadHub-Icon.png"
local imageName = "TadHub-Icon.png"

if not isfile(imageName) then
    local imageData = game:HttpGet(imageUrl)
    writefile(imageName, imageData)
end

local iconPath = getcustomasset(imageName)

local Window = MacUI:Window({
    Title = "Tad Hub | PvB",
    Size = UDim2.new(0, 600, 0, 400),
    Theme = "Dark",
    Icon = iconPath,
    LoadingTitle = "MacUI",
    LoadingSubtitle = "Loading...",
    ToggleUIKeybind = "K",
    ShowText = "Menu",
    NotifyFromBottom = true,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MacUI_Config"
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

MainTab:Section("Anti AFK")

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
local farmPart = nil

local function isPlayerInFarmZone(character, zone)
    if not character or not zone then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local playerPos = hrp.Position
    local zonePos = zone.Position
    local zoneSize = zone.Size

    local minX = zonePos.X - zoneSize.X / 2
    local maxX = zonePos.X + zoneSize.X / 2
    local minY = zonePos.Y - zoneSize.Y / 2
    local maxY = zonePos.Y + zoneSize.Y / 2
    local minZ = zonePos.Z - zoneSize.Z / 2
    local maxZ = zonePos.Z + zoneSize.Z / 2

    return (playerPos.X >= minX and playerPos.X <= maxX and
            playerPos.Y >= minY and playerPos.Y <= maxY and
            playerPos.Z >= minZ and playerPos.Z <= maxZ)
end

local function getAllGrassCFrames(plot)
    local cframes = {}
    if not plot then return cframes end

    local rowsFolder = plot:FindFirstChild("Rows")
    if not rowsFolder then return cframes end

    for _, row in pairs(rowsFolder:GetChildren()) do
        local grassFolder = row:FindFirstChild("Grass")
        if grassFolder then
            for _, part in pairs(grassFolder:GetChildren()) do
                if part:IsA("BasePart") then
                    table.insert(cframes, part.CFrame)
                end
            end
        end
    end

    return cframes
end

local AutoTeleportToggle = AutoTab:Toggle({
    Title = "Auto Farm Brainrot",
    Default = false,
    Flag = "TeleportToBrainrot",
    Callback = function(value)
        getgenv().TeleportToBrainrot = value

        if value then
            local myPlot
            for i = 1, 6 do
                local plot = workspace.Plots:FindFirstChild(tostring(i))
                if plot and plot:GetAttribute("Owner") == player.Name then
                    myPlot = plot
                    break
                end
            end
            if not myPlot then return end

            local grassCFrames = getAllGrassCFrames(myPlot)
            if #grassCFrames == 0 then return end

            farmPart = Instance.new("Part")
            farmPart.Name = "FarmZonePart"
            farmPart.Size = Vector3.new(98, 80, 263)
            farmPart.Anchored = true
            farmPart.CanCollide = false
            farmPart.Transparency = 1
            farmPart.CastShadow = false
            farmPart.Parent = workspace
            
            if grassCFrames[6] then
                local targetGrassCFrame = grassCFrames[6]
                farmPart.CFrame = CFrame.new(targetGrassCFrame.Position)
            else
                warn("Warning: Could not find grass part #6. Defaulting to the first one.")
                farmPart.CFrame = CFrame.new(grassCFrames[1].Position)
            end
            
            local performanceButton = player:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Settings"):WaitForChild("Frame"):WaitForChild("ScrollingFrame"):WaitForChild("Performance"):WaitForChild("Button"):WaitForChild("DisplayName")
            if performanceButton.Text == "Off" then
                local args = {[1] = {["Value"] = true, ["Setting"] = "Performance"}}
                local changeSettingRemote = game:GetService("ReplicatedStorage").Remotes.ChangeSetting
                for i = 1, 5 do
                    changeSettingRemote:FireServer(unpack(args))
                    task.wait(0.1)
                end
                task.wait(5)
            end

            task.spawn(function()
                local spawnerPosition = nil
                local spawner = myPlot:FindFirstChild("SpawnerUI", true)
                if spawner and spawner:IsA("BasePart") then
                    spawnerPosition = spawner.Position
                    if player.Character then
                        player.Character:MoveTo(spawnerPosition)
                    end
                end
                if spawnerPosition then task.wait(1.5) end

                local chosen
                while getgenv().TeleportToBrainrot do
                    if not player.Character then 
                        task.wait(1) 
                        continue
                    end

                    if not isPlayerInFarmZone(player.Character, farmPart) then
                        if spawnerPosition and player.Character then
                            player.Character:MoveTo(spawnerPosition)
                        end
                        task.wait(5)
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
        else
            if farmPart then
                farmPart:Destroy()
                farmPart = nil
            end
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

local BestBrainrotsLabel = AutoTab:Label({
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

AutoTab:Section("Auto Open Eggs")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

getgenv().SelectedEggs = { "Godly Lucky Egg" }
getgenv().AutoOpenEgg = false

local EggDropdown = AutoTab:Dropdown({
    Title = "Select Eggs to Open",
    Options = { "Godly Lucky Egg", "Secret Lucky Egg", "Meme Lucky Egg" },
    Default = getgenv().SelectedEggs,
    Multi = true,
    Callback = function(option)
        getgenv().SelectedEggs = option
    end
})

local AutoOpenEggToggle = AutoTab:Toggle({
    Title = "Auto Open Egg",
    Desc = "Equips and opens selected eggs in a loop.",
    Default = false,
    Flag = "AutoOpenEgg",
    Callback = function(value)
        getgenv().AutoOpenEgg = value
        if value then
            task.spawn(function()
                while getgenv().AutoOpenEgg do
                    for _, eggName in pairs(getgenv().SelectedEggs) do
                        if not getgenv().AutoOpenEgg then break end
                        local foundEgg = nil
                        for _, tool in pairs(Backpack:GetChildren()) do
                            if string.find(string.lower(tool.Name), string.lower(eggName)) then
                                foundEgg = tool
                                break
                            end
                        end

                        if foundEgg then
                            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:EquipTool(foundEgg)
                                task.wait(0.2)
                                ReplicatedStorage.Remotes.OpenEgg:FireServer()
                            end
                        end

                        task.wait(0.5)
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

AutoTab:Section("Auto Favorite Brainrots")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedBrainrotRarities = {}
local isFavoriteBrainrotLoopRunning = false

local BrainrotRarityOptions = {"Rare", "Epic", "Legendary", "Mythic", "Godly", "Secret", "Limited"}

local BrainrotRarityDropdown = AutoTab:Dropdown({
    Title = "Select Rarity",
    Options = BrainrotRarityOptions,
    Multi = true,
    Default = {},
    Flag = "BrainrotRaritySelection",
    Callback = function(selected_options)
        selectedBrainrotRarities = selected_options
    end
})

local FavoriteBrainrotToggle = AutoTab:Toggle({
    Title = "Auto Favorite Brainrot By Rarity",
    Default = false,
    Flag = "AutoFavoriteBrainrotToggle",
    Callback = function(value)
        if value then
            if isFavoriteBrainrotLoopRunning then return end
            isFavoriteBrainrotLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Brainrots", Duration = 3 })

            task.spawn(function()
                while isFavoriteBrainrotLoopRunning do
                    local localPlayer = Players.LocalPlayer
                    if not localPlayer or not localPlayer.Character then break end

                    local backpack = localPlayer.Backpack
                    local playerGui = localPlayer.PlayerGui
                    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10

                    local function table_contains(tbl, val)
                        for _, v in ipairs(tbl) do
                            if v == val then return true end
                        end
                        return false
                    end

                    for _, tool in ipairs(backpack:GetChildren()) do
                        local success, err = pcall(function()
                            if tool and tool:IsA("Tool") then
                                local brainrotValue = tool:GetAttribute("Brainrot")
                                if not brainrotValue then return end

                                local isToolFavorited = false
                                
                                for i = 1, hotbarSlots do
                                    local slot = playerGui.BackpackGui.Backpack.Hotbar:FindFirstChild(tostring(i))
                                    local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                    if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                        if slot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                    end
                                end

                                if not isToolFavorited then
                                    local inventoryFrame = playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                                    if inventoryFrame then
                                        for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                                            if itemSlot:IsA("TextButton") then
                                                local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                                    if itemSlot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                if isToolFavorited then
                                    tool:SetAttribute("Brainrot", nil)
                                    return 
                                end
                                
                                local uuidValue = tool:GetAttribute("ID")
                                if uuidValue and #selectedBrainrotRarities > 0 then
                                    local nestedModel = tool:FindFirstChild(brainrotValue)
                                    if nestedModel then
                                        local rarityValue = nestedModel:GetAttribute("Rarity")
                                        
                                        if rarityValue and table_contains(selectedBrainrotRarities, rarityValue) then
                                            local args = { [1] = uuidValue }
                                            ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                            MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                        end
                                    end
                                end
                            end
                        end)
                        if not success then
                            print("เกิด Error ขณะตรวจสอบไอเท็ม แต่ทำงานต่อได้:", err)
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            if isFavoriteBrainrotLoopRunning then
                isFavoriteBrainrotLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Brainrots", Duration = 4 })
            end
        end
    end
})

AutoTab:Section("Auto Favorite Plants")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedPlantRarities = {}
local isFavoritePlantLoopRunning = false

local PlantsRarityOptions = {"Rare", "Epic", "Legendary", "Mythic", "Godly", "Secret", "Limited"}

local PlantRarityDropdown = AutoTab:Dropdown({
    Title = "เลือก Rarity ที่ต้องการ",
    Options = PlantsRarityOptions,
    Multi = true,
    Default = {},
    Flag = "PlantRaritySelection",
    Callback = function(selected_options)
        selectedPlantRarities = selected_options
    end
})

local FavoritePlantToggle = AutoTab:Toggle({
    Title = "Auto Favorite Plants By Rarity",
    Default = false,
    Flag = "AutoFavoritePlantToggle",
    Callback = function(value)
        if value then
            if isFavoritePlantLoopRunning then return end
            isFavoritePlantLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Plants", Duration = 3 })

            task.spawn(function()
                while isFavoritePlantLoopRunning do
                    local localPlayer = Players.LocalPlayer
                    if not localPlayer or not localPlayer.Character then break end

                    local backpack = localPlayer.Backpack
                    local playerGui = localPlayer.PlayerGui
                    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10

                    local function table_contains(tbl, val)
                        for _, v in ipairs(tbl) do
                            if v == val then return true end
                        end
                        return false
                    end

                    for _, tool in ipairs(backpack:GetChildren()) do
                        local success, err = pcall(function()
                            if tool and tool:IsA("Tool") then
                                local plantValue = tool:GetAttribute("Plant")
                                if not plantValue then return end

                                local isToolFavorited = false
                                
                                for i = 1, hotbarSlots do
                                    local slot = playerGui.BackpackGui.Backpack.Hotbar:FindFirstChild(tostring(i))
                                    local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                    if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                        if slot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                    end
                                end

                                if not isToolFavorited then
                                    local inventoryFrame = playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                                    if inventoryFrame then
                                        for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                                            if itemSlot:IsA("TextButton") then
                                                local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                                if toolNameLabel and toolNameNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                                    if itemSlot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                if isToolFavorited then
                                    return 
                                end
                                
                                local uuidValue = tool:GetAttribute("ID")
                                if uuidValue and #selectedPlantRarities > 0 then
                                    local nestedModel = tool:FindFirstChild(plantValue)
                                    if nestedModel then
                                        local rarityValue = nestedModel:GetAttribute("Rarity")
                                        
                                        if rarityValue and table_contains(selectedPlantRarities, rarityValue) then
                                            local args = { [1] = uuidValue }
                                            ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                            MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                        end
                                    end
                                end
                            end
                        end)
                        if not success then
                            print("เกิด Error ขณะตรวจสอบไอเท็ม แต่ทำงานต่อได้:", err)
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            if isFavoritePlantLoopRunning then
                isFavoritePlantLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Plants", Duration = 4 })
            end
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

local AutoBuyGearAllToggle = ShopTab:Toggle({
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

local SellTab = Window:Tab("Sell", "rbxassetid://10698878025")

SellTab:Section("Auto Sell Brainrots")

local SellBrainrotLabel = SellTab:Label({
    Text = "1 = 1 sec / 600 = 10 min"
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local itemSellRemote = ReplicatedStorage.Remotes.ItemSell

getgenv().SellDelay = 1
getgenv().AutoSell = false
getgenv().AutoSellFull = false

local SellDelaySlider = SellTab:Slider({
    Title = "Sell Brainrots All Delay",
    Min = 1,
    Max = 600,
    Default = 1,
    Rounding = 0,
    Suffix = "s",
    Flag = "SellDelaySlider",
    Callback = function(value)
        getgenv().SellDelay = value
    end
})

local AutoSellToggle = SellTab:Toggle({
    Title = "Auto Sell Brainrots All",
    Default = false,
    Flag = "AutoSell",
    Callback = function(value)
        getgenv().AutoSell = value
        if value then
            task.spawn(function()
                while getgenv().AutoSell do
                    itemSellRemote:FireServer()
                    task.wait(getgenv().SellDelay)
                end
            end)
        end
    end
})

local AutoSellFullToggle = SellTab:Toggle({
    Title = "Auto Sell Brainrots All When Inventory Full",
    Default = false,
    Flag = "AutoSellFull",
    Callback = function(value)
        getgenv().AutoSellFull = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellFull do
                    local player = Players.LocalPlayer
                    if player then
                        local backpack = player:WaitForChild("Backpack")
                        if #backpack:GetChildren() >= 250 then
                            itemSellRemote:FireServer()
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

SellTab:Section("Auto Sell Plants")

local SellPlantLabel = SellTab:Label({
    Text = "1 = 1 sec / 600 = 10 min"
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local plantSellRemote = ReplicatedStorage.Remotes.ItemSell

getgenv().PlantSellDelay = 1
getgenv().AutoSellPlants = false
getgenv().AutoSellPlantsFull = false

local PlantSellDelaySlider = SellTab:Slider({
    Title = "Sell Plants All Delay",
    Min = 1,
    Max = 600,
    Default = 1,
    Rounding = 0,
    Suffix = "s",
    Flag = "PlantSellDelaySlider",
    Callback = function(value)
        getgenv().PlantSellDelay = value
    end
})

local AutoSellPlantsToggle = SellTab:Toggle({
    Title = "Auto Sell Plants All",
    Default = false,
    Flag = "AutoSellPlants",
    Callback = function(value)
        getgenv().AutoSellPlants = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellPlants do
                    local args = { [2] = true }
                    plantSellRemote:FireServer(unpack(args))
                    task.wait(getgenv().PlantSellDelay)
                end
            end)
        end
    end
})

local AutoSellPlantsFullToggle = SellTab:Toggle({
    Title = "Auto Sell Plants All When Inventory Full",
    Default = false,
    Flag = "AutoSellPlantsFull",
    Callback = function(value)
        getgenv().AutoSellPlantsFull = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellPlantsFull do
                    local player = Players.LocalPlayer
                    if player then
                        local backpack = player:WaitForChild("Backpack")
                        if #backpack:GetChildren() >= 250 then
                            local args = { [2] = true }
                            plantSellRemote:FireServer(unpack(args))
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

SellTab:Section("Auto Sell Brainrots + Plants")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local itemSellRemote = ReplicatedStorage.Remotes.ItemSell
local plantSellRemote = ReplicatedStorage.Remotes.ItemSell

getgenv().AutoSellAllFull = false

local AutoSellAllFullToggle = SellTab:Toggle({
    Title = "Auto Sell All When Inventory Full",
    Default = false,
    Flag = "AutoSellAllFull",
    Callback = function(value)
        getgenv().AutoSellAllFull = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellAllFull do
                    local player = Players.LocalPlayer
                    if player then
                        local backpack = player:WaitForChild("Backpack")
                        if #backpack:GetChildren() >= 250 then
                            local args = { [2] = true }
                            itemSellRemote:FireServer(unpack(args))
                            plantSellRemote:FireServer(unpack(args))
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local TeleportTab = Window:Tab("Teleport", "rbxassetid://6723742952")

TeleportTab:Section("Home")

local TeleportGrassButton = TeleportTab:Button({
    Title = "Teleport to Plots",
    Desc = "Goto Your Plots",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local plots = workspace:WaitForChild("Plots")

        for i = 1, 6 do
            local plot = plots:FindFirstChild(tostring(i))
            if plot and plot:GetAttribute("Owner") == player.Name then
                pcall(function()
                    local target = plot:WaitForChild("Rows"):WaitForChild("1"):WaitForChild("Grass"):GetChildren()[9]
                    if target and target:IsA("BasePart") then
                        player.Character:WaitForChild("HumanoidRootPart").CFrame = target.CFrame + Vector3.new(0, 5, 0)
                    end
                end)
                break
            end
        end
    end
})

TeleportTab:Section("Event")

local TeleportFixedButton = TeleportTab:Button({
    Title = "Teleport to Prison Event",
    Desc = "Goto Event Area",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-173.82, 12.49, 999.30)
        end
    end
})

local EventTab = Window:Tab("Event", "rbxassetid://128706247346129")

EventTab:Section("Prison Event")

getgenv().AutoTurnIn = false

local AutoTurnInToggle = EventTab:Toggle({
    Title = "Auto Turn In",
    Desc = "Auto Event",
    Default = false,
    Flag = "AutoTurnIn",
    Callback = function(value)
        getgenv().AutoTurnIn = value

        if value then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local UserInputService = game:GetService("UserInputService")
                local wantedItemLabel = player:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("WantedPosterGui"):WaitForChild("Frame"):WaitForChild("Main"):WaitForChild("WantedItem"):WaitForChild("WantedItem_Title")

                local function isToolFavorited(tool)
                    local playerGui = player.PlayerGui
                    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10

                    for i = 1, hotbarSlots do
                        local slot = playerGui.BackpackGui.Backpack.Hotbar:FindFirstChild(tostring(i))
                        local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                        if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                            if slot:FindFirstChild("HeartIcon") then return true end
                        end
                    end

                    local inventoryFrame = playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                    if inventoryFrame then
                        for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                            if itemSlot:IsA("TextButton") then
                                local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                    if itemSlot:FindFirstChild("HeartIcon") then return true end
                                end
                            end
                        end
                    end
                    
                    return false
                end


                while getgenv().AutoTurnIn do
                    local keyword = wantedItemLabel.Text
                    local toolToEquip = nil

                    if keyword and keyword ~= "" and keyword ~= "None" then
                        local backpack = player:WaitForChild("Backpack")
                        local matches = {}
                        
                        for _, tool in ipairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name, keyword) and not isToolFavorited(tool) then
                                table.insert(matches, tool)
                            end
                        end

                        if #matches > 0 then
                            if #matches == 1 then
                                toolToEquip = matches[1]
                            else
                                toolToEquip = matches[math.random(1, #matches)]
                            end

                            if player.Character and player.Character:FindFirstChild("Humanoid") then
                               player.Character.Humanoid:EquipTool(toolToEquip)
                               task.wait(0.2)
                            end
                        end
                    end

                    if toolToEquip then
                        local args = { [1] = "TurnIn" }
                        game:GetService("ReplicatedStorage").Remotes.Events.Prison.Interact:FireServer(unpack(args))
                    end

                    task.wait(1.5)
                end
            end)
        end
    end
})

getgenv().AutoResetRequest = false

local AutoResetRequestToggle = EventTab:Toggle({
    Title = "Auto Reset Prison",
    Desc = "Auto Reset Prison",
    Default = false,
    Flag = "AutoResetRequest",
    Callback = function(value)
        getgenv().AutoResetRequest = value

        if value then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local guiPath = player:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("WantedPosterGui"):WaitForChild("Frame"):WaitForChild("Main_Complete")

                while getgenv().AutoResetRequest do
                    task.wait(0.5)

                    if guiPath.Visible then
                        local args = { [1] = "ResetRequest" }
                        game:GetService("ReplicatedStorage").Remotes.Events.Prison.Interact:FireServer(unpack(args))

                        repeat 
                            task.wait(0.5) 
                        until not guiPath.Visible or not getgenv().AutoResetRequest
                    end
                end
            end)
        end
    end
})

local SettingTab = Window:Tab("Settings", "rbxassetid://128706247346129")

SettingTab:Section("Performance")

getgenv().HideNotifications = false

local HideNotificationsToggle = SettingTab:Toggle({
    Title = "Hide Notifications",
    Desc = "Hide Notify",
    Default = false,
    Flag = "HideNotifications",
    Callback = function(value)
        getgenv().HideNotifications = value
        local player = game:GetService("Players").LocalPlayer
        local notifications = player:WaitForChild("PlayerGui"):WaitForChild("Notifications")
        notifications.Enabled = not value
    end
})

local lighting = game:GetService("Lighting")
local terrain = workspace:FindFirstChildOfClass("Terrain")
local settings = settings()

local DefaultValues = {
    QualityLevel = settings.Rendering.QualityLevel,
    GlobalShadows = lighting.GlobalShadows,
    FogEnd = lighting.FogEnd,
    Brightness = lighting.Brightness,
    WaterWaveSize = terrain and terrain.WaterWaveSize or nil,
    WaterWaveSpeed = terrain and terrain.WaterWaveSpeed or nil,
    WaterReflectance = terrain and terrain.WaterReflectance or nil,
    WaterTransparency = terrain and terrain.WaterTransparency or nil
}

getgenv().LowGraphics = false

local LowGraphicsToggle = SettingTab:Toggle({
    Title = "Low Graphics",
    Desc = "Reduce graphics to increase FPS",
    Default = false,
    Flag = "LowGraphics",
    Callback = function(value)
        getgenv().LowGraphics = value

        if value then
            settings.Rendering.QualityLevel = Enum.QualityLevel.Level01
            lighting.GlobalShadows = false
            lighting.FogEnd = 1000
            lighting.Brightness = 1
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end

            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                end
            end
        else
            settings.Rendering.QualityLevel = DefaultValues.QualityLevel
            lighting.GlobalShadows = DefaultValues.GlobalShadows
            lighting.FogEnd = DefaultValues.FogEnd
            lighting.Brightness = DefaultValues.Brightness
            if terrain then
                terrain.WaterWaveSize = DefaultValues.WaterWaveSize
                terrain.WaterWaveSpeed = DefaultValues.WaterWaveSpeed
                terrain.WaterReflectance = DefaultValues.WaterReflectance
                terrain.WaterTransparency = DefaultValues.WaterTransparency
            end

            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = true
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 0
                end
            end
        end
    end
})

local selectedLanguage = "English"

SettingTab:Section("Language Settings")

local LanguageDropdown = SettingTab:Dropdown({
    Title = "Select Language",
    Options = {"English", "ภาษาไทย"},
    Default = selectedLanguage,
    Callback = function(chosenLanguage)
        selectedLanguage = chosenLanguage
    end
})
local ApplyButton = SettingTab:Button({
    Title = "Apply",
    Desc = "Apply the selected language"
})

local languageScripts = {
    ["English"] = function()
        print("English")
    end,
    
    ["ภาษาไทย"] = function()
        AntiAFKToggle:SetTitle("ป้องกัน AFK [กันหลุดเมื่อยืนนิ่งเกิน20นาที]")
        AutoTeleportToggle:SetTitle("ฟาร์ม Brainrots อัตโนมัติ")
        SpeedSlider:SetTitle("ความเร็วการตี")
        AutoFarmToggle:SetTitle("ตีอัตโนมัติ")
        BestBrainrotsLabel:SetText("1 = 1วิ / 600วิ = 10นาที")
        DelaySlider:SetTitle("ดีเลย์การสวม Brainrots ที่ดีที่สุด")
        AutoEquipToggle:SetTitle("ใส่ Brainrots ที่ดีที่สุดอัตโนมัติ")
        EggDropdown:SetTitle("เลือกไข่ที่จะเปิด")
        AutoOpenEggToggle:SetTitle("เปิดไข่อัตโนมัติ")
        BrainrotRarityDropdown:SetTitle("เลือกความหายาก")
        FavoriteBrainrotToggle:SetTitle("ล็อคหัวใจ Brainrots อัตโนมัติ [ตามความหายากที่เลือก]")
        PlantRarityDropdown:SetTitle("เลือกความหายาก")
        FavoritePlantToggle:SetTitle("ล็อคหัวใจ Plants อัตโนมัติ [ตามความหายากที่เลือก]")
        SeedDropdown:SetTitle("เลือกเมล็ดพันธุ์")
        AutoBuySeedSelectedToggle:SetTitle("ซื้อเมล็ดพันธุ์อัตโนมัติ [ที่เลือก]")
        AutoBuyAllToggle:SetTitle("ซื้อเมล็ดพันธุ์อัตโนมัติ [ทั้งหมด]")
        ItemDropdown:SetTitle("เลือกอุปกรณ์")
        AutoBuySelectedToggle:SetTitle("ซื้ออุปกรณ์อัตโนมัติ [ที่เลือก]")
        AutoBuyGearAllToggle:SetTitle("ซื้ออุปกรณ์อัตโนมัติ [ทั้งหมด]")
        SellDelaySlider:SetTitle("ดีเลย์การขาย Brainrot ทั้งหมด")
        AutoSellToggle:SetTitle("ขาย Brainrot ทั้งหมดอัตโนมัติ")
        AutoSellFullToggle:SetTitle("ขาย Brainrot ทั้งหมดอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        SellPlantLabel:SetTitle("1 = 1วิ / 600วิ = 10นาที")
        PlantSellDelaySlider:SetTitle("ดีเลย์การขาย Plant ทั้งหมด")
        AutoSellPlantsToggle:SetTitle("ขาย Plant ทั้งหมดอัตโนมัติ")
        AutoSellPlantsFullToggle:SetTitle("ขาย Plant ทั้งหมดอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        AutoSellAllFullToggle:SetTitle("ขายทั้งสองอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        TeleportGrassButton:SetTitle("วาปไปสวนของตัวเอง")
        TeleportFixedButton:SetTitle("วาปไปอีเว้นคุก")
        AutoTurnInToggle:SetTitle("ส่ง Brainrot ที่ต้องการเข้าคุกอัตโนมัติ")
        AutoResetRequestToggle:SetTitle("รีเซ็ตหลังทำภารกิจส่ง Brainrot เสร็จอัตโนมัติ")
        HideNotificationsToggle:SetTitle("ซ่อนการแจ้งเตือน")
        LowGraphicsToggle:SetTitle("ปรับกราฟิกให้ต่ำลงเพื่อเพิ่ม FPS")
        LanguageDropdown:SetTitle("เลือกภาษา")
        ApplyButton:SetTitle("ยืนยันการเปลี่ยนภาษา")
    end
}

ApplyButton:SetCallback(function()
    if languageScripts[selectedLanguage] then
        languageScripts[selectedLanguage]()
        
        MacUI:Notify({
            Title = "Success",
            Content = "Language has been set to: " .. selectedLanguage,
            Duration = 4
        })
    else
        MacUI:Notify({
            Title = "Error",
            Content = "No script found for language: " .. selectedLanguage,
            Duration = 4
        })
    end
end)

MacUI:Notify({
    Title = "Script Loaded",
    Content = "Settings panel is ready.",
    Duration = 3
})

