local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zennakub123456789/Apple-Library/refs/heads/main/Main_Fixed_WithWhiteBorder.lua"))()

local imageUrl = "https://raw.githubusercontent.com/Zennakub123456789/picture/main/TadHub-Icon.png"
local imageName = "TadHub-Icon.png"

if not isfile(imageName) then
    local imageData = game:HttpGet(imageUrl)
    writefile(imageName, imageData)
end

local iconPath = getcustomasset(imageName)

local Window = MacUI:Window({
    Title = "Tad Hub | Evade",
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

local MainTab = Window:Tab("Main", 79927907097265)

local TeachSection = MainTab:Section("How to use Auto Farm")

local Teach1Label = MainTab:Paragraph({
    Text = "1. Open Auto Revive and Auto Respawn"
})
local Teach2Label = MainTab:Paragraph({
    Text = "2. Open Auto Farm Money and Done✅"
})

local AutoFarmSection = MainTab:Section("Auto Farm")

local ToggleAutoFarm = false
local autoFarmThread = nil
local safePart = workspace:FindFirstChild("AutoFarmSafeSpot")
local partUnderPlayer = nil

if not safePart then
    safePart = Instance.new("Part")
    safePart.Size = Vector3.new(5, 5, 5)
    safePart.Position = Vector3.new(1000, 1000, 0)
    safePart.Anchored = true
    safePart.Transparency = 0.5
    safePart.BrickColor = BrickColor.new("Lime green")
    safePart.Name = "AutoFarmSafeSpot"
    safePart.Parent = workspace
end

local AutoFarmMoneyToggle = MainTab:Toggle({
    Title = "Auto Farm Money🤑",
    Default = false,
    Flag = "AutoFarm_Downed",
    Callback = function(Value)
        ToggleAutoFarm = Value

        if ToggleAutoFarm then
            autoFarmThread = task.spawn(function()
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:WaitForChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(safePart.Position + Vector3.new(0, 3, 0))
                end

                while ToggleAutoFarm do
                    local char = game.Players.LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    if hrp then
                        local downedChar = nil
                        for _, plr in pairs(game.Players:GetPlayers()) do
                            if plr ~= game.Players.LocalPlayer and plr.Character then
                                local humanoid = plr.Character:FindFirstChild("Humanoid")
                                if humanoid and humanoid.Health == 0 then
                                    downedChar = plr.Character
                                    break
                                end
                            end
                        end

                        if downedChar and downedChar:FindFirstChild("HumanoidRootPart") then
                            if not partUnderPlayer then
                                partUnderPlayer = Instance.new("Part")
                                partUnderPlayer.Size = Vector3.new(5, 1, 5)
                                partUnderPlayer.Anchored = true
                                partUnderPlayer.CanCollide = true
                                partUnderPlayer.Transparency = 0.3
                                partUnderPlayer.BrickColor = BrickColor.new("Bright blue")
                                partUnderPlayer.Name = "FloatingPart"
                                partUnderPlayer.Parent = workspace
                            end
                            partUnderPlayer.Position = hrp.Position - Vector3.new(0, 3, 0)

                            local downedHRP = downedChar:FindFirstChild("HumanoidRootPart")
                            hrp.CFrame = CFrame.new(downedHRP.Position - Vector3.new(0, 7.5, 0))
                        else
                            if partUnderPlayer then
                                partUnderPlayer:Destroy()
                                partUnderPlayer = nil
                            end
                            hrp.CFrame = CFrame.new(safePart.Position + Vector3.new(0, 3, 0))
                        end
                    end

                    task.wait(0.1)
                end
            end)
        else
            if autoFarmThread then
                task.cancel(autoFarmThread)
            end
            if partUnderPlayer then
                partUnderPlayer:Destroy()
                partUnderPlayer = nil
            end
        end
    end
})

local CarrySection = MainTab:Section("Auto Carry")

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

local running = false

local function carryNearbyPlayer()
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local nearbyTargets = {}
    for _, otherPlayer in ipairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist <= 5 then
                table.insert(nearbyTargets, otherPlayer.Character)
            end
        end
    end

    if #nearbyTargets > 0 then
        local randomTarget = nearbyTargets[math.random(1, #nearbyTargets)]
        local args = {
            [1] = "Carry",
            [3] = randomTarget
        }
        replicatedStorage.Events.Character.Interact:FireServer(unpack(args))
    end
end

local AutoCarryToggle = MainTab:Toggle({
    Title = "Auto Carry",
    Default = false,
    Flag = "Toggle_CarryNearby",
    Callback = function(Value)
        running = Value
        if running then
            task.spawn(function()
                while running do
                    carryNearbyPlayer()
                    task.wait(0)
                end
            end)
        end
    end,
})

local AutoCarryguiToggle = MainTab:Toggle({
    Title = "Auto Carry Button gui",
    Default = false,
    Flag = "ToggleCreateAutoCarryGUI",
    Callback = function(Value)
        if Value then
            local player = game.Players.LocalPlayer
            local gui = Instance.new("ScreenGui")
            gui.Name = "AutoCarryGUI"
            gui.Parent = player:FindFirstChildOfClass("PlayerGui")
            gui.ResetOnSpawn = false

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0, 100, 0, 85)
            button.Position = UDim2.new(0, 0, 0, 0)
            button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            button.Text = "Auto Carry: OFF"
            button.Font = Enum.Font.GothamBlack
            button.TextSize = 13
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Parent = gui

            local autoCarryActive = false

            button.MouseButton1Click:Connect(function()
    autoCarryActive = not autoCarryActive
    if autoCarryActive then
        button.Text = "Auto Carry: ON"
        task.spawn(function()
            while true do
                local carryModel = player:FindFirstChild("CarryModel")
                if carryModel and carryModel:FindFirstChild("Carry") then
                    button.Text = "Auto Carry: OFF"
                    autoCarryActive = false
                    return
                end

                if not autoCarryActive then
                    button.Text = "Auto Carry: OFF"
                    return
                end

                local nearestPlayer = nil
                local minDistance = math.huge
                for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (otherPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            nearestPlayer = otherPlayer
                        end
                    end
                end

                if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("Humanoid") and nearestPlayer.Character.Humanoid.Health <= 0 then
                    local args = {
                        [1] = "Carry",
                        [3] = nearestPlayer.UserId
                    }
                    game:GetService("ReplicatedStorage").Events.Character.Interact:FireServer(unpack(args))
                end

                task.wait(0)
            end
        end)
    else
        button.Text = "Auto Carry: OFF"
    end
end)

            local dragging = false
            local dragInput, dragStart, startPos

            local initialPosition = button.Position

            button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = button.Position
                end
            end)

            button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            button.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - dragStart
                    button.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end)

        else
            local player = game.Players.LocalPlayer
            local gui = player:FindFirstChildOfClass("PlayerGui"):FindFirstChild("AutoCarryGUI")
            if gui then
                gui:Destroy()
            end
        end
    end,
})

local AutoReviveSection = MainTab:Section("Auto Revive")

local AutoReviveToggle = MainTab:Toggle({
    Title = "Auto Revive",  
    Default = false,  
    Flag = "Toggle_AutoReviveFallen10m", 
    Callback = function(Value)
        _G.AutoRevive = Value

        task.spawn(function()
            while _G.AutoRevive do
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distance <= 10 then
                                local humanoid = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.Health <= 0 then
                                    local args = {
                                        [1] = "Revive",
                                        [2] = true,
                                        [3] = otherPlayer.Name
                                    }
                                    game:GetService("ReplicatedStorage").Events.Character.Interact:FireServer(unpack(args))
                                    break
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end,
})

local AutorespawnSection = MainTab:Section("Auto Respawn")

local AutoRespawnToggle = MainTab:Toggle({
   Title = "Auto Respawn",  
   Default = false,       
   Flag = "Toggle_AutoRespawn", 
   Callback = function(Value)
       getgenv().AutoRespawn = Value

       if Value then
           local Players = game:GetService("Players")
           local ReplicatedStorage = game:GetService("ReplicatedStorage")

           local function Respawn()
               local args = {
                   [1] = true
               }
               ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(unpack(args))
           end

           local function Setup(character)
               local humanoid = character:WaitForChild("Humanoid", 5)
               if humanoid then
                   humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                       if getgenv().AutoRespawn and humanoid.Health <= 0 then
                           task.wait(1.5)
                           if humanoid.Health <= 0 then
                               Respawn()
                           end
                       end
                   end)
               end
           end

           if Players.LocalPlayer.Character then
               Setup(Players.LocalPlayer.Character)
           end

           Players.LocalPlayer.CharacterAdded:Connect(function(char)
               if getgenv().AutoRespawn then
                   Setup(char)
               end
           end)
       end
   end,
})

local espTab = Window:Tab("ESP", 6523858394)

local DrownedEspSection = espTab:Section("Drowned Esp")

local DrownedHighlightToggle = espTab:Toggle({
    Title = "Highlight Downed Players",  
    Default = false,       
    Flag = "Toggle_KnockedESP", 
    Callback = function(Value)
        if Value then
            getgenv().KnockedESP = true
            task.spawn(function()
                while getgenv().KnockedESP do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            local existingHighlight = player.Character:FindFirstChild("DownedHighlight")

                            if humanoid.Health <= 0 then
                                if not existingHighlight then
                                    local highlight = Instance.new("Highlight")
                                    highlight.Name = "DownedHighlight"
                                    highlight.FillColor = Color3.fromRGB(255, 255, 0)
                                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    highlight.FillTransparency = 0.5
                                    highlight.OutlineTransparency = 0.8
                                    highlight.Adornee = player.Character
                                    highlight.Parent = player.Character
                                end
                            else
                                if existingHighlight then
                                    existingHighlight:Destroy()
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            getgenv().KnockedESP = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local existingHighlight = player.Character:FindFirstChild("DownedHighlight")
                    if existingHighlight then
                        existingHighlight:Destroy()
                    end
                end
            end
        end
    end,
})

local DownedNameToggle = espTab:Toggle({
    Title = "Name Downed Players",  
    Default = false,       
    Flag = "Toggle_KnockedNameESP", 
    Callback = function(Value)
        if Value then
            getgenv().KnockedNameESP = true
            task.spawn(function()
                while getgenv().KnockedNameESP do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            local existingGui = player.Character:FindFirstChild("DownedName")

                            if humanoid.Health <= 0 then
                                if not existingGui then
                                    local billboard = Instance.new("BillboardGui")
                                    billboard.Name = "DownedName"
                                    billboard.Adornee = player.Character.HumanoidRootPart
                                    billboard.Size = UDim2.new(0, 70, 0, 14)
                                    billboard.StudsOffset = Vector3.new(0, 10, 0)
                                    billboard.AlwaysOnTop = true
                                    billboard.SizeOffset = Vector2.new(0, 0)
                                    billboard.Parent = player.Character

                                    local textLabel = Instance.new("TextLabel")
                                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.Text = player.Name
                                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                    textLabel.TextStrokeTransparency = 0.5
                                    textLabel.Font = Enum.Font.GothamBold
                                    textLabel.TextScaled = true
                                    textLabel.Parent = billboard
                                end
                            else
                                if existingGui then
                                    existingGui:Destroy()
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            getgenv().KnockedNameESP = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local existingGui = player.Character:FindFirstChild("DownedName")
                    if existingGui then
                        existingGui:Destroy()
                    end
                end
            end
        end
    end,
})

local DownedDistanceToggle = espTab:Toggle({
    Title = "Downed Distance Players",
    Default = false,
    Flag = "Toggle_KnockedDistanceESP",
    Callback = function(Value)
        if Value then
            getgenv().KnockedDistanceESP = true
            task.spawn(function()
                while getgenv().KnockedDistanceESP do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                            local existingGui = player.Character:FindFirstChild("DownedDistance")

                            if humanoid.Health <= 0 then
                                if not existingGui then
                                    local billboard = Instance.new("BillboardGui")
                                    billboard.Name = "DownedDistance"
                                    billboard.Adornee = rootPart
                                    billboard.Size = UDim2.new(0, 50, 0, 10)
                                    billboard.StudsOffset = Vector3.new(0, 0, 0)
                                    billboard.AlwaysOnTop = true
                                    billboard.Parent = player.Character

                                    local textLabel = Instance.new("TextLabel")
                                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                    textLabel.TextStrokeTransparency = 0.5
                                    textLabel.Font = Enum.Font.GothamBold
                                    textLabel.TextScaled = true
                                    textLabel.Parent = billboard
                                end

                                if existingGui then
                                    local textLabel = existingGui:FindFirstChildOfClass("TextLabel")
                                    if textLabel and rootPart then
                                        local distance = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
                                        textLabel.Text = tostring(distance) .. "m"
                                    end
                                end

                            else
                                if existingGui then
                                    existingGui:Destroy()
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            getgenv().KnockedDistanceESP = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local existingGui = player.Character:FindFirstChild("DownedDistance")
                    if existingGui then
                        existingGui:Destroy()
                    end
                end
            end
        end
    end,
})

local DownedLineToggle = espTab:Toggle({
    Title = "Line Downed Players",
    Default = false,
    Flag = "Toggle_KnockedLineESP",
    Callback = function(Value)
        if Value then
            getgenv().KnockedLineESP = true
            task.spawn(function()
                while getgenv().KnockedLineESP do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                            local existingLine = player.Character:FindFirstChild("DownedLine")

                            if humanoid.Health <= 0 then
                                if not existingLine then
                                    local beam = Instance.new("Beam")
                                    beam.Name = "DownedLine"
                                    beam.Attachment0 = Instance.new("Attachment", game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                                    beam.Attachment1 = Instance.new("Attachment", rootPart)
                                    beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
                                    beam.Width0 = 0.1
                                    beam.Width1 = 0.1
                                    beam.FaceCamera = true
                                    beam.Parent = player.Character
                                end
                            else
                                if existingLine then
                                    if existingLine.Attachment0 then existingLine.Attachment0:Destroy() end
                                    if existingLine.Attachment1 then existingLine.Attachment1:Destroy() end
                                    existingLine:Destroy()
                                end
                            end
                        end
                    end
                    task.wait(0)
                end
            end)
        else
            getgenv().KnockedLineESP = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local existingLine = player.Character:FindFirstChild("DownedLine")
                    if existingLine then
                        if existingLine.Attachment0 then existingLine.Attachment0:Destroy() end
                        if existingLine.Attachment1 then existingLine.Attachment1:Destroy() end
                        existingLine:Destroy()
                    end
                end
            end
        end
    end,
})

local PlayerEspSection = espTab:Section("Players Esp")

local PlayerHighlightToggle = espTab:Toggle({
    Title = "Players Highlight",
    Default = false,
    Flag = "Toggle_PlayersHighlight",
    Callback = function(Value)
        if Value then
            getgenv().PlayersHighlight = true
            task.spawn(function()
                while getgenv().PlayersHighlight do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character.Humanoid
                            local existingHighlight = player.Character:FindFirstChild("PlayersHighlight")

                            if humanoid.Health <= 0 then
                                if existingHighlight then
                                    existingHighlight:Destroy()
                                end
                            elseif humanoid.Health == 100 then
                                if not existingHighlight then
                                    local highlight = Instance.new("Highlight")
                                    highlight.Name = "PlayersHighlight"
                                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    highlight.FillTransparency = 0.5
                                    highlight.OutlineTransparency = 0.7
                                    highlight.Adornee = player.Character
                                    highlight.Parent = player.Character
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            getgenv().PlayersHighlight = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local existingHighlight = player.Character:FindFirstChild("PlayersHighlight")
                    if existingHighlight then
                        existingHighlight:Destroy()
                    end
                end
            end
        end
    end,
})

local PlayerNameToggle = espTab:Toggle({
    Title = "Players Name ESP",
    Default = false,
    Flag = "Toggle_PlayersNameESP",
    Callback = function(Value)
        if Value then
            getgenv().PlayersNameESP = true
            task.spawn(function()
                while getgenv().PlayersNameESP do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character.Humanoid
                            local existingGui = player.Character:FindFirstChild("PlayersName")

                            if humanoid.Health <= 0 then
                                if existingGui then
                                    existingGui:Destroy()
                                end
                            elseif humanoid.Health == 100 then
                                if not existingGui then
                                    local billboard = Instance.new("BillboardGui")
                                    billboard.Name = "PlayersName"
                                    billboard.Adornee = player.Character.HumanoidRootPart
                                    billboard.Size = UDim2.new(0, 60, 0, 12)
                                    billboard.StudsOffset = Vector3.new(0, 10, 0)
                                    billboard.AlwaysOnTop = true
                                    billboard.Parent = player.Character

                                    local textLabel = Instance.new("TextLabel")
                                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.Text = player.Name
                                    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                                    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                    textLabel.TextStrokeTransparency = 0.5
                                    textLabel.Font = Enum.Font.GothamBold
                                    textLabel.TextScaled = true
                                    textLabel.Parent = billboard
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            getgenv().PlayersNameESP = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local gui = player.Character:FindFirstChild("PlayersName")
                    if gui then
                        gui:Destroy()
                    end
                end
            end
        end
    end,
})

local PlayerDistanceToggle = espTab:Toggle({
    Title = "Players Distance ESP",
    Default = false,
    Flag = "Toggle_PlayersDistanceESP",
    Callback = function(Value)
        if Value then
            getgenv().PlayersDistanceESP = true
            task.spawn(function()
                while getgenv().PlayersDistanceESP do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character.Humanoid
                            local existingGui = player.Character:FindFirstChild("PlayersDistance")
                            local myRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

                            if humanoid.Health <= 0 then
                                if existingGui then
                                    existingGui:Destroy()
                                end
                            elseif humanoid.Health == 100 and myRoot then
                                local distance = math.floor((player.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude)

                                if not existingGui then
                                    local billboard = Instance.new("BillboardGui")
                                    billboard.Name = "PlayersDistance"
                                    billboard.Adornee = player.Character.HumanoidRootPart
                                    billboard.Size = UDim2.new(0, 50, 0, 10)
                                    billboard.StudsOffset = Vector3.new(0, 0, 0)
                                    billboard.AlwaysOnTop = true
                                    billboard.Parent = player.Character

                                    local textLabel = Instance.new("TextLabel")
                                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                                    textLabel.TextStrokeTransparency = 0.5
                                    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                                    textLabel.Font = Enum.Font.GothamBold
                                    textLabel.TextScaled = true
                                    textLabel.Name = "DistanceLabel"
                                    textLabel.Text = tostring(distance) .. "m"
                                    textLabel.Parent = billboard
                                else
                                    local label = existingGui:FindFirstChild("DistanceLabel")
                                    if label then
                                        label.Text = tostring(distance) .. "m"
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            getgenv().PlayersDistanceESP = false
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    local gui = player.Character:FindFirstChild("PlayersDistance")
                    if gui then
                        gui:Destroy()
                    end
                end
            end
        end
    end,
})

local PlayerLineToggle = espTab:Toggle({
    Title = "Players Line ESP",
    Default = false,
    Flag = "Toggle_PlayersLineESP",
    Callback = function(Value)
        if Value then
            getgenv().PlayersLineESP = true
            local lines = {}

            task.spawn(function()
                while getgenv().PlayersLineESP do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                            local humanoid = player.Character.Humanoid
                            local rootPart = player.Character.HumanoidRootPart

                            if humanoid.Health > 0 then
                                if not lines[player] then
                                    local line = Drawing.new("Line")
                                    line.Color = Color3.fromRGB(0, 255, 0)
                                    line.Thickness = 2
                                    line.Transparency = 1
                                    lines[player] = line
                                end

                                local line = lines[player]
                                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)

                                if onScreen then
                                    line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                                    line.Visible = true
                                else
                                    line.Visible = false
                                end
                            else
                                if lines[player] then
                                    lines[player]:Remove()
                                    lines[player] = nil
                                end
                            end
                        end
                    end
                    task.wait(0)
                end

                for _, line in pairs(lines) do
                    line:Remove()
                end
                lines = {}
            end)
        else
            getgenv().PlayersLineESP = false
        end
    end,
})

local NextbotSection = espTab:Section("Nextbot Esp")

local NextbotNameToggle = espTab:Toggle({
   Title = "Nextbot Name ESP",
   Default = false,
   Flag = "Toggle_NextbotNameESP",
   Callback = function(Value)
       if Value then
           getgenv().NextbotNameESP = true
           task.spawn(function()
               local playersModel = workspace:WaitForChild("Game"):WaitForChild("Players")
               while getgenv().NextbotNameESP do
                   for _, obj in ipairs(playersModel:GetChildren()) do
                       if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
                           if obj:GetAttribute("AI") == true then
                               if not obj:FindFirstChild("NextbotName") then
                                   local billboard = Instance.new("BillboardGui")
                                   billboard.Name = "NextbotName"
                                   billboard.Adornee = obj.HumanoidRootPart
                                   billboard.Size = UDim2.new(0, 50, 0, 10)
                                   billboard.StudsOffset = Vector3.new(0, 10, 0)
                                   billboard.AlwaysOnTop = true
                                   billboard.Parent = obj

                                   local nameLabel = Instance.new("TextLabel")
                                   nameLabel.Size = UDim2.new(1, 0, 1, 0)
                                   nameLabel.BackgroundTransparency = 1
                                   nameLabel.Text = obj.Name
                                   nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                                   nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                   nameLabel.TextStrokeTransparency = 0.4
                                   nameLabel.Font = Enum.Font.GothamBold
                                   nameLabel.TextScaled = true
                                   nameLabel.Parent = billboard
                               end
                           else
                               local nameGui = obj:FindFirstChild("NextbotName")
                               if nameGui then nameGui:Destroy() end
                           end
                       end
                   end
                   task.wait(1)
               end
           end)
       else
           getgenv().NextbotNameESP = false
           local playersModel = workspace:WaitForChild("Game"):WaitForChild("Players")
           for _, obj in ipairs(playersModel:GetChildren()) do
               local nameGui = obj:FindFirstChild("NextbotName")
               if nameGui then nameGui:Destroy() end
           end
       end
   end,
})

local NextbotDistanceToggle = espTab:Toggle({
   Title = "Nextbot Distance ESP",
   Default = false,
   Flag = "Toggle_NextbotDistanceESP",
   Callback = function(Value)
       if Value then
           getgenv().NextbotDistanceESP = true
           task.spawn(function()
               local playersModel = workspace:WaitForChild("Game"):WaitForChild("Players")
               while getgenv().NextbotDistanceESP do
                   for _, obj in ipairs(playersModel:GetChildren()) do
                       if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:GetAttribute("AI") == true then
                           local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                           local distanceText = tostring(math.floor(distance)) .. " m"

                           if not obj:FindFirstChild("NextbotDistance") then
                               local billboard = Instance.new("BillboardGui")
                               billboard.Name = "NextbotDistance"
                               billboard.Adornee = obj.HumanoidRootPart
                               billboard.Size = UDim2.new(0, 50, 0, 10)
                               billboard.StudsOffset = Vector3.new(0, 0, 0)
                               billboard.AlwaysOnTop = true
                               billboard.Parent = obj

                               local nameLabel = Instance.new("TextLabel")
                               nameLabel.Name = "NameLabel"
                               nameLabel.Size = UDim2.new(1, 0, 1, 0)
                               nameLabel.BackgroundTransparency = 1
                               nameLabel.Text = distanceText
                               nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                               nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                               nameLabel.TextStrokeTransparency = 0.4
                               nameLabel.Font = Enum.Font.GothamBold
                               nameLabel.TextScaled = true
                               nameLabel.Parent = billboard
                           else
                               local label = obj.NextbotDistance:FindFirstChild("NameLabel")
                               if label then
                                   label.Text = distanceText
                               end
                           end
                       end
                   end
                   task.wait(0.1)
               end
           end)
       else
           getgenv().NextbotDistanceESP = false
           local playersModel = workspace:WaitForChild("Game"):WaitForChild("Players")
           for _, obj in ipairs(playersModel:GetChildren()) do
               local nameGui = obj:FindFirstChild("NextbotDistance")
               if nameGui then nameGui:Destroy() end
           end
       end
   end,
})

local returnPosition = nil
local tpLoopThread = nil
local player = game.Players.LocalPlayer

local Toggle_TPVisualReturn = espTab:Toggle({
    Title = "TP To 'Visual' (Return if missing)",
    Default = false,
    Flag = "Toggle_TPToVisualReturn",
    Callback = function(Value)
        getgenv().AutoTPToVisual = Value
        
        local isAtReturnPosition = false

        if Value then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if not hrp then
                MacUI:Notify({
                    Title = "Error",
                    Content = "Cannot start: Player character not found.",
                    Duration = 3
                })
                return 
            end
            
            returnPosition = hrp.CFrame
            
            tpLoopThread = task.spawn(function()
                while getgenv().AutoTPToVisual do
                    
                    local currentChar = player.Character
                    local currentHRP = currentChar and currentChar:FindFirstChild("HumanoidRootPart")

                    if not currentHRP then
                        player.CharacterAdded:Wait()
                        
                        if not getgenv().AutoTPToVisual then break end
                        currentHRP = player.Character:WaitForChild("HumanoidRootPart")
                        
                        if currentHRP then
                            returnPosition = currentHRP.CFrame
                        end
                        isAtReturnPosition = false
                    end
                    
                    local ticketsObject = workspace:FindFirstChild("Game")
                    if ticketsObject then ticketsObject = ticketsObject:FindFirstChild("Effects") end
                    if ticketsObject then ticketsObject = ticketsObject:FindFirstChild("Tickets") end

                    local targetVisual = nil
                    if ticketsObject then
                        targetVisual = ticketsObject:FindFirstChild("Visual", true)
                    end

                    if targetVisual then
                        local targetCFrame = nil
                        
                        if targetVisual:IsA("Model") and targetVisual.PrimaryPart then
                            targetCFrame = targetVisual.PrimaryPart.CFrame
                        elseif targetVisual:IsA("BasePart") then
                            targetCFrame = targetVisual.CFrame
                        end

                        if targetCFrame then
                            currentHRP.CFrame = targetCFrame + Vector3.new(0, 3, 0)
                            isAtReturnPosition = false 
                        end
                    else
                        if returnPosition and not isAtReturnPosition then
                            currentHRP.CFrame = returnPosition
                            isAtReturnPosition = true 
                        end
                    end
                    
                    task.wait(0.1)
                end
            end)
            
        else
            if tpLoopThread then
                task.cancel(tpLoopThread)
                tpLoopThread = nil
            end
            
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if returnPosition and hrp then
                hrp.CFrame = returnPosition
            end
        end
    end,
})
