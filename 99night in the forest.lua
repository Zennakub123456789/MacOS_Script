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
                    local landmarks = workspace.Map:WaitForChild("Landmarks", 60)
                    
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
                            
                            task.wait(0.2)

                            CurrentCamera.CFrame = fixedCameraCFrame

                            local viewportSize = CurrentCamera.ViewportSize
                            local centerScreenPosition = Vector2.new(viewportSize.X * 0.55, viewportSize.Y * 0.5)
                            
                            VirtualInputManager:SendMouseButtonEvent(centerScreenPosition.X, centerScreenPosition.Y, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(centerScreenPosition.X, centerScreenPosition.Y, 0, false, game, 1)
                            
                            task.wait()
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
            local targetCFrame = CFrame.new(firePosition.X + xOffset, firePosition.Y + 20, firePosition.Z + zOffset)
            
            item:SetPrimaryPartCFrame(targetCFrame)

            local args = {item}
            StartDragging:FireServer(unpack(args))
            StopDragging:FireServer(unpack(args))
            
            task.wait(0.1) 
            
            local expectedHeight = firePosition.Y + 20
            if math.abs(primaryPart.Position.Y - expectedHeight) < 0.5 then
                if primaryPart.Anchored then
                    primaryPart.Anchored = false
                end
            end

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
