local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zennakub123456789/Apple-Library/refs/heads/main/Main_Fixed(2).lua"))()

local imageUrl = "https://raw.githubusercontent.com/Zennakub123456789/picture/main/TadHub-Icon.png"
local imageName = "TadHub-Icon.png"

if not isfile(imageName) then
    local imageData = game:HttpGet(imageUrl)
    writefile(imageName, imageData)
end

local iconPath = getcustomasset(imageName)

local Window = MacUI:Window({
    Title = "Tad Hub | 99 Night In The Forest",
    Size = UDim2.new(0, 475, 0, 325),
    Theme = "Dark",
    Icon = iconPath,
    LoadingTitle = "MacUI",
    LoadingSubtitle = "Loading...",
    ToggleUIKeybind = "K",
    ShowToggleButton = true,
    ToggleIcon = iconPath,
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

local AutoTab = Window:Tab("Auto", "rbxassetid://7733779610")

AutoTab:Section("Auto Correct")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local AutoCollectToggle = AutoTab:Toggle({
    Title = "Auto Collect Coin Stack",
    Default = false,
    Flag = "AutoCollectCoinStack",
    Callback = function(state)
        getgenv().AutoCollectCoinStack = state
        
        if state then
            task.spawn(function()
                while getgenv().AutoCollectCoinStack do
                    local coins = {}
                    for _, item in ipairs(workspace.Items:GetChildren()) do
                        if item.Name == "Coin Stack" and item:IsA("Model") then
                            table.insert(coins, item)
                        end
                    end

                    for _, coin in ipairs(coins) do
                        if not getgenv().AutoCollectCoinStack then break end
                        
                        local playerCharacter = game.Players.LocalPlayer.Character
                        if coin and coin.PrimaryPart and playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                            local hrp = playerCharacter.HumanoidRootPart
                            hrp.CFrame = coin:GetPrimaryPartCFrame() + Vector3.new(0, 3, 0)

                            local success, err = pcall(function()
                                game:GetService("ReplicatedStorage").RemoteEvents.RequestCollectCoints:InvokeServer(coin)
                            end)
                            if not success then
                                warn("Error invoking remote: " .. tostring(err))
                            end

                            task.wait()
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local CurrentCamera = workspace.CurrentCamera

local AutoPickFlowerToggle = AutoTab:Toggle({
    Title = "Auto Pick Flower",
    Default = false,
    Flag = "AutoPickFlower",
    Callback = function(state)
        getgenv().AutoPickFlower = state
        
        if state then
            local fixedCameraCFrame = CFrame.new(14.583221, 18.645473, 28.576258) * CFrame.fromOrientation(-1.384744, -1.639596, 0.000000)
            CurrentCamera.CFrame = fixedCameraCFrame

            task.spawn(function()
                while getgenv().AutoPickFlower do
                    local landmarks = workspace.Map:FindFirstChild("Landmarks", 60)
                    
                    if not landmarks then
                        warn("หาโฟลเดอร์ Landmarks ไม่เจอ!")
                        break
                    end

                    local flowers = {}
                    
                    for _, landmarkItem in ipairs(landmarks:GetChildren()) do
                        if landmarkItem.Name == "Flower" and landmarkItem:IsA("Model") then
                            table.insert(flowers, landmarkItem)
                        
                        elseif landmarkItem.Name == "FlowerRing1" and landmarkItem:IsA("Model") then
                            for _, nestedItem in ipairs(landmarkItem:GetChildren()) do
                                if nestedItem.Name == "Flower" and nestedItem:IsA("Model") then
                                    table.insert(flowers, nestedItem)
                                end
                            end

                        elseif landmarkItem.Name == "Fairy House" and landmarkItem:IsA("Model") then
                            local flowersFolder = landmarkItem:FindFirstChild("Flowers")
                            if flowersFolder then
                                for _, flower in ipairs(flowersFolder:GetChildren()) do
                                    if flower.Name == "Flower" and flower:IsA("Model") then
                                        table.insert(flowers, flower)
                                    end
                                end
                            end
                        end
                    end

                                        for _, flower in ipairs(flowers) do
                        if not getgenv().AutoPickFlower then break end
                        
                        local playerCharacter = game.Players.LocalPlayer.Character
                        if flower and flower.PrimaryPart and playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                            local hrp = playerCharacter.HumanoidRootPart
                            
                            hrp.CFrame = flower:GetPrimaryPartCFrame() + Vector3.new(0, 3, 0)
                            
                            task.wait(0.5) 

                            CurrentCamera.CFrame = fixedCameraCFrame
                            task.wait(0.1)

                            local viewportSize = CurrentCamera.ViewportSize
                            local centerScreenPosition = Vector2.new(viewportSize.X * 0.55, viewportSize.Y * 0.5)
                            VirtualInputManager:SendMouseButtonEvent(centerScreenPosition.X, centerScreenPosition.Y, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(centerScreenPosition.X, centerScreenPosition.Y, 0, false, game, 1)
                            
                            task.wait(0.2)
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

AutoTab:Section("Auto Campfire")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local StartDragging = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
local StopDragging = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")

local function bringSelectedItemsToFire()
    local mainFire = workspace.Map.Campground:WaitForChild("MainFire")
    if not mainFire or not mainFire.PrimaryPart then
        return
    end
    local firePosition = mainFire.PrimaryPart.Position

    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        return
    end
    
    if not getgenv().ItemsToBring or #getgenv().ItemsToBring == 0 then
        return
    end

    local spacing = 3
    local offsetIndex = 0

    for _, item in ipairs(itemsFolder:GetChildren()) do
        if not getgenv().AutoBringItems then
            break
        end

        if item:IsA("Model") and table.find(getgenv().ItemsToBring, item.Name) then
            local primaryPart = item.PrimaryPart
            if not primaryPart then
                primaryPart = Instance.new("Part")
                primaryPart.Name = "PrimaryPartForBring"
                primaryPart.Size = Vector3.new(1, 1, 1)
                primaryPart.Anchored = true
                primaryPart.Transparency = 1
                primaryPart.CanCollide = false
                primaryPart.CFrame = item:GetModelCFrame() or CFrame.new(firePosition)
                primaryPart.Parent = item
                item.PrimaryPart = primaryPart
            end

            primaryPart.Anchored = true
            
            local angle = math.rad(offsetIndex * 45)
            local xOffset = math.cos(angle) * spacing
            local zOffset = math.sin(angle) * spacing
            local targetCFrame = CFrame.new(firePosition.X + xOffset, firePosition.Y + 50, firePosition.Z + zOffset)
            
            item:SetPrimaryPartCFrame(targetCFrame)

            task.wait(1)

            while not (workspace.Map.Campground:FindFirstChild("MainFire") and workspace.Map.Campground.MainFire.PrimaryPart) do
                task.wait(0.5)
            end

            local args = {item}
            StartDragging:FireServer(unpack(args))
            
            local expectedHeight = firePosition.Y + 50
            if math.abs(primaryPart.Position.Y - expectedHeight) > 0.5 then
                item:SetPrimaryPartCFrame(targetCFrame)
                task.wait(0.5)
            end
            
            if primaryPart.Anchored then
                primaryPart.Anchored = false
            end
            
            StopDragging:FireServer(unpack(args))
            
            offsetIndex = offsetIndex + 1
            task.wait(0.3)
        end
    end
end

local ItemSelector = AutoTab:Dropdown({
    Title = "Fuel Select",
    Options = {"Log", "Fuel Canister", "Coal", "AnotherItem1", "AnotherItem2", "AnotherItem3", "AnotherItem4"}, 
    Multi = true,
    Default = {"Log"},
    Flag = "SelectedItems",
    Callback = function(selectedItems)
        getgenv().ItemsToBring = selectedItems
    end
})
getgenv().ItemsToBring = ItemSelector:Get()

local FireThresholdSlider = AutoTab:Slider({
    Title = "Start Fuel when (Fire HP)",
    Min = 1,
    Max = 100,
    Default = 50,
    Flag = "FireThreshold",
    Callback = function(value)
        getgenv().FireThreshold = value
    end
})
getgenv().FireThreshold = FireThresholdSlider:Get()

local CheckFireToggle
CheckFireToggle = AutoTab:Toggle({
    Title = "Auto Fill Campfire",
    Default = false,
    Flag = "AutoBringItems",
    Callback = function(state)
        getgenv().AutoBringItems = state

        if state then
            task.spawn(function()
                while getgenv().AutoBringItems do
                    while not workspace.Map.Campground:FindFirstChild("MainFire") and getgenv().AutoBringItems do
                        task.wait(1)
                    end

                    if not getgenv().AutoBringItems then break end

                    local mainFire = workspace.Map.Campground:FindFirstChild("MainFire")
                    local textLabel = mainFire and mainFire:FindFirstChild("Center") and mainFire.Center:FindFirstChild("BillboardGui") and mainFire.Center.BillboardGui:FindFirstChild("Frame") and mainFire.Center.BillboardGui.Frame:FindFirstChild("TextLabel")
                    local currentProgress = nil

                    local progressText = textLabel and string.match(textLabel.Text, "(%d+/%d+)")

                    if progressText then
                        local parts = string.split(progressText, "/")
                        currentProgress = tonumber(parts[1])
                    elseif mainFire then
                        local fuelRemaining = mainFire:GetAttribute("FuelRemaining")
                        local fuelTarget = mainFire:GetAttribute("FuelTarget")

                        if fuelRemaining and fuelTarget and fuelTarget > 0 then
                            currentProgress = math.floor((fuelRemaining / fuelTarget) * 100)
                        end
                    end

                    if currentProgress and getgenv().FireThreshold then
                        if currentProgress < getgenv().FireThreshold then
                            bringSelectedItemsToFire()
                        end
                    end
                    
                    task.wait(1)
                end
            end)
        end
    end
})

AutoTab:Section("Auto Open Chest And Bring")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local RequestOpenItemChest = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestOpenItemChest")

local StartDragging = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
local StopDragging = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")

local chestNamesToOpen = {
    "Item Chest",
    "Item Chest2",
    "Item Chest3",
    "Item Chest4",
    "Item Chest5",
    "Snow Chest1",
    "Snow Chest2",
    "Volcanic Chest1",
    "Volcanic Chest2"
}

local function bringItemToPlayer(item)
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if item and item:IsA("Model") then
        local primaryPart = item.PrimaryPart
        if not primaryPart then
            primaryPart = Instance.new("Part")
            primaryPart.Name = "PrimaryPartForBring"
            primaryPart.Size = Vector3.new(1, 1, 1)
            primaryPart.Anchored = true
            primaryPart.Transparency = 1
            primaryPart.CanCollide = false
            primaryPart.CFrame = item:GetModelCFrame() or hrp.CFrame
            primaryPart.Parent = item
            item.PrimaryPart = primaryPart
        end

        primaryPart.Anchored = true
        local targetCFrame = hrp.CFrame * CFrame.new(0, 5, 0)
        item:SetPrimaryPartCFrame(targetCFrame)

        local args = {item}
        pcall(function() StartDragging:FireServer(unpack(args)) end)
        
        if primaryPart.Anchored then
            primaryPart.Anchored = false
        end
        
        pcall(function() StopDragging:FireServer(unpack(args)) end)
    end
end

local CheckChestToggle
CheckChestToggle = AutoTab:Toggle({
    Title = "Auto Open Item Chests",
    Default = false,
    Flag = "AutoOpenChests",
    Callback = function(state)
        getgenv().AutoOpenChests = state

        if state then
            task.spawn(function()
                while getgenv().AutoOpenChests do
                    local itemsFolder = workspace:FindFirstChild("Items")
                    if itemsFolder then
                        
                        local chestsToProcess = {}
                        for _, item in ipairs(itemsFolder:GetChildren()) do
                            if item:IsA("Model") and table.find(chestNamesToOpen, item.Name) then
                                table.insert(chestsToProcess, item)
                            end
                        end

                        if #chestsToProcess > 0 then
                            for _, chest in ipairs(chestsToProcess) do
                                if not getgenv().AutoOpenChests then break end

                                local itemDropPart = chest:FindFirstChild("ItemDrop")
                                
                                if not itemDropPart then
                                    continue
                                end

                                local isAlreadyOpened = chest:GetAttribute("LocalOpened")

                                if isAlreadyOpened ~= true then
                                    local args = {[1] = chest}
                                    pcall(function() RequestOpenItemChest:FireServer(unpack(args)) end)
                                    task.wait(1.5)
                                end

                                local dropPosition = itemDropPart.Position
                                local checkRadius = 15
                                
                                for _, item in ipairs(itemsFolder:GetChildren()) do
                                    if item:IsA("Model") and item ~= chest then
                                        local itemPart = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                                        if itemPart then
                                            local distance = (itemPart.Position - dropPosition).Magnitude
                                            
                                            -- ▼▼▼ [ปรับปรุง] นำ task.wait(0.1) กลับมา ▼▼▼
                                            if distance <= checkRadius then
                                                bringItemToPlayer(item)
                                                task.wait(0.1) -- รอ 0.1 วินาที ก่อนไปเก็บชิ้นต่อไป
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        
                    end
                    
                    task.wait(1)
                end
            end)
        end
    end
})

AutoTab:Section("Plant Stuff")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local StartDragging = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem")
local StopDragging = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem")
local RequestPlantItem = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem")

getgenv().BroughtSaplings = {}

local function bringSingleSapling(item, targetCFrame)
    local primaryPart = item.PrimaryPart
    if not primaryPart then
        primaryPart = Instance.new("Part")
        primaryPart.Name = "PrimaryPartForBring"
        primaryPart.Size = Vector3.new(1, 1, 1)
        primaryPart.Anchored = true
        primaryPart.Transparency = 1
        primaryPart.CanCollide = false
        primaryPart.CFrame = item:GetModelCFrame() or CFrame.new(targetCFrame.Position)
        primaryPart.Parent = item
        item.PrimaryPart = primaryPart
    end

    primaryPart.Anchored = true
    item:SetPrimaryPartCFrame(targetCFrame)
    task.wait(1)

    local args = {item}
    StartDragging:FireServer(unpack(args))
    
    if (primaryPart.CFrame.Position - targetCFrame.Position).Magnitude > 0.5 then
        item:SetPrimaryPartCFrame(targetCFrame)
        task.wait(0.5)
    end
    
    if primaryPart.Anchored then
        primaryPart.Anchored = false
    end
    
    StopDragging:FireServer(unpack(args))
    
    if not table.find(getgenv().BroughtSaplings, item) then
        table.insert(getgenv().BroughtSaplings, item)
    end
end

local function bringSaplingsToFireCircle()
    local mainFire = workspace.Map.Campground:WaitForChild("MainFire")
    if not mainFire or not mainFire.PrimaryPart then return end
    local centerPosition = mainFire.PrimaryPart.Position

    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then return end
    
    local allAvailableSaplings = {}
    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item:IsA("Model") and item.Name == "Sapling" then
            table.insert(allAvailableSaplings, item)
        end
    end

    if #allAvailableSaplings == 0 then
        print("No saplings found.")
        return 
    end

    local size = getgenv().CircleRadius or 10
    local sampleSapling = allAvailableSaplings[1]
    local itemSize = sampleSapling:GetExtentsSize()
    local itemDiameter = math.max(itemSize.X, itemSize.Z)
    local desiredGap = 0 
    local spacePerItem = itemDiameter + desiredGap
    
    local bringMode = getgenv().BringMode or "Circle"
    local totalPerimeter = 0
    
    if bringMode == "Circle" then
        totalPerimeter = 2 * math.pi * size
    else
        totalPerimeter = 8 * size
    end
    
    local maxItemsToBring = math.floor(totalPerimeter / spacePerItem)
    
    local densityMultiplier = 1.5
    maxItemsToBring = math.floor(maxItemsToBring * densityMultiplier)
    
    local waitForFull = getgenv().WaitForFull or false
    
    if waitForFull == true then
        if #allAvailableSaplings < maxItemsToBring then
            local missing = maxItemsToBring - #allAvailableSaplings
            print("Waiting for " .. missing .. " more saplings. (Have " .. #allAvailableSaplings .. "/" .. maxItemsToBring .. ")")
            if MacUI and MacUI.Notify then
                MacUI:Notify({ Title = "Waiting for Saplings", Content = "Need " .. missing .. " more. (Have " .. #allAvailableSaplings .. "/" .. maxItemsToBring .. ")", Duration = 3 })
            end
            return
        end
    end

    local numToActuallyBring = math.min(#allAvailableSaplings, maxItemsToBring)
    
    print("Mode: " .. bringMode .. ". Size: " .. size .. ". Density: 1.5x. Bringing " .. numToActuallyBring .. " saplings.")
    
    if numToActuallyBring == 0 then
        print("Size is too small to fit any saplings.")
        return
    end

    local saplingsToBring = {}
    for i = 1, numToActuallyBring do
        table.insert(saplingsToBring, allAvailableSaplings[i])
    end
    
    local angleIncrement = 0
    local spacing = 0
    
    if bringMode == "Circle" then
        angleIncrement = (2 * math.pi) / maxItemsToBring
    else
        spacing = totalPerimeter / maxItemsToBring
    end

    for i, item in ipairs(saplingsToBring) do
        local xOffset, zOffset = 0, 0
        local targetCFrame
        
        if bringMode == "Circle" then
            local angle = i * angleIncrement
            xOffset = math.cos(angle) * size
            zOffset = math.sin(angle) * size
            
        else
            local totalDist = i * spacing
            local sideLength = 2 * size
            
            if totalDist <= sideLength then
                xOffset = -size + totalDist
                zOffset = -size
            elseif totalDist <= sideLength * 2 then
                xOffset = size
                zOffset = -size + (totalDist - sideLength)
            elseif totalDist <= sideLength * 3 then
                xOffset = size - (totalDist - (sideLength * 2))
                zOffset = size
            else
                xOffset = -size
                zOffset = size - (totalDist - (sideLength * 3))
            end
        end
        
        targetCFrame = CFrame.new(centerPosition.X + xOffset, centerPosition.Y, centerPosition.Z + zOffset)
        task.spawn(bringSingleSapling, item, targetCFrame)
    end
end

local CircleRadiusSlider = AutoTab:Slider({
    Title = "Build Size",
    Desc = "Radius for Circle, Size for Square",
    Min = 5,
    Max = 25,
    Default = 10,
    Flag = "CircleRadius",
    Callback = function(value)
        getgenv().CircleRadius = value
    end
})
getgenv().CircleRadius = CircleRadiusSlider:Get()

local ModeDropdown = AutoTab:Dropdown({
    Title = "Building Mode",
    Options = {"Circle", "Square"},
    Default = "Circle",
    Flag = "BringMode",
    Callback = function(selected)
        getgenv().BringMode = selected
    end
})
getgenv().BringMode = ModeDropdown:Get()

local BringSaplingsButton = AutoTab:Button({
    Title = "Bring Saplings",
    Desc = "Bring Sapling",
    Callback = function()
        task.spawn(bringSaplingsToFireCircle)
    end
})

local AutoPlantButton = AutoTab:Button({
    Title = "Plant Saplings",
    Desc = "Auto Plant Sapling",
    Callback = function()
        task.spawn(function()
            local saplingsToPlant = getgenv().BroughtSaplings
            getgenv().BroughtSaplings = {}
            local plantCount = #saplingsToPlant
            local plantedCounter = 0

            if plantCount == 0 then
                if MacUI and MacUI.Notify then
                    MacUI:Notify({ Title = "Planting", Content = "Nothing to plant.", Duration = 3 })
                end
                print("Nothing to plant.")
                return
            end

            for _, item in ipairs(saplingsToPlant) do
                if item and item.PrimaryPart then
                    task.spawn(function()
                        local itemPosition = item.PrimaryPart.Position
                        local args = { [1] = item, [2] = itemPosition }
                        pcall(function() RequestPlantItem:InvokeServer(unpack(args)) end)
                        plantedCounter = plantedCounter + 1
                    end)
                else
                    plantedCounter = plantedCounter + 1
                end
            end
            
            while plantedCounter < plantCount do
                task.wait()
            end
            
            if MacUI and MacUI.Notify then
                MacUI:Notify({
                    Title = "Planting Complete",
                    Content = "Finished planting " .. plantCount .. " saplings.",
                    Duration = 4
                })
            end
            print("Planting Complete. Finished " .. plantCount .. " saplings.")
        end)
    end
})

local WaitForFullToggle = AutoTab:Toggle({
    Title = "Wait until the Sapling is full before Bring",
    Desc = "If ON, 'Bring' button will wait until you have enough saplings.",
    Default = false,
    Flag = "WaitForFull",
    Callback = function(value)
        getgenv().WaitForFull = value
    end
})
getgenv().WaitForFull = WaitForFullToggle:Get()

local PreviewToggle = AutoTab:Toggle({
    Title = "Preview Build",
    Desc = "Shows a preview based on Mode and Size.",
    Default = false,
    Flag = "PreviewTreeToggle",
    Callback = function(value)
        
        if value == true then
            task.spawn(function()
                local oldPreviewFolder = workspace:FindFirstChild("Preview")
                if oldPreviewFolder then oldPreviewFolder:Destroy() end
                
                local previewFolder = Instance.new("Folder")
                previewFolder.Name = "Preview"
                previewFolder.Parent = workspace
                
                local mainFire = workspace.Map.Campground:WaitForChild("MainFire")
                if not mainFire or not mainFire.PrimaryPart then print("Preview Error: Cannot find MainFire") return end
                local centerPosition = mainFire.PrimaryPart.Position
                
                local itemsFolder = workspace:FindFirstChild("Items")
                local allAvailableSaplings = {}
                if itemsFolder then
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item:IsA("Model") and item.Name == "Sapling" then
                            table.insert(allAvailableSaplings, item)
                        end
                    end
                end
                if #allAvailableSaplings == 0 then print("Preview Error: No 'Sapling' found to calculate spacing.") previewFolder:Destroy() return end
                local sampleSapling = allAvailableSaplings[1]
                
                local landmarks = workspace.Map:FindFirstChild("Landmarks")
                local allTrees = {}
                if landmarks then
                    for _, item in ipairs(landmarks:GetChildren()) do
                        if item:IsA("Model") and item.Name == "Small Tree" then
                            table.insert(allTrees, item)
                        end
                    end
                end
                if #allTrees == 0 then print("Preview Error: No 'Small Tree' found to clone.") previewFolder:Destroy() return end
                local treeTemplate = allTrees[math.random(1, #allTrees)]
                
                local size = getgenv().CircleRadius or 10 
                local itemSize = sampleSapling:GetExtentsSize()
                local itemDiameter = math.max(itemSize.X, itemSize.Z)
                local desiredGap = 0 
                local spacePerItem = itemDiameter + desiredGap
                
                local bringMode = getgenv().BringMode or "Circle"
                local totalPerimeter = 0
                if bringMode == "Circle" then
                    totalPerimeter = 2 * math.pi * size
                else
                    totalPerimeter = 8 * size
                end
                
                local maxItemsToBring = math.floor(totalPerimeter / spacePerItem)
                local densityMultiplier = 1.5
                maxItemsToBring = math.floor(maxItemsToBring * densityMultiplier)

                if maxItemsToBring == 0 then print("Preview: Size is too small.") previewFolder:Destroy() return end
                
                local angleIncrement = 0
                local spacing = 0
                if bringMode == "Circle" then
                    angleIncrement = (2 * math.pi) / maxItemsToBring
                else
                    spacing = totalPerimeter / maxItemsToBring
                end

                for i = 1, maxItemsToBring do
                    local xOffset, zOffset = 0, 0
                    local targetCFrame

                    if bringMode == "Circle" then
                        local angle = i * angleIncrement
                        xOffset = math.cos(angle) * size
                        zOffset = math.sin(angle) * size
                    else
                        local totalDist = i * spacing
                        local sideLength = 2 * size
                        if totalDist <= sideLength then
                            xOffset = -size + totalDist
                            zOffset = -size
                        elseif totalDist <= sideLength * 2 then
                            xOffset = size
                            zOffset = -size + (totalDist - sideLength)
                        elseif totalDist <= sideLength * 3 then
                            xOffset = size - (totalDist - (sideLength * 2))
                            zOffset = size
                        else
                            xOffset = -size
                            zOffset = size - (totalDist - (sideLength * 3))
                        end
                    end
                    
                    targetCFrame = CFrame.new(centerPosition.X + xOffset, centerPosition.Y, centerPosition.Z + zOffset)
                    local treeClone = treeTemplate:Clone()
                    treeClone.Parent = previewFolder
                    
                    for _, part in ipairs(treeClone:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Material = Enum.Material.Neon
                            part.Color = Color3.fromRGB(0, 200, 255)
                            part.Transparency = 0.5
                            part.CanCollide = false
                            part.Anchored = true
                        end
                    end
                    if not treeClone.PrimaryPart then
                        local p = Instance.new("Part"); p.Name = "PreviewPrimaryPart"; p.Size = Vector3.new(1,1,1); p.Transparency = 1; p.CanCollide = false; p.Anchored = true; p.Parent = treeClone; treeClone.PrimaryPart = p
                    end
                    treeClone:SetPrimaryPartCFrame(targetCFrame)
                end
                print("Preview created with " .. maxItemsToBring .. " trees.")
            end)
        else
            task.spawn(function()
                local previewFolder = workspace:FindFirstChild("Preview")
                if previewFolder then
                    previewFolder:Destroy()
                    print("Preview folder removed.")
                end
            end)
        end
    end
})

if PreviewToggle:Get() == false then
    task.spawn(function()
        local previewFolder = workspace:FindFirstChild("Preview")
        if previewFolder then
            previewFolder:Destroy()
        end
    end)
end
