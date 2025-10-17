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
                            local centerScreenPosition = Vector2.new(viewportSize.X * 0.5, viewportSize.Y * 0.5)
                            
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
