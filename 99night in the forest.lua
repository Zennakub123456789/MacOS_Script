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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local Toggle = Tab:Toggle({
    Title = "Auto Collect Coin Stack",
    Desc = "เปิดเพื่อวาปไปเก็บ Coin Stack ทุกอันใน Workspace.Items",
    Icon = "star",
    Type = "Checkbox",
    Default = false,
    Callback = function(state)
        getgenv().AutoCollectCoinStack = state
        if state then
            spawn(function()
                while getgenv().AutoCollectCoinStack do
                    -- ดึง Coin Stack ทั้งหมดใน Workspace.Items
                    local coins = {}
                    for _, item in ipairs(workspace.Items:GetChildren()) do
                        if item.Name == "Coin Stack" and item:IsA("Model") then
                            table.insert(coins, item)
                        end
                    end

                    -- วาปไปเก็บแต่ละอัน
                    for _, coin in ipairs(coins) do
                        if not getgenv().AutoCollectCoinStack then break end -- เช็ค Toggle ระหว่างวนลูป
                        if coin and coin.PrimaryPart and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                            hrp.CFrame = coin:GetPrimaryPartCFrame() + Vector3.new(0,3,0)

                            -- รันรีโมทเก็บเหรียญ
                            local args = {[1] = coin}
                            local success, err = pcall(function()
                                game:GetService("ReplicatedStorage").RemoteEvents.RequestCollectCoints:InvokeServer(unpack(args))
                            end)
                            if not success then
                                warn("Error invoking remote: "..tostring(err))
                            end

                            wait() -- รอเล็กน้อยก่อนเก็บเหรียญถัดไป
                        end
                    end

                    wait(0.1) -- รอแล้วตรวจหา Coin Stack ใหม่
                end
            end)
        end
    end
})
