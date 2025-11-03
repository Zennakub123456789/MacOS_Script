local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zennakub123456789/Apple-Library/refs/heads/main/Main_Fixed_WithWhiteBorder.lua"))()

local imageUrl = "https://raw.githubusercontent.com/Zennakub123456789/picture/main/TadHub-Icon.png"
local imageName = "TadHub-Icon.png"

if not isfile(imageName) then
    local imageData = game:HttpGet(imageUrl)
    writefile(imageName, imageData)
end

local iconPath = getcustomasset(imageName)

local Window = MacUI:Window({
    Title = "Tad Hub | Chat Follow",
    Size = UDim2.new(0, 500, 0, 350),
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
        Title = "Tad Hub | Key System",
        Subtitle = "เข้าดิสคอสต์เพื่อเอาคีย์ คีย์จะรีเซ็ตทุก24ชั่วโมง (เดี๋ยวตื่นจะมาปิดระบบคีย์ให้ ตอนนี้คนในดิสมันเงียบ55) / Join Discord to get key And Keys reset every 24 H",
        Key = {"Key_A3rTadHub_z8Nq4yF", "TadHub67"},
        KeyLink = "https://discord.gg/VA35fm4r8f",
        SaveKey = true
    }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local ChatTab = Window:Tab("Chat")

local targetPlayerName = ""
local chatEnabled = false
local hotkeyControlEnabled = false
local hotkeyActive = false

local connectedPlayers = {}

local statusGui = nil
local statusLabel = nil

local function sendMessage(msg)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channels = TextChatService:FindFirstChild("TextChannels")
        if channels then
            local channel = channels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync(msg)
            end
        end
    else
        local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
            chatEvent.SayMessageRequest:FireServer(msg, "All")
        end
    end
end

local function onPlayerChatted(player, msg)
    local enabledNow = chatEnabled
    if hotkeyControlEnabled then
        enabledNow = hotkeyActive
    end

    if not enabledNow or player.Name ~= targetPlayerName then
        return
    end

    local isBlacklisted = (targetPlayerName:lower() == "solid_chicken4391")

    if not isBlacklisted then
        sendMessage(msg)
    end
end

local function connectPlayer(player)
    if connectedPlayers[player.UserId] then return end
    connectedPlayers[player.UserId] = true
    player.Chatted:Connect(function(msg)
        onPlayerChatted(player, msg)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    connectPlayer(player)
end

Players.PlayerAdded:Connect(function(player)
    connectPlayer(player)
end)

local function createStatusLabel()
    local oldGui = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ChatFollowStatusGUI")
    if oldGui then 
        oldGui:Destroy() 
    end

    statusGui = Instance.new("ScreenGui")
    statusGui.Name = "ChatFollowStatusGUI"
    statusGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    statusGui.ResetOnSpawn = false
    statusGui.Enabled = false

    local Frame = Instance.new("Frame")
    Frame.Name = "StatusFrame"
    Frame.Parent = statusGui
    Frame.AnchorPoint = Vector2.new(1, 0)
    Frame.Position = UDim2.new(1, -10, 0, 10)
    Frame.Size = UDim2.new(0, 150, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BackgroundTransparency = 0.3
    Frame.BorderSizePixel = 0

    statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "ChatFollowStatusLabel"
    statusLabel.Parent = Frame
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    statusLabel.TextStrokeTransparency = 0.7
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.TextSize = 18
    statusLabel.Text = "สถานะ: ปิด"
end

local function updateStatusLabel()
    if not statusLabel then return end
    local statusText = hotkeyActive and "สถานะ: เปิด" or "สถานะ: ปิด"
    statusLabel.Text = statusText
end

createStatusLabel()

local targetInput
targetInput = ChatTab:Input({
    Placeholder = "ใส่ชื่อผู้เล่นที่ต้องการ",
    Default = "",
    Flag = "TadHub_ChatFollowTarget",
    Callback = function(text)
        if text == "" then
            targetPlayerName = ""
            return
        end

        local text_lower = text:lower()
        local exactMatch = nil
        local prefixMatch = nil

        for _, plr in ipairs(game.Players:GetPlayers()) do
            local plr_name = plr.Name
            local plr_lower = plr_name:lower()

            if plr_lower == text_lower then
                exactMatch = plr_name
                break 
            end

            if prefixMatch == nil and plr_lower:sub(1, #text_lower) == text_lower then
                prefixMatch = plr_name
                break 
            end
        end

        local finalName = ""
        local updateTextBox = false

        if exactMatch then
            finalName = exactMatch
            updateTextBox = false

        elseif prefixMatch then
            finalName = prefixMatch
            updateTextBox = true

        else
            finalName = text
            updateTextBox = false
        end
        
        targetPlayerName = finalName
        
        if updateTextBox and targetInput and targetInput.SetValue then
            targetInput:SetValue(finalName)
        end
    end,
})

ChatTab:Toggle({
    Title = "Enable Chat Follow (Toggle)",
    Default = false,
    Flag = "TadHub_ChatFollowToggle",
    Callback = function(state)
        chatEnabled = state
        if state and hotkeyControlEnabled then
            hotkeyControlEnabled = false
            hotkeyActive = false
            updateStatusLabel()
            if statusGui then statusGui.Enabled = false end
        end
    end,
})

ChatTab:Toggle({
    Title = "Enable Chat Follow (Hotkey F)",
    Default = false,
    Flag = "TadHub_ChatFollowHotkey",
    Callback = function(state)
        hotkeyControlEnabled = state
        if state then
            hotkeyActive = false
            updateStatusLabel()
            if statusGui then statusGui.Enabled = true end
        else
            hotkeyActive = false
            updateStatusLabel()
            if statusGui then statusGui.Enabled = false end
        end
    end,
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if hotkeyControlEnabled and input.KeyCode == Enum.KeyCode.F then
        hotkeyActive = not hotkeyActive
        updateStatusLabel()
    end
end)
