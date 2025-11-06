local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zennakub123456789/Apple-Library/refs/heads/main/Main_Fixed_Improved(2).lua"))()

local imageUrl = "https://raw.githubusercontent.com/Zennakub123456789/picture/main/TadHub-Icon.png"
local imageName = "TadHub-Icon.png"

if not isfile(imageName) then
    local imageData = game:HttpGet(imageUrl)
    writefile(imageName, imageData)
end

local iconPath = getcustomasset(imageName)

local Window = MacUI:Window({
    Title = "Tad Hub | 99 Night In The Forest (Beta)",
    Size = UDim2.new(0, 550, 0, 325),
    Theme = "Dark",
    Icon = iconPath,
    LoadingTitle = "Beta",
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

local infoTab = Window:Tab("Info", "rbxassetid://76311199408449")

local Comingabel1 = infoTab:Label({
    Text = "ตอนนี้ยังเป็นเบต้าอยู่ ฟังชั่นยังน้อย ตอนนี้กำลังไล่เพื่ม โปรดรอ / It's still in beta, so there are few features. We're working on adding more. Please wait."
})

infoTab:Section("Update")

local UpdateCode = infoTab:Code({
    Title = "Script Update",
    Code = [[# 99 night in the forest Script Update! (v1.0.0) ]]
})

infoTab:Section("Discord")

local DiscordLabel = infoTab:Label({
    Text = "If you Found a bug or want to create a different map script, please let us know on Discord. We listen to all your problems."
})

local CopyDiscordButton = infoTab:Button({
    Title = "Copy Discord Link",
    Desc = "Click to copy the Discord invite link.",
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

infoTab:Section("Feedback")

local FeedBackLabel = infoTab:Label({
    Text = "Send Feedback / Report Bug (Don't Spam)"
})

local webhookURL = "https://discord.com/api/webhooks/1427371338032484374/o0WHwtI8Pw7GwjVQl5XdLkRa_oIGjrOOs9dSg8Z5W7lX6A_Fj25AdgO-Uqn8AJuF35Fd"

local httpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FeedBackInput = infoTab:Input({
    Placeholder = "Enter your feedback...",
    Default = "",
    Flag = "UserFeedback",
    Callback = function(text)
        _G.UserFeedback = text
    end
})

local lastSentTime = 0
local cooldown = 300

local FeedBackButton = infoTab:Button({
    Title = "Send Feedback",
    Desc = "Send your feedback to the Dev",
    Callback = function()
        local feedback = _G.UserFeedback or ""
        if feedback == "" then
            MacUI:Notify({
                Title = "No message!",
                Content = "Please enter your feedback before sending.",
                Duration = 3
            })
            return
        end

        local now = tick()
        if now - lastSentTime < cooldown then
            local timeLeft = cooldown - (now - lastSentTime)
            local minutes = math.floor(timeLeft / 60)
            local seconds = math.floor(timeLeft % 60)
            MacUI:Notify({
                Title = "Please wait!",
                Content = string.format("You are in cooldown. Please wait %d minute(s) %d second(s) before sending again.", minutes, seconds),
                Duration = 4
            })
            return
        end

        local data = {
            ["embeds"] = {{
                ["title"] = "Feedback Received",
                ["color"] = 3447003,
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Message",
                        ["value"] = feedback,
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Time",
                        ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                        ["inline"] = true
                    }
                }
            }}
        }

        task.spawn(function()
            local success, err = pcall(function()
                request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = httpService:JSONEncode(data)
                })
            end)

            if success then
                lastSentTime = tick()
            end
        end)

        MacUI:Notify({
            Title = "Sent!",
            Content = "Thank you for your feedback.",
            Duration = 3
        })

        _G.UserFeedback = ""
        FeedBackInput:SetValue("")
    end
})

local MainTab = Window:Tab("Main", "rbxassetid://7733779610")

MainTab:Section("Tree Aura")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer
local PlayerInventory = player:WaitForChild("Inventory")
local CurrentCamera = workspace.CurrentCamera

local ToolDamageObject = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")

local axeNames = {
    "Admin Axe",
    "Chainsaw",
    "Strong Axe",
    "Ice Axe",
    "Good Axe",
    "Old Axe"
}

local strongAxes = {"Admin Axe", "Chainsaw", "Strong Axe"}

local bigTreeModelNames = {
    "TreeBig1", "TreeBig2", "TreeBig3",
    "WebbedTreeBig1", "WebbedTreeBig2", "WebbedTreeBig3"
}

local function findBestPlayerAxe()
    for _, axeName in ipairs(axeNames) do
        local axe = PlayerInventory:FindFirstChild(axeName)
        if axe then
            return axe
        end
    end
    return nil
end

local function updateHealthBillboard(treeModel)
    local trunk = treeModel:FindFirstChild("Trunk")
    if not trunk then return end

    local health = treeModel:GetAttribute("Health")
    local maxHealth = treeModel:GetAttribute("MaxHealth")
    
    if not health or not maxHealth or maxHealth <= 0 then return end

    local healthPercent = math.clamp(health / maxHealth, 0, 1)

    local billboardGui = trunk:FindFirstChild("HealthBillboard")
    if not billboardGui then
        billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "HealthBillboard"
        billboardGui.Adornee = trunk
        billboardGui.Size = UDim2.new(0, 100, 0, 10)
        billboardGui.StudsOffset = Vector3.new(0, 5, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = trunk

        local background = Instance.new("Frame")
        background.Name = "Background"
        background.Size = UDim2.new(1, 0, 1, 0)
        background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        background.BorderSizePixel = 0
        background.Parent = billboardGui

        local bar = Instance.new("Frame")
        bar.Name = "Bar"
        bar.Size = UDim2.new(healthPercent, 0, 1, 0)
        bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        bar.BorderSizePixel = 0
        bar.Parent = background
    else
        local background = billboardGui:FindFirstChild("Background")
        local bar = background and background:FindFirstChild("Bar")
        if bar then
            bar.Size = UDim2.new(healthPercent, 0, 1, 0)
            if healthPercent < 0.3 then
                bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            elseif healthPercent < 0.6 then
                bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            end
        end
    end
end

local treeOptions = {"Small Tree", "Small Webbed Tree", "Snowy Small Tree", "Big Tree"}

local TreeSelectorDropdown = MainTab:Dropdown({
    Title = "Select Trees to Hit",
    Options = treeOptions,
    Multi = true,
    Default = {"Small Tree"},
    Flag = "SelectedTreesToHit",
    Callback = function(selected)
        getgenv().TreesToHit = selected
    end
})
getgenv().TreesToHit = TreeSelectorDropdown:Get()

local HitRangeSlider = MainTab:Slider({
    Title = "Hit Range (Studs)",
    Min = 5,
    Max = 250,
    Default = 150,
    Flag = "AutoHitTreeRange",
    Callback = function(value)
        getgenv().AutoHitTreeRange = value
    end
})
getgenv().AutoHitTreeRange = HitRangeSlider:Get()

local AutoHitTreeToggle
AutoHitTreeToggle = MainTab:Toggle({
    Title = "Auto Hit Trees (Aura)",
    Default = false,
    Flag = "AutoHitTree",
    Callback = function(state)
        getgenv().AutoHitTree = state

        if state then
            task.spawn(function()
                while getgenv().AutoHitTree do
                    local currentAxe = findBestPlayerAxe()
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    local currentRange = getgenv().AutoHitTreeRange or 20
                    local treesToHit = getgenv().TreesToHit
                    
                    if currentAxe and hrp and treesToHit and #treesToHit > 0 then
                        local hrpPosition = hrp.Position
                        
                        local hitBigTreeSelected = table.find(treesToHit, "Big Tree")
                        local canHitBigTree = hitBigTreeSelected and table.find(strongAxes, currentAxe.Name)

                        local otherTreesToHit = {}
                        for _, treeName in ipairs(treesToHit) do
                            if treeName ~= "Big Tree" then
                                table.insert(otherTreesToHit, treeName)
                            end
                        end

                        local function fireRemote(tree, axe, idString)
                             task.spawn(function()
                                local args = {
                                    [1] = tree,
                                    [2] = axe,
                                    [3] = idString,
                                    [4] = hrp.CFrame
                                }
                                pcall(function() ToolDamageObject:InvokeServer(unpack(args)) end)
                            end)                           
                        end

                        local function processNormalTree(tree, folderIdString)
                            if tree:IsA("Model") and tree.PrimaryPart and table.find(otherTreesToHit, tree.Name) then
                                if (tree.PrimaryPart.Position - hrpPosition).Magnitude <= currentRange then
                                    updateHealthBillboard(tree)
                                    fireRemote(tree, currentAxe, folderIdString)
                                end
                            end
                        end

                        local function processBigTree(tree, folderIdString)
                             if tree:IsA("Model") and tree.PrimaryPart and table.find(bigTreeModelNames, tree.Name) then
                                if (tree.PrimaryPart.Position - hrpPosition).Magnitude <= currentRange then
                                    updateHealthBillboard(tree)
                                    fireRemote(tree, currentAxe, folderIdString)
                                end
                            end                           
                        end

                        for _, tree in ipairs(workspace.Map.Foliage:GetChildren()) do
                            if canHitBigTree then
                                processBigTree(tree, "19_4128505180")
                            end
                            processNormalTree(tree, "19_4128505180")
                        end

                        for _, tree in ipairs(workspace.Map.Landmarks:GetChildren()) do
                            if canHitBigTree then
                                processBigTree(tree, "24_4128505180")
                            end
                           processNormalTree(tree, "24_4128505180")
                        end
                    end
                    
                    task.wait(0.2)
                end
            end)
        end
    end
})

MainTab:Section("Kill Aura")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game:GetService("Players").LocalPlayer
local PlayerInventory = player:WaitForChild("Inventory")
local CurrentCamera = workspace.CurrentCamera

local ToolDamageObject = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")

local axeNames = {
    "Admin Axe", "Chainsaw", "Strong Axe", "Ice Axe", "Good Axe", "Old Axe"
}
local meleeWeaponNames = {
    "Spear", "Morningstar", "Katana", "Laser Sword", "Ice Sword",
    "Trident", "Poison Spear", "Infernal Sword", "Cultist King Mace", "Obsidiron Hammer"
}

local function findCurrentWeapon()
    local character = player.Character
    if character then
        for _, weaponName in ipairs(meleeWeaponNames) do
            local heldWeapon = character:FindFirstChild(weaponName)
            if heldWeapon and heldWeapon:IsA("Tool") then
                return heldWeapon
            end
        end
    end

    for _, axeName in ipairs(axeNames) do
        local axe = PlayerInventory:FindFirstChild(axeName)
        if axe then
            return axe
        end
    end
    
    return nil
end

local AttackRangeSlider = MainTab:Slider({
    Title = "Kill Aura Range",
    Min = 5,
    Max = 500,
    Default = 50,
    Flag = "AutoAttackRange",
    Callback = function(value)
        getgenv().AutoAttackRange = value
    end
})
getgenv().AutoAttackRange = AttackRangeSlider:Get()

local AutoAttackToggle
AutoAttackToggle = MainTab:Toggle({
    Title = "Kill Aura",
    Default = false,
    Flag = "AutoAttackAll",
    Callback = function(state)
        getgenv().AutoAttackAll = state

        if state then
            task.spawn(function()
                while getgenv().AutoAttackAll do
                    local currentWeapon = findCurrentWeapon() 
                    local character = player.Character
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    local currentRange = getgenv().AutoAttackRange or 15
                    local charactersFolder = workspace:FindFirstChild("Characters")

                    if currentWeapon and hrp and charactersFolder then
                        local hrpPosition = hrp.Position

                        for _, target in ipairs(charactersFolder:GetChildren()) do
                            if target:IsA("Model") and target.PrimaryPart then
                                if (target.PrimaryPart.Position - hrpPosition).Magnitude <= currentRange then
                                    task.spawn(function()
                                        local args = {
                                            [1] = target,
                                            [2] = currentWeapon,
                                            [3] = "3_4128505180", 
                                            [4] = hrp.CFrame
                                        }
                                        pcall(function() ToolDamageObject:InvokeServer(unpack(args)) end)
                                    end)
                                end
                            end
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayersTab = Window:Tab("Players", "rbxassetid://117259180607823")

PlayersTab:Section("Teleport To Players")

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

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local IsFlying = false
local CurrentSpeed = 10
local BodyGyro = nil
local BodyVelocity = nil

local function GetRootPart()
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return nil end
    
    if hum.RigType == Enum.HumanoidRigType.R6 then
        return char:FindFirstChild("Torso")
    else
        return char:FindFirstChild("UpperTorso")
    end
end

local function SetHumanoidState(hum, state, value)
    pcall(function()
        hum:SetStateEnabled(state, value)
    end)
end

local function StartFlying()
    local char = player.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    local rootPart = GetRootPart()
    
    if IsFlying or not hum or not rootPart then return end
    IsFlying = true

    SetHumanoidState(hum, Enum.HumanoidStateType.Climbing, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.FallingDown, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Flying, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Freefall, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.GettingUp, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Jumping, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Landed, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Physics, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Ragdoll, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Running, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Swimming, false)
    hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    hum.PlatformStand = true

    local animateScript = char:FindFirstChild("Animate")
    if animateScript then
        animateScript.Disabled = true
    end
    
    local HumAnim = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
    if HumAnim then
        for _, v in next, HumAnim:GetPlayingAnimationTracks() do
            v:AdjustSpeed(0)
        end
    end

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 50000
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = rootPart.CFrame
    BodyGyro.Parent = rootPart

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = rootPart
end

local FlyToggle

local function StopFlying()
    local char = player.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    if not IsFlying and not hum then 
        local rootPart = GetRootPart()
        if rootPart then
            if rootPart:FindFirstChild("BodyGyro") then rootPart.BodyGyro:Destroy() end
            if rootPart:FindFirstChild("BodyVelocity") then rootPart.BodyVelocity:Destroy() end
        end
    end
    
    if not IsFlying then return end
    IsFlying = false
    
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end

    if FlyToggle then FlyToggle:Set(false) end

    if hum then
        local animateScript = char:FindFirstChild("Animate")
        if animateScript then
            animateScript.Disabled = false
        end

        SetHumanoidState(hum, Enum.HumanoidStateType.Climbing, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.FallingDown, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Flying, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Freefall, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.GettingUp, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Jumping, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Landed, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Physics, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Ragdoll, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Running, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Swimming, true)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        hum.PlatformStand = false
    end
end

PlayersTab:Section("Fly")

local FlyToggle = PlayersTab:Toggle({
    Title = "Fly Toggle",
    Default = false,
    Flag = "IsFlying",
    Callback = function(value)
        if value then
            StartFlying()
        else
            StopFlying()
        end
    end
})

local FlySpeedSlider = PlayersTab:Slider({
    Title = "Fly Speed",
    Min = 1,
    Max = 1000,
    Default = CurrentSpeed,
    Flag = "FlySpeed",
    Callback = function(value)
        CurrentSpeed = math.floor(value)
    end
})

RunService.RenderStepped:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    if not IsFlying or not BodyGyro or not BodyVelocity or not hum then 
        return 
    end

    local cam = workspace.CurrentCamera
    if not cam then return end

    BodyGyro.CFrame = cam.CFrame

    local moveVector = Vector3.new(0, 0, 0)
    local worldMove = hum.MoveDirection
    local relativeMove = cam.CFrame:VectorToObjectSpace(worldMove)
    
    moveVector = moveVector + (cam.CFrame.LookVector * (relativeMove.Z * -1))
    moveVector = moveVector + (cam.CFrame.RightVector * relativeMove.X)
    
    if moveVector.Magnitude > 0 then
        BodyVelocity.Velocity = moveVector.Unit * CurrentSpeed
    else
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    StopFlying()
end)

PlayersTab:Section("Player Settings")

_G.SpeedEnabled = false
local originalSpeed = 16
local hasSavedWalkSpeed = false

local SpeedSlider = PlayersTab:Slider({
    Title = "WalkSpeed",
    Min = 1,
    Max = 1000,
    Default = 16,
    Flag = "PlayerSpeed",
    Callback = function(value)
        if _G.SpeedEnabled == true then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
            end)
        end
    end
})

local SpeedToggle = PlayersTab:Toggle({
    Title = "Speed Toggle",
    Default = false,
    Flag = "SpeedEnabled",
    Callback = function(value)
        _G.SpeedEnabled = value
        
        local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid then return end

        if value == true then
            if not hasSavedWalkSpeed then
                originalSpeed = Humanoid.WalkSpeed
                hasSavedWalkSpeed = true
            end
            
            Humanoid.WalkSpeed = SpeedSlider:Get()
            
        else
            Humanoid.WalkSpeed = originalSpeed
        end
    end
})

PlayersTab:Divider()

_G.JumpEnabled = false
local originalJumpPower = 50
local hasSavedJumpPower = false

local JumpSlider = PlayersTab:Slider({
    Title = "JumpPower",
    Min = 50,
    Max = 150,
    Default = 75,
    Flag = "PlayerJump",
    Callback = function(value)
        if _G.JumpEnabled == true then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            end)
        end
    end
})

local JumpToggle = PlayersTab:Toggle({
    Title = "Jump Toggle",
    Default = false,
    Flag = "JumpEnabled",
    Callback = function(value)
        _G.JumpEnabled = value
        
        local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid then return end

        if value == true then
            if not hasSavedJumpPower then
                originalJumpPower = Humanoid.JumpPower
                hasSavedJumpPower = true
            end
            
            Humanoid.JumpPower = JumpSlider:Get()
            
        else
            Humanoid.JumpPower = originalJumpPower
        end
    end
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
                                            
                                            if distance <= checkRadius then
                                                bringItemToPlayer(item)
                                                task.wait(0.1)
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
    Max = 200,
    Default = 50,
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

local BringTab = Window:Tab("Bring", "rbxassetid://7733779610")

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local StartDragging = RemoteEvents:WaitForChild("RequestStartDraggingItem")
local StopDragging = RemoteEvents:WaitForChild("StopDraggingItem")

local FUEL_ITEM_OPTIONS = {
    "Log", "Biofuel", "Oil Barrel", "Fuel Canister", "Coal", "Chair", "Alien", "Feather", "Cultist", "Crossbow Cultist"
}
local METEOR_ITEM_OPTIONS = {
    "Raw Obsidian Ore", "Gold Shard", "Scalding Obsidiron Ingot", "Meteor Shard"
}
local CULTIST_ITEM_OPTIONS = {
    "Cultist", "Crossbow Cultist"
}
local FOOD_AND_HEALING_ITEM_OPTIONS = {
    "Apple", "Bandage", "MedKit", "Chilli", "Carrot", "Pumpkin", "Mackerel", "Salmon", "Swordfish", "Berry", "Ribs", "Stew", "Steak Dinner", "Morsel", "Steak", "Corn", "Cooked Morsel", "Cooked Steak", "Cake"
}
local GEARS_ITEM_OPTIONS = {
    "Bolt", "Tyre", "Sheet Metal", "Old Radio", "Broken Fan", "Broken Microwave", "Washing Machine", "Old Car Engine", "UFO Scrap", "UFO Component", "UFO Junk", "Cultist Gem", "Gem of the Forest"
}
local GUNS_AND_ARMOR_ITEM_OPTIONS = {
    "Infernal Sword", "Crossbow", "Morningstar", "Infernal Crossbow", "Laser Sword", "Raygun", "Ice Axe", "Ice Sword", "Chainsaw", "Strong Axe", "Axe Trim Kit", "Spear", "Good Axe", "Revolver", "Rifle", "Tactical Shotgun", "Revolver Ammo", "Rifle Ammo", "Alien Armour", "Frog Boots", "Leather Body", "Iron Body", "Thron Body", "Riot Shield", "Armour Trim Kit", "Obsidiron Boots"
}
local OTHERS_ITEM_OPTIONS = {
    "Halloween Candle", "Candy", "Frog Key", "Feather", "Wildfire", "Sacrifice Totem", "Old Rod", "Infernal Sack", "Giant Sack", "Seed Box", "Chainsaw", "Old Flashlight", "Strong Flashlight", "Bunny Foot", "Wolf Pelt", "Bear Pelt", "Mammonth Tusk", "Alpha Wolf Pelt", "Bear Corpse", "Meteor Shard", "Gold Shard", "Raw Obsidiron Ore", "Gem of the Forest Fragment", "Diamond", "Defense Blueprint"
}

getgenv().BringLocation = "Player"
getgenv().BringMaxItems = 10
getgenv().BringNoLimit = false
getgenv().BringCooldown = 0.1
getgenv().BringPlayerHeight = 5

getgenv().FuelItemsToBring = {}
getgenv().MeteorItemsToBring = {}
getgenv().CultistItemsToBring = {}
getgenv().FoodAndHealingItemsToBring = {}
getgenv().GearsItemsToBring = {}
getgenv().GunsAndArmorItemsToBring = {}
getgenv().OthersItemsToBring = {}

BringTab:Section("Bring Settings")

BringTab:Dropdown({
    Title = "Bring Location",
    Options = {"Player", "Campfire", "CraftingBench"},
    Default = "Player",
    Flag = "BringLocation",
    Callback = function(selected)
        getgenv().BringLocation = selected
    end
})
BringTab:Input({
    Placeholder = "",
    Title = "Max Items",
    Default = "100",
    Flag = "BringMaxItems",
    Callback = function(text)
        local num = tonumber(text)
        getgenv().BringMaxItems = (num and num > 0) and num or 10
    end
})
BringTab:Input({
    Placeholder = "",
    Title = "Bring Height Offset",
    Default = "5",
    Flag = "BringPlayerHeight",
    Callback = function(text)
        local num = tonumber(text)
        getgenv().BringPlayerHeight = (num) and num or 5
    end
})
BringTab:Input({
    Placeholder = "",
    Title = "Button Cooldown (s)",
    Default = "0.1",
    Flag = "BringCooldown",
    Callback = function(text)
        local num = tonumber(text)
        getgenv().BringCooldown = (num and num >= 0) and num or 0.1
    end
})
BringTab:Toggle({
    Title = "Bring No Limit",
    Default = false,
    Flag = "BringNoLimit",
    Callback = function(state)
        getgenv().BringNoLimit = state
    end
})

local function IsInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then return true end
    end
    return false
end

local function bringSelectedItems(selectedItemNames, notifyTitle)
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then
        warn("ไม่พบโฟลเดอร์ Items!")
        return
    end
    
    if #selectedItemNames == 0 then
        return
    end

    local location = getgenv().BringLocation
    local maxItems = getgenv().BringMaxItems
    local noLimit = getgenv().BringNoLimit
    local bringHeight = getgenv().BringPlayerHeight
    local itemsBrought = 0

    local targetCFrame
    local map = workspace:FindFirstChild("Map")
    local campground = map and map:FindFirstChild("Campground")

    if location == "Player" then
        targetCFrame = hrp.CFrame * CFrame.new(0, bringHeight, 0)
    elseif location == "Campfire" then
        local campfireObj = campground and campground:FindFirstChild("MainFire")
        if campfireObj and campfireObj:IsA("Model") and campfireObj.PrimaryPart then
            targetCFrame = campfireObj.PrimaryPart.CFrame * CFrame.new(0, bringHeight, 0)
        else
            warn("หาไม่เจอ: workspace.Map.Campground.MainFire (Model) หรือไม่มี PrimaryPart")
            return
        end
    elseif location == "CraftingBench" then
        local craftingBenchObj = campground and campground:FindFirstChild("CraftingBench")
        if craftingBenchObj and craftingBenchObj:IsA("Model") and craftingBenchObj.PrimaryPart then
            targetCFrame = craftingBenchObj.PrimaryPart.CFrame * CFrame.new(0, bringHeight, 0)
        else
            warn("หาไม่เจอ: workspace.Map.Campground.CraftingBench (Model) หรือไม่มี PrimaryPart")
            return
        end
    else
        targetCFrame = hrp.CFrame * CFrame.new(0, bringHeight, 0)
    end
    
    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item:IsA("Model") and IsInTable(selectedItemNames, item.Name) then
            if noLimit or itemsBrought < maxItems then
                itemsBrought = itemsBrought + 1
            
                local primaryPart = item.PrimaryPart
                if not primaryPart then
                    primaryPart = Instance.new("Part", item)
                    primaryPart.Name = "PrimaryPartForBring"; primaryPart.Size = Vector3.new(1, 1, 1)
                    primaryPart.Anchored = true; primaryPart.Transparency = 1; primaryPart.CanCollide = false
                    primaryPart.CFrame = item:GetModelCFrame() or CFrame.new(hrp.Position)
                    item.PrimaryPart = primaryPart
                end

                primaryPart.Anchored = true
                item:SetPrimaryPartCFrame(targetCFrame)

                local args = {item}
                StartDragging:FireServer(unpack(args))
                StopDragging:FireServer(unpack(args))
                
                primaryPart.Anchored = false
                print("Brought " .. item.Name .. " (".. itemsBrought ..")")
            else
                print("Reached max item limit (".. maxItems ..")")
                break
            end
        end
    end
    
    if itemsBrought > 0 then
        MacUI:Notify({ Title = "Success!", Content = "Bring " .. notifyTitle .. " เสร็จสิ้น! (" .. itemsBrought .. " ชิ้น)", Duration = 5 })
    else
        MacUI:Notify({ Title = "Not Found", Content = "ไม่พบ " .. notifyTitle .. " ที่เลือก", Duration = 4 })
    end
end

BringTab:Divider()
BringTab:Section("Fuel Selection")
BringTab:Dropdown({
    Title = "Select Fuel Items to Bring",
    Options = FUEL_ITEM_OPTIONS,
    Multi = true,
    Default = {},
    Flag = "SelectedFuelBringItems",
    Callback = function(selected)
        getgenv().FuelItemsToBring = selected
    end
})
local isFuelButtonOnCooldown = false
BringTab:Button({
    Title = "Bring Selected Fuel",
    Desc = "Bring Fuel",
    Callback = function()
        if isFuelButtonOnCooldown then
            return
        end
        isFuelButtonOnCooldown = true
        task.spawn(bringSelectedItems, getgenv().FuelItemsToBring, "Fuel Items")
        
        task.spawn(function()
            task.wait(getgenv().BringCooldown)
            isFuelButtonOnCooldown = false
        end)
    end
})

BringTab:Divider()
BringTab:Section("Bring Meteor")
BringTab:Dropdown({
    Title = "Select Meteor Items to Bring",
    Options = METEOR_ITEM_OPTIONS,
    Multi = true,
    Default = {},
    Flag = "SelectedMeteorItemsBring",
    Callback = function(selected)
        getgenv().MeteorItemsToBring = selected
    end
})
local isMeteorItemsButtonOnCooldown = false
BringTab:Button({
    Title = "Bring Selected Meteor",
    Desc = "Bring Meteor",
    Callback = function()
        if isMeteorItemsButtonOnCooldown then
            return
        end
        isMeteorItemsButtonOnCooldown = true
        task.spawn(bringSelectedItems, getgenv().MeteorItemsToBring, "Meteor Items")
        
        task.spawn(function()
            task.wait(getgenv().BringCooldown)
            isMeteorItemsButtonOnCooldown = false
        end)
    end
})

BringTab:Divider()
BringTab:Section("Bring Cultist")
BringTab:Dropdown({
    Title = "Select Cultist Items to Bring",
    Options = CULTIST_ITEM_OPTIONS,
    Multi = true,
    Default = {},
    Flag = "SelectedCultistBringItems",
    Callback = function(selected)
        getgenv().CultistItemsToBring = selected
    end
})
local isCultistButtonOnCooldown = false
BringTab:Button({
    Title = "Bring Selected Cultist",
    Desc = "Bring Cultist",
    Callback = function()
        if isCultistButtonOnCooldown then
            return
        end
        isCultistButtonOnCooldown = true
        task.spawn(bringSelectedItems, getgenv().CultistItemsToBring, "Cultist Items")
        
        task.spawn(function()
            task.wait(getgenv().BringCooldown)
            isCultistButtonOnCooldown = false
        end)
    end
})

BringTab:Divider()
BringTab:Section("Bring Food and Healing")

BringTab:Dropdown({
    Title = "Select Food and Healing to Bring",
    Options = FOOD_AND_HEALING_ITEM_OPTIONS,
    Multi = true,
    Default = {},
    Flag = "SelectedFoodAndHealingBring",
    Callback = function(selected)
        getgenv().FoodAndHealingItemsToBring = selected
    end
})

local isFoodAndHealingButtonOnCooldown = false
BringTab:Button({
    Title = "Bring Selected Food and Healing",
    Desc = "Bring Food And Healing",
    Callback = function()
        if isFoodAndHealingButtonOnCooldown then
            return
        end
        isFoodAndHealingButtonOnCooldown = true
        task.spawn(bringSelectedItems, getgenv().FoodAndHealingItemsToBring, "Food/Healing Items")
        
        task.spawn(function()
            task.wait(getgenv().BringCooldown)
            isFoodAndHealingButtonOnCooldown = false
        end)
    end
})

BringTab:Divider()
BringTab:Section("Bring Gears")

BringTab:Dropdown({
    Title = "Select Gears to Bring",
    Options = GEARS_ITEM_OPTIONS,
    Multi = true,
    Default = {},
    Flag = "SelectedGearsBring",
    Callback = function(selected)
        getgenv().GearsItemsToBring = selected
    end
})

local isGearsButtonOnCooldown = false
BringTab:Button({
    Title = "Bring Selected Gears",
    Desc = "Bring Gear",
    Callback = function()
        if isGearsButtonOnCooldown then
            return
        end
        isGearsButtonOnCooldown = true
        task.spawn(bringSelectedItems, getgenv().GearsItemsToBring, "Gears")
        
        task.spawn(function()
            task.wait(getgenv().BringCooldown)
            isGearsButtonOnCooldown = false
        end)
    end
})

BringTab:Divider()
BringTab:Section("Bring Guns And Armor")

BringTab:Dropdown({
    Title = "Select Guns And Armor to Bring",
    Options = GUNS_AND_ARMOR_ITEM_OPTIONS,
    Multi = true,
    Default = {},
    Flag = "SelectedGunsAndArmorBring",
    Callback = function(selected)
        getgenv().GunsAndArmorItemsToBring = selected
    end
})

local isGunsAndArmorButtonOnCooldown = false
BringTab:Button({
    Title = "Bring Selected Guns and Armor",
    Desc = "Bring Gun And Armor",
    Callback = function()
        if isGunsAndArmorButtonOnCooldown then
            return
        end
        isGunsAndArmorButtonOnCooldown = true
        task.spawn(bringSelectedItems, getgenv().GunsAndArmorItemsToBring, "Guns/Armor Items")
        
        task.spawn(function()
            task.wait(getgenv().BringCooldown)
            isGunsAndArmorButtonOnCooldown = false
        end)
    end
})

BringTab:Divider()
BringTab:Section("Bring Others")

BringTab:Dropdown({
    Title = "Select Others to Bring",
    Options = OTHERS_ITEM_OPTIONS,
    Multi = true,
    Default = {},
    Flag = "SelectedOthersBring",
    Callback = function(selected)
        getgenv().OthersItemsToBring = selected
    end
})

local isOthersButtonOnCooldown = false
BringTab:Button({
    Title = "Bring Selected Others",
    Desc = "Bring Others",
    Callback = function()
        if isOthersButtonOnCooldown then
            return
        end
        isOthersButtonOnCooldown = true
        task.spawn(bringSelectedItems, getgenv().OthersItemsToBring, "Other Items")
        
        task.spawn(function()
            task.wait(getgenv().BringCooldown)
            isOthersButtonOnCooldown = false
        end)
    end
})

