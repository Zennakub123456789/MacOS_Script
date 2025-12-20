--[[
    MIDNIGHT BENTO LOADER - USER FORMULA
    - Wrapper Frame (Static) -> Holds place in Layout
    - Spinner Image (Rotating) -> Spins inside Wrapper
    - 100% Smooth & Correct
]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

--// CONFIG //--
local CFG = {
    Size = UDim2.new(0, 380, 0, 220),
    MainColor = Color3.fromRGB(12, 12, 12),
    AccentColor = Color3.fromRGB(50, 215, 75),
    ParticleColor = Color3.fromRGB(50, 215, 75),
    ParticleCount = 30,
    ConnectDist = 90,
}

--// GUI SETUP //--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MidnightLoader"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
if pcall(function() return CoreGui end) then
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- Main Window
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = CFG.Size
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.Position = UDim2.new(0.5, 0, 0.55, 0)
Window.BackgroundColor3 = CFG.MainColor
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = ScreenGui

local WinCorner = Instance.new("UICorner")
WinCorner.CornerRadius = UDim.new(0, 14)
WinCorner.Parent = Window

local WinStroke = Instance.new("UIStroke")
WinStroke.Color = CFG.AccentColor
WinStroke.Thickness = 1
WinStroke.Transparency = 0.5
WinStroke.Parent = Window

local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 100, 1, 100)
Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://5028857472"
Glow.ImageColor3 = CFG.AccentColor
Glow.ImageTransparency = 0.85
Glow.ZIndex = 0
Glow.Parent = Window

-- Particle Layer
local ParticleCanvas = Instance.new("Frame")
ParticleCanvas.Size = UDim2.new(1, 0, 1, 0)
ParticleCanvas.BackgroundTransparency = 1
ParticleCanvas.ZIndex = 1
ParticleCanvas.Parent = Window

-- Content Layer
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, 0)
Content.BackgroundTransparency = 1
Content.ZIndex = 5
Content.Parent = Window

local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 35)
Pad.PaddingBottom = UDim.new(0, 25)
Pad.PaddingLeft = UDim.new(0, 30)
Pad.PaddingRight = UDim.new(0, 30)
Pad.Parent = Content

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 15)
UIList.Parent = Content

-- [ELEMENTS]

-- Logo
local Logo = Instance.new("TextLabel")
Logo.LayoutOrder = 1
Logo.Text = "MIDNIGHT <font color=\"rgb(50,215,75)\">PRO</font>"
Logo.RichText = true
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 28
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Size = UDim2.new(1, 0, 0, 30)
Logo.BackgroundTransparency = 1
Logo.Parent = Content

-- Bar BG
local BarBG = Instance.new("Frame")
BarBG.LayoutOrder = 2
BarBG.Size = UDim2.new(1, 0, 0, 4)
BarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BarBG.BorderSizePixel = 0
BarBG.Parent = Content
local BBC = Instance.new("UICorner", BarBG) BBC.CornerRadius = UDim.new(1,0)

-- Bar Fill
local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = CFG.AccentColor
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBG
local BFC = Instance.new("UICorner", BarFill) BFC.CornerRadius = UDim.new(1,0)

-- Status Area
local StatusFrame = Instance.new("Frame")
StatusFrame.LayoutOrder = 3
StatusFrame.Size = UDim2.new(1, 0, 0, 24)
StatusFrame.BackgroundTransparency = 1
StatusFrame.Parent = Content

local StatusList = Instance.new("UIListLayout")
StatusList.FillDirection = Enum.FillDirection.Horizontal
StatusList.HorizontalAlignment = Enum.HorizontalAlignment.Center
StatusList.VerticalAlignment = Enum.VerticalAlignment.Center
StatusList.Padding = UDim.new(0, 10)
StatusList.Parent = StatusFrame

-- [สูตร Wrapper]
-- 1. สร้าง Frame เปล่าๆ (Wrapper) ให้ Layout จัดการ
local SpinnerWrapper = Instance.new("Frame")
SpinnerWrapper.Name = "SpinnerWrapper"
SpinnerWrapper.Size = UDim2.new(0, 18, 0, 18)
SpinnerWrapper.BackgroundTransparency = 1
SpinnerWrapper.Parent = StatusFrame

-- 2. สร้าง ImageLabel (Spinner) ไว้ข้างใน
local Spinner = Instance.new("ImageLabel")
Spinner.Name = "SpinnerImage"
Spinner.Size = UDim2.new(1, 0, 1, 0) -- เต็ม Wrapper
Spinner.Position = UDim2.new(0.5, 0, 0.5, 0)
Spinner.AnchorPoint = Vector2.new(0.5, 0.5) -- จุดหมุนอยู่ตรงกลาง
Spinner.BackgroundTransparency = 1
Spinner.Image = "rbxassetid://6105407885"
Spinner.ImageColor3 = CFG.AccentColor
Spinner.Parent = SpinnerWrapper

-- 3. สั่งหมุนที่ตัว ImageLabel โดยตรง
RunService.RenderStepped:Connect(function(deltaTime)
    if Spinner.Parent then
        Spinner.Rotation = Spinner.Rotation + (180 * deltaTime)
    end
end)

-- Status Text
local StatusText = Instance.new("TextLabel")
StatusText.Text = "INITIALIZING..."
StatusText.Font = Enum.Font.GothamMedium
StatusText.TextSize = 12
StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusText.AutomaticSize = Enum.AutomaticSize.X
StatusText.Size = UDim2.new(0, 0, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Parent = StatusFrame


--// PARTICLE SYSTEM //--
local Particles = {}
local LinePool = {} 

for i = 1, CFG.ParticleCount do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, 2, 0, 2)
    p.BackgroundColor3 = CFG.ParticleColor
    p.BackgroundTransparency = 0.4
    p.BorderSizePixel = 0
    p.AnchorPoint = Vector2.new(0.5, 0.5)
    p.Parent = ParticleCanvas
    local c = Instance.new("UICorner", p) c.CornerRadius = UDim.new(1,0)
    
    table.insert(Particles, {
        Obj = p,
        Pos = Vector2.new(math.random(), math.random()),
        Vel = Vector2.new(math.random(-2,2)/2000, math.random(-2,2)/2000)
    })
end

for i = 1, 50 do
    local l = Instance.new("Frame")
    l.BackgroundColor3 = CFG.ParticleColor
    l.BorderSizePixel = 0
    l.AnchorPoint = Vector2.new(0.5, 0.5)
    l.Visible = false
    l.Parent = ParticleCanvas
    table.insert(LinePool, l)
end

RunService.RenderStepped:Connect(function()
    local AbsSize = Window.AbsoluteSize
    for _, l in ipairs(LinePool) do l.Visible = false end
    local lineIdx = 1
    
    for i, p in ipairs(Particles) do
        p.Pos = p.Pos + p.Vel
        if p.Pos.X < 0 or p.Pos.X > 1 then p.Vel = Vector2.new(-p.Vel.X, p.Vel.Y) end
        if p.Pos.Y < 0 or p.Pos.Y > 1 then p.Vel = Vector2.new(p.Vel.X, -p.Vel.Y) end
        p.Obj.Position = UDim2.new(p.Pos.X, 0, p.Pos.Y, 0)
        
        for j = i + 1, #Particles do
            local p2 = Particles[j]
            local vDiff = (p.Pos * AbsSize) - (p2.Pos * AbsSize)
            local dist = vDiff.Magnitude
            
            if dist < CFG.ConnectDist and lineIdx <= #LinePool then
                local line = LinePool[lineIdx]
                local center = (p.Pos + p2.Pos) / 2
                local angle = math.atan2(vDiff.Y, vDiff.X)
                
                line.Size = UDim2.new(0, dist, 0, 1)
                line.Position = UDim2.new(center.X, 0, center.Y, 0)
                line.Rotation = math.deg(angle)
                line.BackgroundTransparency = 0.5 + (dist / CFG.ConnectDist) * 0.5
                line.Visible = true
                lineIdx = lineIdx + 1
            end
        end
    end
end)


--// LOADING LOGIC //--
task.spawn(function()
    local progress = 0
    while progress < 100 do
        local increment = 0
        if progress < 30 then
            increment = math.random(5, 15) / 10
            StatusText.Text = "CHECKING WHITELIST..."
        elseif progress < 80 then
             increment = math.random(5, 10) / 10
            StatusText.Text = "LOADING MODULES..."
        elseif progress < 90 then
            increment = math.random(1, 3) / 10
            StatusText.Text = "FINALIZING..."
        else
            increment = math.random(20, 40) / 10
        end
        progress = progress + increment
        if progress > 100 then progress = 100 end
        
        TweenService:Create(BarFill, TweenInfo.new(0.05), {Size = UDim2.new(progress/100, 0, 1, 0)}):Play()
        task.wait(math.random(1, 3) / 100)
    end
    
    StatusText.Text = "READY"
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    task.wait(0.2)
    BarFill.BackgroundColor3 = CFG.AccentColor
    
    task.wait(0.3)
    local info = TweenInfo.new(0.4)
    TweenService:Create(Window, info, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    TweenService:Create(WinStroke, info, {Transparency = 1}):Play()
    
    for _, v in pairs(Window:GetDescendants()) do
        if v:IsA("GuiObject") then
             if v ~= Window then
                 TweenService:Create(v, info, {Transparency = 1, BackgroundTransparency = 1}):Play()
             end
        end
    end

    task.wait(0.5)
    ScreenGui:Destroy()
    
    print("Loader Finished.")
end)
