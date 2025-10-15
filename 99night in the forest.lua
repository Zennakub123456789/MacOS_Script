local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zennakub123456789/MacOS/refs/heads/main/Main(1)_1760432973040(1).lua"))()

local imageUrl = "https://raw.githubusercontent.com/Zennakub123456789/picture/main/TadHub-Icon.png"
local imageName = "TadHub-Icon.png"

if not isfile(imageName) then
    local imageData = game:HttpGet(imageUrl)
    writefile(imageName, imageData)
end

local iconPath = getcustomasset(imageName)

local Window = MacUI:Window({
    Title = "Tad Hub | 99 Night In The Forest",
    Size = UDim2.new(0, 600, 0, 350),
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

