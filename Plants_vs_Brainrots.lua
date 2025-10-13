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

local infoTab = Window:Tab("Info", "rbxassetid://76311199408449")

infoTab:Section("Discord")

local DiscordLabel = infoTab:Label({
    Text = "เจอ error หรือต่าง, อยากให้สร้างสคริปแมพอื่น, แจ้งมาได้ที่ ดิสคอร์ด รับฟังทุกปัญหา"
})

local CopyDiscordButton = infoTab:Button({
    Title = "คัดลอกลิ้งดิสคอร์ด",
    Desc = "กดเพื่อคัดลอกลิงก์เชิญ Discord",
    Callback = function()
        local link = "https://discord.gg/cQywVqjcyj"
        if setclipboard then
            setclipboard(link)
            MacUI:Notify({
                Title = "คัดลอกแล้ว!",
                Content = "ลิงก์ Discord ถูกคัดลอกไปยังคลิปบอร์ดแล้ว",
                Icon = "copy",
                Duration = 3
            })
        else
            MacUI:Notify({
                Title = "ไม่รองรับการคัดลอก",
                Content = "ตัวรันของคุณไม่รองรับฟังก์ชัน setclipboard",
                Icon = "alert-triangle",
                Duration = 3
            })
        end
    end
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

local AllowedIds = {
    4128505180,
    8041920244,
}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function isAllowed()
    if not LocalPlayer then return false end
    for _, id in ipairs(AllowedIds) do
        if LocalPlayer.UserId == id then
            return true
        end
    end
    return false
end

if isAllowed() then

    local PlayersTab = Window:Tab("Players", "rbxassetid://117259180607823")

    local function GetPlayerNames()
        local t = {}
        for _, p in pairs(Players:GetPlayers()) do
            table.insert(t, p.Name)
        end
        return t
    end

    local function findCharacterRoot(character)
        if not character then return nil end
        return character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("LowerTorso")
            or character:FindFirstChild("Torso")
    end

    getgenv().SelectedPlayer = nil

    local PlayerDropdown = PlayersTab:Dropdown({
        Title = "Select Player",
        Options = GetPlayerNames(),
        Default = nil,
        Flag = "SelectedPlayer",
        Callback = function(selected)
            getgenv().SelectedPlayer = selected
        end
    })

    local function updatePlayerList()
        if PlayerDropdown and PlayerDropdown.SetOptions then
            PlayerDropdown:SetOptions(GetPlayerNames())
        end
    end
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)

    local TeleportButton = PlayersTab:Button({
        Title = "Teleport to Selected Player",
        Desc = "Goto the player selected in the Dropdown.",
        Callback = function()
            local selected = getgenv().SelectedPlayer
            
            if not selected or selected == "" then
                return
            end

            local targetPlayer = Players:FindFirstChild(selected)

            if not targetPlayer then return end
            if targetPlayer == LocalPlayer then return end

            local targetRoot = findCharacterRoot(targetPlayer.Character)
            if not targetRoot then return end

            local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local myRoot = findCharacterRoot(myChar)
            if not myRoot then return end

            pcall(function()
                myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            end)
        end
    })
end

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
                local player = game:GetService("Players").LocalPlayer

                local function isPlayerInZone(character, zone)
                    if not character or not zone then return false end
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return false end
                    local playerPos = hrp.Position; local zonePos = zone.Position; local zoneSize = zone.Size
                    local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
                    local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
                    local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
                    return (playerPos.X >= minX and playerPos.X <= maxX and playerPos.Y >= minY and playerPos.Y <= maxY and playerPos.Z >= minZ and playerPos.Z <= maxZ)
                end

                while getgenv().AutoFarm do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    
                    if humanoid then
                        local eventZone = workspace:FindFirstChild("EventZone")

                        if eventZone and isPlayerInZone(character, eventZone) then
                            humanoid:UnequipTools()
                        else
                            local bat = player.Backpack:FindFirstChild("Basic Bat") 
                                        or (character and character:FindFirstChild("Basic Bat"))
                            
                            if bat then
                                if not character:FindFirstChild("Basic Bat") then
                                    humanoid:EquipTool(bat)
                                    task.wait(0.1)
                                end
        
                                if character:FindFirstChild("Basic Bat") then
                                    bat:Activate()
                                end
                            end
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
    Title = "Select Rarity",
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
                                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
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

AutoTab:Section("Auto Favorite by Mutation")

local AllMutationOptions = {"Gold", "Diamond", "Neon", "Frozen", "UpsideDown", "Rainbow", "Galactic", "Magma", "Underworld"}
local selectedSharedMutations = {}

local SharedMutationDropdown = AutoTab:Dropdown({
    Title = "Select Mutation",
    Options = AllMutationOptions,
    Multi = true,
    Default = {},
    Flag = "SharedMutationSelection",
    Callback = function(selected_options)
        selectedSharedMutations = selected_options
    end
})

local isFavoriteBrainrotMutationLoopRunning = false
local FavoriteBrainrotToggle = AutoTab:Toggle({
    Title = "Auto Favorite Brainrot By Mutation",
    Default = false,
    Flag = "AutoFavoriteBrainrotToggle",
    Callback = function(value)
        if value then
            if isFavoriteBrainrotMutationLoopRunning then return end
            isFavoriteBrainrotMutationLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Brainrots", Duration = 3 })

            task.spawn(function()
                while isFavoriteBrainrotMutationLoopRunning do
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
                        pcall(function()
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
                                if uuidValue and #selectedSharedMutations > 0 then
                                    local nestedModel = tool:FindFirstChild(brainrotValue)
                                    if nestedModel then
                                        local mutationValue = nestedModel:GetAttribute("Mutation")
                                        if mutationValue and table_contains(selectedSharedMutations, mutationValue) then
                                            local args = { [1] = uuidValue }
                                            ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                            MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    task.wait(1)
                end
            end)
        else
            if isFavoriteBrainrotMutationLoopRunning then
                isFavoriteBrainrotMutationLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Brainrots", Duration = 4 })
            end
        end
    end
})

local isFavoritePlantMutationLoopRunning = false
local FavoritePlantToggle = AutoTab:Toggle({
    Title = "Auto Favorite Plants By Mutation",
    Default = false,
    Flag = "AutoFavoritePlantToggle",
    Callback = function(value)
        if value then
            if isFavoritePlantMutationLoopRunning then return end
            isFavoritePlantMutationLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Plants", Duration = 3 })

            task.spawn(function()
                while isFavoritePlantMutationLoopRunning do
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
                        pcall(function()
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
                                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
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
                                if uuidValue and #selectedSharedMutations > 0 then
                                    local nestedModel = tool:FindFirstChild(plantValue)
                                    if nestedModel then
                                        local mutationValue = nestedModel:GetAttribute("Mutation")
                                        if mutationValue and table_contains(selectedSharedMutations, mutationValue) then
                                            local args = { [1] = uuidValue }
                                            ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                            MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    task.wait(1)
                end
            end)
        else
            if isFavoritePlantMutationLoopRunning then
                isFavoritePlantMutationLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Plants", Duration = 4 })
            end
        end
    end
})

local ShopTab = Window:Tab("Shop", "rbxassetid://11385419674")

ShopTab:Section("Auto Buy Seed")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeedRemote = ReplicatedStorage.Remotes.BuyItem

local AllSeeds = { "Cactus Seed", "Strawberry Seed", "Pumpkin Seed", "Sunflower Seed", "Dragon Fruit Seed", "Eggplant Seed", "Watermelon Seed", "Grape Seed", "Cocotank Seed", "Carnivorous Plant Seed", "Mr Carrot Seed", "Tomatrio Seed", "Shroombino Seed", "Mango Seed", "King Limone Seed" }

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
    Title = "Teleport to Event",
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

EventTab:Section("Card Event")

getgenv().ActionLock = false

getgenv().AutoDailyEvent = false
local isDailyLoopRunning = false
local dailyEventZonePart = nil

local AutoDailyEventToggle = EventTab:Toggle({
    Title = "Auto Daily Event",
    Desc = "Auto Card event",
    Default = false,
    Flag = "AutoDailyEvent",
    Callback = function(value)
        getgenv().AutoDailyEvent = value
        if value then
            if isDailyLoopRunning then return end
            isDailyLoopRunning = true
            dailyEventZonePart = Instance.new("Part"); dailyEventZonePart.Name = "EventZone"; dailyEventZonePart.Size = Vector3.new(172, 66, 169); dailyEventZonePart.Position = Vector3.new(-176.95, 11.56, 976.97); dailyEventZonePart.Anchored = true; dailyEventZonePart.Transparency = 1; dailyEventZonePart.CanCollide = false; dailyEventZonePart.CastShadow = false; dailyEventZonePart.Parent = workspace
            MacUI:Notify({ Title = "Started", Content = "Start Auto Event", Duration = 3 })
            task.spawn(function()
                while isDailyLoopRunning do
                    if not getgenv().ActionLock then
                        local player = game:GetService("Players").LocalPlayer
                        if not player or not player.Character then break end
                        local UserInputService = game:GetService("UserInputService")
                        local teleportPositions = {
                            ["-1"] = CFrame.new(-218.65, 13.68, 963.75),
                            ["-2"] = CFrame.new(-218.81, 13.68, 973.73),
                            ["-3"] = CFrame.new(-218.61, 13.68, 983.85),
                            ["-4"] = CFrame.new(-218.10, 13.56, 993.87)
                        }
                        local function isToolFavorited(tool)
                            local playerGui = player.PlayerGui
                            if not playerGui then return false end
                            local hotbarSlots = UserInputService.TouchEnabled and 6 or 10
                            local hotbar = playerGui:FindFirstChild("BackpackGui", true) and playerGui.BackpackGui.Backpack:FindFirstChild("Hotbar")
                            if hotbar then
                                for i = 1, hotbarSlots do
                                    local slot = hotbar:FindFirstChild(tostring(i))
                                    local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                    if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                        if slot:FindFirstChild("HeartIcon") then return true end
                                    end
                                end
                            end
                            local inventoryFrame = playerGui:FindFirstChild("BackpackGui", true) and playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
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
                        local function isPlayerInZone(character, zone)
                            if not character or not zone then return false end
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if not hrp then return false end
                            local playerPos = hrp.Position; local zonePos = zone.Position; local zoneSize = zone.Size
                            local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
                            local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
                            local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
                            return (playerPos.X >= minX and playerPos.X <= maxX and playerPos.Y >= minY and playerPos.Y <= maxY and playerPos.Z >= minZ and playerPos.Z <= maxZ)
                        end
                        local myPlot
                        for i = 1, 6 do
                            local plot = workspace.Plots:FindFirstChild(tostring(i))
                            if plot and plot:GetAttribute("Owner") == player.Name then
                                myPlot = plot
                                break
                            end
                        end
                        if myPlot then
                            for i = -1, -4, -1 do
                                local platform = myPlot.EventPlatforms:FindFirstChild(tostring(i))
                                if platform then
                                    local ui = platform:FindFirstChild("PlatformEventUI", true)
                                    if ui and ui.Enabled then
                                        local titleLabel = ui:FindFirstChild("Title")
                                        if titleLabel then
                                            local targetBrainrotName = titleLabel.Text
                                            if targetBrainrotName and targetBrainrotName ~= "" and targetBrainrotName ~= "None" then
                                                local backpack = player:WaitForChild("Backpack")
                                                local character = player.Character
                                                local matches = {}
                                                for _, tool in ipairs(backpack:GetChildren()) do
                                                    if tool:IsA("Tool") and string.find(tool.Name, targetBrainrotName) and not isToolFavorited(tool) then
                                                        table.insert(matches, tool)
                                                    end
                                                end
                                                if character then
                                                    for _, tool in ipairs(character:GetChildren()) do
                                                        if tool:IsA("Tool") and string.find(tool.Name, targetBrainrotName) and not isToolFavorited(tool) then
                                                            table.insert(matches, tool)
                                                        end
                                                    end
                                                end
                                                if #matches > 0 then
                                                    getgenv().ActionLock = true
                                                    local toolToEquip = matches[math.random(1, #matches)]
                                                    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                                    local targetPosition = teleportPositions[tostring(i)]
                                                    if humanoidRootPart and targetPosition then
                                                        humanoidRootPart.CFrame = targetPosition
                                                        task.wait(0.5)
                                                    end
                                                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                                                       player.Character.Humanoid:EquipTool(toolToEquip)
                                                       MacUI:Notify({ Title = "Platform Event", Content = "Equipped: " .. toolToEquip.Name, Duration = 2 })
                                                       task.wait(0.5)
                                                       if isPlayerInZone(player.Character, dailyEventZonePart) then
                                                           local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                                            if rootPart then
                                                                for _, instance in ipairs(workspace:GetDescendants()) do
                                                                    if instance:IsA("ProximityPrompt") then
                                                                        local prompt = instance
                                                                        local targetPart = prompt.Parent
                                                                        if targetPart and targetPart:IsA("BasePart") then
                                                                            local distance = (targetPart.Position - rootPart.Position).Magnitude
                                                                            if distance <= prompt.MaxActivationDistance then
                                                                                prompt:InputHoldBegin(); task.wait(prompt.HoldDuration); prompt:InputHoldEnd()
                                                                                MacUI:Notify({ Title = "Event", Content = "Placed Brainrot!", Duration = 2 }); break 
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                       end
                                                    end
                                                    getgenv().ActionLock = false
                                                    break 
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1.5)
                end
            end)
        else
            if isDailyLoopRunning then
                isDailyLoopRunning = false
                if dailyEventZonePart then dailyEventZonePart:Destroy(); dailyEventZonePart = nil end
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Event", Duration = 4 })
            end
        end
    end
})

local isTomatoEventRunning = false
local savedPosition = nil

local AutoTomatoEventToggle = EventTab:Toggle({
    Title = "Auto Tomade Torelli Event",
    Desc = "Auto Event",
    Default = false,
    Flag = "AutoTomatoEvent",
    Callback = function(value)
        if value then
            if isTomatoEventRunning then return end
            isTomatoEventRunning = true

            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer
                local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and not getgenv().ActionLock then
                    local actionTextLabel = player.PlayerGui:FindFirstChild("ProximityPrompts", true) and player.PlayerGui.ProximityPrompts.Default.PromptFrame:FindFirstChild("ActionText")
                    if actionTextLabel and actionTextLabel.Text == "Talk" then
                        getgenv().ActionLock = true
                        local initialPosition = humanoidRootPart.Position
                        humanoidRootPart.CFrame = CFrame.new(-162.08, 13.56, 1019.39)
                        task.wait(1)
                        for _, p in ipairs(workspace:GetDescendants()) do if p:IsA("ProximityPrompt") then local dist=(p.Parent.Position-humanoidRootPart.Position).Magnitude; if dist<=p.MaxActivationDistance then p:InputHoldBegin();task.wait(p.HoldDuration);p:InputHoldEnd();break;end end end
                        task.wait(0.5)
                        humanoidRootPart.CFrame = CFrame.new(initialPosition)
                        getgenv().ActionLock = false
                    end
                end

                while isTomatoEventRunning do
                    if not getgenv().ActionLock then
                        local character = player.Character
                        humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                        local checkmark = workspace:FindFirstChild("ScriptedMap", true) and workspace.ScriptedMap.Event:FindFirstChild("TomadeFloor", true) and workspace.ScriptedMap.Event.TomadeFloor:FindFirstChild("GuiAttachment", true) and workspace.ScriptedMap.Event.TomadeFloor.GuiAttachment.Billboard:FindFirstChild("Checkmark")

                        if checkmark and checkmark.Visible == true then
                            if humanoidRootPart then
                                getgenv().ActionLock = true
                                savedPosition = humanoidRootPart.Position
                                humanoidRootPart.CFrame = CFrame.new(-162.08, 13.56, 1019.39)
                                task.wait(1)
                                
                                local function isPlayerInZone(character, zone)
                                    if not character or not zone then return false end
                                    local hrp = character:FindFirstChild("HumanoidRootPart")
                                    if not hrp then return false end
                                    local playerPos = hrp.Position; local zonePos = zone.Position; local zoneSize = zone.Size
                                    local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
                                    local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
                                    local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
                                    return (playerPos.X >= minX and playerPos.X <= maxX and playerPos.Y >= minY and playerPos.Y <= maxY and playerPos.Z >= minZ and playerPos.Z <= maxZ)
                                end

                                if isPlayerInZone(player.Character, eventZonePart) then
                                    local promptFrame = player.PlayerGui:WaitForChild("ProximityPrompts", 5) and player.PlayerGui.ProximityPrompts:WaitForChild("Default", 5) and player.PlayerGui.ProximityPrompts.Default:WaitForChild("PromptFrame", 5)
                                    local actionTextLabel = promptFrame and promptFrame:WaitForChild("ActionText", 5)
                                    if actionTextLabel and actionTextLabel.Text == "Claim" then
                                        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                        if rootPart then
                                            local promptPressed = false
                                            for _, instance in ipairs(workspace:GetDescendants()) do
                                                if instance:IsA("ProximityPrompt") then
                                                    local prompt = instance
                                                    local targetPart = prompt.Parent
                                                    if targetPart and targetPart:IsA("BasePart") then
                                                        local distance = (targetPart.Position - rootPart.Position).Magnitude
                                                        if distance <= prompt.MaxActivationDistance then
                                                            prompt:InputHoldBegin(); task.wait(prompt.HoldDuration); prompt:InputHoldEnd()
                                                            promptPressed = true; break 
                                                        end
                                                    end
                                                end
                                            end
                                            if promptPressed then
                                                task.wait(1)
                                                if actionTextLabel.Text == "Talk" then
                                                    for _, instance in ipairs(workspace:GetDescendants()) do
                                                        if instance:IsA("ProximityPrompt") then
                                                            local prompt = instance
                                                            local targetPart = prompt.Parent
                                                            if targetPart and targetPart:IsA("BasePart") then
                                                                local distance = (targetPart.Position - rootPart.Position).Magnitude
                                                                if distance <= prompt.MaxActivationDistance then
                                                                    prompt:InputHoldBegin(); task.wait(prompt.HoldDuration); prompt:InputHoldEnd()
                                                                    MacUI:Notify({ Title = "Tomade Torelli Event", Content = "Auto Event!", Duration = 2 }); break
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                                task.wait(0.5)
                                                humanoidRootPart.CFrame = CFrame.new(savedPosition)
                                                savedPosition = nil
                                            end
                                        end
                                    end
                                end
                                getgenv().ActionLock = false
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            if isTomatoEventRunning then
                isTomatoEventRunning = false
                if savedPosition then
                    local player = game:GetService("Players").LocalPlayer; local char = player.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(savedPosition) end
                    savedPosition = nil
                end
            end
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

local LowGraphicsToggle = SettingTab:Toggle({
    Title = "Low Graphics",
    Desc = "Reduce graphics to increase FPS",
    Default = false,
    Flag = "LowGraphics",
    Callback = function(value)
        local lighting = game:GetService("Lighting")
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        local settings = settings()
        local Players = game:GetService("Players")

        local function safeGetWorkspaceRadius()
            local ok, result = pcall(function()
                return workspace.StreamingTargetRadius
            end)
            return ok and result or 1000
        end

        local function safeSetWorkspaceRadius(radius)
            pcall(function()
                if workspace.StreamingEnabled then
                    workspace.StreamingTargetRadius = radius
                end
            end)
        end

        getgenv().LowGfxDefaultValues = getgenv().LowGfxDefaultValues or {
            QualityLevel = settings.Rendering.QualityLevel,
            GlobalShadows = lighting.GlobalShadows,
            FogEnd = lighting.FogEnd,
            Brightness = lighting.Brightness,
            Ambient = lighting.Ambient,
            OutdoorAmbient = lighting.OutdoorAmbient,
            WaterWaveSize = terrain and terrain.WaterWaveSize or nil,
            WaterWaveSpeed = terrain and terrain.WaterWaveSpeed or nil,
            WaterReflectance = terrain and terrain.WaterReflectance or nil,
            WaterTransparency = terrain and terrain.WaterTransparency or nil,
            MaxRenderDistance = safeGetWorkspaceRadius()
        }
        getgenv().LowGfxChangedObjects = getgenv().LowGfxChangedObjects or {}
        getgenv().LowGfxDecalData = getgenv().LowGfxDecalData or {}

        local DefaultValues = getgenv().LowGfxDefaultValues
        local ChangedObjects = getgenv().LowGfxChangedObjects
        local DecalData = getgenv().LowGfxDecalData

        if value then
            settings.Rendering.QualityLevel = Enum.QualityLevel.Level01
            safeSetWorkspaceRadius(200)

            lighting.GlobalShadows = false
            lighting.FogEnd = 500
            lighting.Brightness = 1
            lighting.Ambient = Color3.new(1, 1, 1)
            lighting.OutdoorAmbient = Color3.new(1, 1, 1)

            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end

            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    if v.Enabled then
                        ChangedObjects[v] = true
                        v.Enabled = false
                    end
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    if v:IsA("Decal") and v.Texture ~= "" then
                        DecalData[v] = v.Texture
                        v.Texture = ""
                    elseif v:IsA("Texture") and v.Transparency < 1 then
                        ChangedObjects[v] = v.Transparency
                        v.Transparency = 1
                    end
                elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                    if v.Enabled then
                        ChangedObjects[v] = true
                        v.Enabled = false
                    end
                end
            end

            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    for _, part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CastShadow = false
                        end
                    end
                end
            end

        else
            settings.Rendering.QualityLevel = DefaultValues.QualityLevel
            safeSetWorkspaceRadius(DefaultValues.MaxRenderDistance)
            lighting.GlobalShadows = DefaultValues.GlobalShadows
            lighting.FogEnd = DefaultValues.FogEnd
            lighting.Brightness = DefaultValues.Brightness
            lighting.Ambient = DefaultValues.Ambient
            lighting.OutdoorAmbient = DefaultValues.OutdoorAmbient

            if terrain and DefaultValues.WaterWaveSize then
                terrain.WaterWaveSize = DefaultValues.WaterWaveSize
                terrain.WaterWaveSpeed = DefaultValues.WaterWaveSpeed
                terrain.WaterReflectance = DefaultValues.WaterReflectance
                terrain.WaterTransparency = DefaultValues.WaterTransparency
            end

            for v, old in pairs(ChangedObjects) do
                if v and v.Parent then
                    if typeof(old) == "boolean" then
                        v.Enabled = old
                    elseif typeof(old) == "number" then
                        v.Transparency = old
                    end
                end
            end
            getgenv().LowGfxChangedObjects = {}

            for v, tex in pairs(DecalData) do
                if v and v.Parent then
                    v.Texture = tex
                end
            end
            getgenv().LowGfxDecalData = {}

            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    for _, part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CastShadow = true
                        end
                    end
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
        DiscordLabel:SetText("If you found errors or want to me create another map script, please let us know on Discord. We listen to all your problems.")
        CopyDiscordButton:SetTitle("Copy Discord Link")
        CopyDiscordButton:SetDesc("Click to copy the Discord invite link.")
        AntiAFKToggle:SetTitle("Anti AFK")
        AutoTeleportToggle:SetTitle("Auto Farm Brainrot")
        SpeedSlider:SetTitle("Hit Speed")
        AutoFarmToggle:SetTitle("Auto Hit")
        BestBrainrotsLabel:SetText("1 = 1 sec / 600 = 10 min")
        DelaySlider:SetTitle("Equip Best Brainrots Delay")
        AutoEquipToggle:SetTitle("Auto Equip Best Brainrots")
        EggDropdown:SetTitle("Select Eggs to Open")
        AutoOpenEggToggle:SetTitle("Auto Open Egg")
        BrainrotRarityDropdown:SetTitle("Select Rarity")
        FavoriteBrainrotToggle:SetTitle("Auto Favorite Brainrot By Rarity")
        PlantRarityDropdown:SetTitle("Select Rarity")
        FavoritePlantToggle:SetTitle("Auto Favorite Plants By Rarity")
        SharedMutationDropdown:SetTitle("Select Mutation")
        FavoriteBrainrotToggle:SetTitle("Auto Favorite Brainrot By Mutation")
        FavoritePlantToggle:SetTitle("Auto Favorite Plants By Mutation")
        SeedDropdown:SetTitle("Select Seeds")
        AutoBuySeedSelectedToggle:SetTitle("Auto Buy Seed [Selected]")
        AutoBuyAllToggle:SetTitle("Auto Buy Seed [All]")
        ItemDropdown:SetTitle("Select Gear")
        AutoBuySelectedToggle:SetTitle("Auto Buy Gear [Selected]")
        AutoBuyGearAllToggle:SetTitle("Auto Buy Gear [All]")
        SellBrainrotLabel:SetText("1 = 1 sec / 600 = 10 min")
        SellDelaySlider:SetTitle("Sell Brainrots Delay")
        AutoSellToggle:SetTitle("Auto Sell Brainrots All")
        AutoSellFullToggle:SetTitle("Auto Sell Brainrots All When Inventory Full")
        SellPlantLabel:SetText("1 = 1 sec / 600 = 10 min")
        PlantSellDelaySlider:SetTitle("Sell Plants Delay")
        AutoSellPlantsToggle:SetTitle("Auto Sell Plants All")
        AutoSellPlantsFullToggle:SetTitle("Auto Sell Plants All When Inventory Full")
        AutoSellAllFullToggle:SetTitle("Auto Sell All When Inventory Full")
        TeleportGrassButton:SetTitle("Teleport to Plots")
        TeleportGrassButton:SetDesc("Goto Your Plots")
        TeleportFixedButton:SetTitle("Teleport to Prison Event")
        TeleportFixedButton:SetDesc("Goto Event Area")
        AutoDailyEventToggle:SetTitle("Auto Daily Event")
        AutoTomatoEventToggle:SetTitle("Auto Tomade Torelli Event")
        HideNotificationsToggle:SetTitle("Hide Notifications")
        LowGraphicsToggle:SetTitle("Low Graphics")
        LanguageDropdown:SetTitle("Select Language")
        ApplyButton:SetTitle("Apply")
        ApplyButton:SetDesc("Apply the selected language")
    end,
    
    ["ภาษาไทย"] = function()
        DiscordLabel:SetText("เจอ error หรือต่าง, อยากให้สร้างสคริปแมพอื่น, แจ้งมาได้ที่ ดิสคอร์ด รับฟังทุกปัญหา")
        CopyDiscordButton:SetTitle("คักลอกลิ้งดิสคอร์ด")
        CopyDiscordButton:SetDesc("กดเพื่อคัดลอกลิงก์เชิญ Discord")
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
        SharedMutationDropdown:SetTitle("เลือกสถานะ")
        FavoriteBrainrotToggle:SetTitle("ล็อคหัวใจ Brainrot อัตโนมัติ [ตามสถานะที่เลือก]")
        FavoritePlantToggle:SetTitle("ล็อคหัวใจ Plants อัตโนมัติ [ตามสถานะที่เลือก]")
        SeedDropdown:SetTitle("เลือกเมล็ดพันธุ์")
        AutoBuySeedSelectedToggle:SetTitle("ซื้อเมล็ดพันธุ์อัตโนมัติ [ที่เลือก]")
        AutoBuyAllToggle:SetTitle("ซื้อเมล็ดพันธุ์อัตโนมัติ [ทั้งหมด]")
        ItemDropdown:SetTitle("เลือกอุปกรณ์")
        AutoBuySelectedToggle:SetTitle("ซื้ออุปกรณ์อัตโนมัติ [ที่เลือก]")
        AutoBuyGearAllToggle:SetTitle("ซื้ออุปกรณ์อัตโนมัติ [ทั้งหมด]")
        SellBrainrotLabel:SetText("1 = 1วิ / 600วิ = 10นาที")
        SellDelaySlider:SetTitle("ดีเลย์การขาย Brainrot ทั้งหมด")
        AutoSellToggle:SetTitle("ขาย Brainrot ทั้งหมดอัตโนมัติ")
        AutoSellFullToggle:SetTitle("ขาย Brainrot ทั้งหมดอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        SellPlantLabel:SetText("1 = 1วิ / 600วิ = 10นาที")
        PlantSellDelaySlider:SetTitle("ดีเลย์การขาย Plant ทั้งหมด")
        AutoSellPlantsToggle:SetTitle("ขาย Plant ทั้งหมดอัตโนมัติ")
        AutoSellPlantsFullToggle:SetTitle("ขาย Plant ทั้งหมดอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        AutoSellAllFullToggle:SetTitle("ขายทั้งสองอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        TeleportGrassButton:SetTitle("วาปไปสวนของตัวเอง")
        TeleportGrassButton:SetDesc("วาปไปที่พล็อต")
        TeleportFixedButton:SetTitle("วาปไปอีเว้น")
        TeleportFixedButton:SetDesc("วาปไปสถานที่อีเว้น")
        AutoDailyEventToggle:SetTitle("ออโต้ทำอีเว้นรายวันอัตโนมัติ")
        AutoTomatoEventToggle:SetTitle("ออโต้รับของจาก Tomade Torelli")
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

