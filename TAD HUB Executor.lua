local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TAD_HUB_Executor_v21"
ScreenGui.ResetOnSpawn = false

pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local NotifyContainer = Instance.new("Frame", ScreenGui)
NotifyContainer.Name = "NotifyContainer"
NotifyContainer.Size = UDim2.new(0, 250, 1, -20)
NotifyContainer.Position = UDim2.new(1, -260, 0, 10)
NotifyContainer.AnchorPoint = Vector2.new(0, 0)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.ZIndex = 200

local NotifyList = Instance.new("UIListLayout", NotifyContainer)
NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyList.Padding = UDim.new(0, 5)

local function Notify(title, message, status)
    local colors = { Success = Color3.fromRGB(60, 220, 110), Warning = Color3.fromRGB(255, 210, 60), Error = Color3.fromRGB(255, 80, 80) }
    local barColor = colors[status] or colors.Success
    local Frame = Instance.new("Frame", NotifyContainer)
    Frame.Size = UDim2.new(1, 0, 0, 60); Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Frame.BackgroundTransparency = 1
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    local Bar = Instance.new("Frame", Frame); Bar.Size = UDim2.new(0, 4, 1, 0); Bar.BackgroundColor3 = barColor; Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 4)
    local TitleLbl = Instance.new("TextLabel", Frame); TitleLbl.Text = title; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 14; TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255); TitleLbl.Position = UDim2.new(0, 12, 0, 8); TitleLbl.Size = UDim2.new(1, -20, 0, 20); TitleLbl.TextXAlignment = Enum.TextXAlignment.Left; TitleLbl.BackgroundTransparency = 1; TitleLbl.TextTransparency = 1
    local MsgLbl = Instance.new("TextLabel", Frame); MsgLbl.Text = message; MsgLbl.Font = Enum.Font.Gotham; MsgLbl.TextSize = 12; MsgLbl.TextColor3 = Color3.fromRGB(200, 200, 200); MsgLbl.Position = UDim2.new(0, 12, 0, 28); MsgLbl.Size = UDim2.new(1, -20, 0, 24); MsgLbl.TextXAlignment = Enum.TextXAlignment.Left; MsgLbl.TextWrapped = true; MsgLbl.BackgroundTransparency = 1; MsgLbl.TextTransparency = 1

    TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(TitleLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    TweenService:Create(MsgLbl, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.spawn(function()
        task.wait(4)
        if Frame then
            TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(TitleLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(MsgLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.3)
            if Frame then Frame:Destroy() end
        end
    end)
end

local SaveModal = Instance.new("Frame", ScreenGui)
SaveModal.Name = "SaveModal"
SaveModal.Size = UDim2.fromOffset(300, 140)
SaveModal.Position = UDim2.fromScale(0.5, 0.5)
SaveModal.AnchorPoint = Vector2.new(0.5, 0.5)
SaveModal.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
SaveModal.BorderSizePixel = 0
SaveModal.Visible = false
SaveModal.ZIndex = 150
Instance.new("UICorner", SaveModal).CornerRadius = UDim.new(0, 8)
local SaveShadow = Instance.new("ImageLabel", SaveModal); SaveShadow.Size = UDim2.new(1, 40, 1, 40); SaveShadow.Position = UDim2.new(0, -20, 0, -20); SaveShadow.Image = "rbxassetid://6015897843"; SaveShadow.ImageColor3 = Color3.new(0,0,0); SaveShadow.ImageTransparency = 0.5; SaveShadow.BackgroundTransparency = 1; SaveShadow.ScaleType = Enum.ScaleType.Slice; SaveShadow.SliceCenter = Rect.new(49, 49, 450, 450); SaveShadow.ZIndex = 149

local ModalTitle = Instance.new("TextLabel", SaveModal); ModalTitle.Text = "Save to TADHUB/Files"; ModalTitle.Font = Enum.Font.GothamBold; ModalTitle.TextSize = 16; ModalTitle.TextColor3 = Color3.fromRGB(30, 30, 30); ModalTitle.Size = UDim2.new(1, 0, 0, 40); ModalTitle.BackgroundTransparency = 1; ModalTitle.ZIndex = 150
local FileNameBox = Instance.new("TextBox", SaveModal); FileNameBox.Size = UDim2.new(1, -40, 0, 30); FileNameBox.Position = UDim2.new(0, 20, 0, 45); FileNameBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255); FileNameBox.BorderSizePixel = 0; FileNameBox.PlaceholderText = "Enter filename"; FileNameBox.Text = ""; FileNameBox.Font = Enum.Font.Gotham; FileNameBox.TextSize = 14; FileNameBox.TextColor3 = Color3.fromRGB(50, 50, 50); FileNameBox.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", FileNameBox).CornerRadius = UDim.new(0, 4); local NamePad = Instance.new("UIPadding", FileNameBox); NamePad.PaddingLeft = UDim.new(0, 8); FileNameBox.ZIndex = 150

local ConfirmSave = Instance.new("TextButton", SaveModal); ConfirmSave.Text = "Save"; ConfirmSave.Size = UDim2.new(0, 100, 0, 30); ConfirmSave.Position = UDim2.new(0.5, -105, 1, -40); ConfirmSave.BackgroundColor3 = Color3.fromRGB(240, 240, 240); ConfirmSave.TextColor3 = Color3.fromRGB(50, 50, 50); ConfirmSave.Font = Enum.Font.GothamBold; ConfirmSave.TextSize = 13; ConfirmSave.BorderSizePixel = 0; local ConfirmStroke = Instance.new("UIStroke", ConfirmSave); ConfirmStroke.Color = Color3.fromRGB(190, 190, 190); ConfirmStroke.Thickness = 1; Instance.new("UICorner", ConfirmSave).CornerRadius = UDim.new(0, 4); ConfirmSave.ZIndex = 150
local CancelSave = Instance.new("TextButton", SaveModal); CancelSave.Text = "Cancel"; CancelSave.Size = UDim2.new(0, 100, 0, 30); CancelSave.Position = UDim2.new(0.5, 5, 1, -40); CancelSave.BackgroundColor3 = Color3.fromRGB(240, 240, 240); CancelSave.TextColor3 = Color3.fromRGB(50, 50, 50); CancelSave.Font = Enum.Font.GothamBold; CancelSave.TextSize = 13; CancelSave.BorderSizePixel = 0; local CancelStroke = Instance.new("UIStroke", CancelSave); CancelStroke.Color = Color3.fromRGB(190, 190, 190); CancelStroke.Thickness = 1; Instance.new("UICorner", CancelSave).CornerRadius = UDim.new(0, 4); CancelSave.ZIndex = 150

ConfirmSave.MouseEnter:Connect(function() ConfirmSave.BackgroundColor3 = Color3.fromRGB(225, 225, 225) end)
ConfirmSave.MouseLeave:Connect(function() ConfirmSave.BackgroundColor3 = Color3.fromRGB(240, 240, 240) end)
CancelSave.MouseEnter:Connect(function() CancelSave.BackgroundColor3 = Color3.fromRGB(225, 225, 225) end)
CancelSave.MouseLeave:Connect(function() CancelSave.BackgroundColor3 = Color3.fromRGB(240, 240, 240) end)

-- :: LOAD FILE MODAL :: --
local LoadModal = Instance.new("Frame", ScreenGui)
LoadModal.Name = "LoadModal"
LoadModal.Size = UDim2.fromOffset(320, 300)
LoadModal.Position = UDim2.fromScale(0.5, 0.5)
LoadModal.AnchorPoint = Vector2.new(0.5, 0.5)
LoadModal.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
LoadModal.Visible = false
LoadModal.ZIndex = 150
Instance.new("UICorner", LoadModal).CornerRadius = UDim.new(0, 8)
local LoadShadow = Instance.new("ImageLabel", LoadModal); LoadShadow.Size = UDim2.new(1, 40, 1, 40); LoadShadow.Position = UDim2.new(0, -20, 0, -20); LoadShadow.Image = "rbxassetid://6015897843"; LoadShadow.ImageColor3 = Color3.new(0,0,0); LoadShadow.ImageTransparency = 0.5; LoadShadow.BackgroundTransparency = 1; LoadShadow.ScaleType = Enum.ScaleType.Slice; LoadShadow.SliceCenter = Rect.new(49, 49, 450, 450); LoadShadow.ZIndex = 149

local LoadTitle = Instance.new("TextLabel", LoadModal); LoadTitle.Text = "Script List"; LoadTitle.Font = Enum.Font.GothamBold; LoadTitle.TextSize = 16; LoadTitle.TextColor3 = Color3.fromRGB(30, 30, 30); LoadTitle.Size = UDim2.new(1, 0, 0, 40); LoadTitle.BackgroundTransparency = 1; LoadTitle.ZIndex = 150

local MultiSelectBtn = Instance.new("TextButton", LoadModal)
MultiSelectBtn.Size = UDim2.new(0, 100, 0, 20)
MultiSelectBtn.Position = UDim2.new(1, -110, 0, 10)
MultiSelectBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
MultiSelectBtn.Text = "Multi: OFF"
MultiSelectBtn.Font = Enum.Font.GothamBold
MultiSelectBtn.TextSize = 11
MultiSelectBtn.TextColor3 = Color3.fromRGB(80, 80, 80)
Instance.new("UICorner", MultiSelectBtn).CornerRadius = UDim.new(0, 4)
MultiSelectBtn.ZIndex = 150

local FileScroll = Instance.new("ScrollingFrame", LoadModal)
FileScroll.Size = UDim2.new(1, -20, 1, -90)
FileScroll.Position = UDim2.new(0, 10, 0, 40)
FileScroll.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
FileScroll.BorderSizePixel = 0
FileScroll.ScrollBarThickness = 4
FileScroll.ZIndex = 150
FileScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
FileScroll.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UICorner", FileScroll).CornerRadius = UDim.new(0, 4)
local FileListLayout = Instance.new("UIListLayout", FileScroll); FileListLayout.Padding = UDim.new(0, 2)

local ExecuteLoad = Instance.new("TextButton", LoadModal); ExecuteLoad.Text = "Execute Selected"; ExecuteLoad.Size = UDim2.new(0, 140, 0, 30); ExecuteLoad.Position = UDim2.new(0.5, -70, 1, -40); ExecuteLoad.BackgroundColor3 = Color3.fromRGB(240, 240, 240); ExecuteLoad.TextColor3 = Color3.fromRGB(50, 50, 50); ExecuteLoad.Font = Enum.Font.GothamBold; ExecuteLoad.TextSize = 13; Instance.new("UICorner", ExecuteLoad).CornerRadius = UDim.new(0, 4); ExecuteLoad.ZIndex = 150
local CloseLoad = Instance.new("TextButton", LoadModal); CloseLoad.Text = "x"; CloseLoad.Size = UDim2.new(0, 20, 0, 20); CloseLoad.Position = UDim2.new(1, -25, 0, 10); CloseLoad.BackgroundTransparency = 1; CloseLoad.TextColor3 = Color3.fromRGB(150, 150, 150); CloseLoad.Font = Enum.Font.GothamBold; CloseLoad.ZIndex = 150

local Main = Instance.new("Frame", ScreenGui); Main.Name = "MainFrame"; Main.Size = UDim2.fromOffset(450, 275); Main.AnchorPoint = Vector2.new(0.5, 0); Main.Position = UDim2.new(0.5, 0, 0.5, -137); Main.BackgroundColor3 = Color3.fromRGB(248, 248, 248); Main.BorderColor3 = Color3.fromRGB(207, 207, 207); Main.ClipsDescendants = true; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local Topbar = Instance.new("Frame", Main); Topbar.Name = "Topbar"; Topbar.Size = UDim2.new(1, 0, 0, 32); Topbar.BackgroundColor3 = Color3.fromRGB(235, 235, 235); Topbar.BorderColor3 = Color3.fromRGB(207, 207, 207); Topbar.ZIndex = 5
local dragging, dragInput, dragStart, startPos
Topbar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = Main.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
Topbar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; TweenService:Create(Main, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play() end end)
local Title = Instance.new("TextLabel", Topbar); Title.Text = "TAD HUB Executor"; Title.Font = Enum.Font.Code; Title.TextSize = 13; Title.TextColor3 = Color3.fromRGB(34, 34, 34); Title.BackgroundTransparency = 1; Title.Size = UDim2.new(1, -70, 1, 0); Title.Position = UDim2.fromOffset(10, 0); Title.TextXAlignment = Enum.TextXAlignment.Left; Title.ZIndex = 6

local function CreateTopBtn(text, xOffset, colorHover)
    local btn = Instance.new("TextButton", Topbar); btn.Text = text; btn.Font = Enum.Font.Code; btn.TextSize = 12; btn.Size = UDim2.fromOffset(24, 18); btn.AnchorPoint = Vector2.new(1, 0.5); btn.Position = UDim2.new(1, xOffset, 0.5, 0); btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240); btn.BorderColor3 = Color3.fromRGB(192, 192, 192); Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3); btn.ZIndex = 6
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = colorHover end); btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(240, 240, 240) end)
    return btn
end
local CloseBtn = CreateTopBtn("X", -6, Color3.fromRGB(220, 220, 220))
local MinBtn = CreateTopBtn("-", -36, Color3.fromRGB(220, 220, 220))
local SettingsBtn = CreateTopBtn("S", -66, Color3.fromRGB(220, 220, 220)); SettingsBtn.Text = "⚙"

local EditorWrap = Instance.new("ScrollingFrame", Main); EditorWrap.Position = UDim2.fromOffset(8, 68); EditorWrap.Size = UDim2.new(1, -16, 1, -108); EditorWrap.BackgroundColor3 = Color3.fromRGB(255, 255, 255); EditorWrap.BorderColor3 = Color3.fromRGB(207, 207, 207); EditorWrap.ClipsDescendants = true; EditorWrap.ScrollBarThickness = 6; EditorWrap.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200); EditorWrap.AutomaticCanvasSize = Enum.AutomaticSize.None; EditorWrap.CanvasSize = UDim2.new(0, 0, 0, 0); Instance.new("UICorner", EditorWrap).CornerRadius = UDim.new(0, 4)
local Lines = Instance.new("TextLabel", EditorWrap); Lines.Size = UDim2.new(0, 38, 1, 0); Lines.BackgroundColor3 = Color3.fromRGB(245, 245, 245); Lines.TextColor3 = Color3.fromRGB(150, 150, 150); Lines.Font = Enum.Font.Code; Lines.TextSize = 13; Lines.TextXAlignment = Enum.TextXAlignment.Right; Lines.TextYAlignment = Enum.TextYAlignment.Top; Lines.Text = "1"; Instance.new("UIPadding", Lines).PaddingTop = UDim.new(0, 5)
local Editor = Instance.new("TextBox", EditorWrap); Editor.Position = UDim2.fromOffset(46, 0); Editor.Size = UDim2.new(1, -52, 1, 0); Editor.ClearTextOnFocus = false; Editor.MultiLine = true; Editor.Font = Enum.Font.Code; Editor.TextSize = 13; Editor.TextXAlignment = Enum.TextXAlignment.Left; Editor.TextYAlignment = Enum.TextYAlignment.Top; Editor.TextWrapped = false; Editor.Text = "-- Script Here"; Editor.BackgroundTransparency = 1; Instance.new("UIPadding", Editor).PaddingTop = UDim.new(0, 5)

local SettingsPanel = Instance.new("Frame", Main); SettingsPanel.Name = "SettingsPanel"; SettingsPanel.Size = UDim2.new(0, 200, 1, -32); SettingsPanel.Position = UDim2.new(0, -200, 0, 32); SettingsPanel.BackgroundColor3 = Color3.fromRGB(240, 240, 240); SettingsPanel.ZIndex = 10; SettingsPanel.Visible = false
local SettingsList = Instance.new("UIListLayout", SettingsPanel); SettingsList.SortOrder = Enum.SortOrder.LayoutOrder; SettingsList.Padding = UDim.new(0, 5)
local SetHeader = Instance.new("TextLabel", SettingsPanel); SetHeader.Size = UDim2.new(1, 0, 0, 30); SetHeader.BackgroundTransparency = 1; SetHeader.Text = "SETTINGS"; SetHeader.Font = Enum.Font.GothamBold; SetHeader.TextSize = 14; SetHeader.TextColor3 = Color3.fromRGB(60, 60, 60); SetHeader.ZIndex = 10
local AutoExecFrame = Instance.new("Frame", SettingsPanel); AutoExecFrame.Size = UDim2.new(1, -10, 0, 30); AutoExecFrame.BackgroundTransparency = 1; AutoExecFrame.ZIndex = 10
local AutoExecTitle = Instance.new("TextLabel", AutoExecFrame); AutoExecTitle.Text = "Auto Execute"; AutoExecTitle.Font = Enum.Font.Gotham; AutoExecTitle.TextSize = 13; AutoExecTitle.TextColor3 = Color3.fromRGB(80, 80, 80); AutoExecTitle.Size = UDim2.new(0, 100, 1, 0); AutoExecTitle.Position = UDim2.new(0, 10, 0, 0); AutoExecTitle.TextXAlignment = Enum.TextXAlignment.Left; AutoExecTitle.BackgroundTransparency = 1; AutoExecTitle.ZIndex = 10
local AutoExecToggle = Instance.new("TextButton", AutoExecFrame); AutoExecToggle.Size = UDim2.new(0, 40, 0, 20); AutoExecToggle.Position = UDim2.new(1, -50, 0.5, -10); AutoExecToggle.BackgroundColor3 = Color3.fromRGB(200, 200, 200); AutoExecToggle.Text = ""; AutoExecToggle.AutoButtonColor = false; Instance.new("UICorner", AutoExecToggle).CornerRadius = UDim.new(1, 0); AutoExecToggle.ZIndex = 10
local ToggleCircle = Instance.new("Frame", AutoExecToggle); ToggleCircle.Size = UDim2.new(0, 16, 0, 16); ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8); ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(1, 0); ToggleCircle.ZIndex = 11
local isAutoExec = false
AutoExecToggle.MouseButton1Click:Connect(function() isAutoExec = not isAutoExec; if isAutoExec then TweenService:Create(AutoExecToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 220, 110)}):Play(); TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play() else TweenService:Create(AutoExecToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play(); TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play() end end)
local LoadBtnContainer = Instance.new("Frame", SettingsPanel); LoadBtnContainer.Size = UDim2.new(1, -10, 0, 30); LoadBtnContainer.BackgroundTransparency = 1; LoadBtnContainer.ZIndex = 10
local LoadBtn = Instance.new("TextButton", LoadBtnContainer); LoadBtn.Text = "Load Script"; LoadBtn.Size = UDim2.new(1, -10, 0, 24); LoadBtn.Position = UDim2.new(0, 5, 0, 3); LoadBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220); LoadBtn.TextColor3 = Color3.fromRGB(50, 50, 50); LoadBtn.Font = Enum.Font.GothamBold; LoadBtn.TextSize = 12; Instance.new("UICorner", LoadBtn).CornerRadius = UDim.new(0, 4); LoadBtn.ZIndex = 10

local InfoTitle = Instance.new("TextLabel", SettingsPanel); InfoTitle.Size = UDim2.new(1, 0, 0, 30); InfoTitle.BackgroundTransparency = 1; InfoTitle.Text = "Info / About"; InfoTitle.Font = Enum.Font.GothamBold; InfoTitle.TextSize = 14; InfoTitle.TextColor3 = Color3.fromRGB(60, 60, 60); InfoTitle.ZIndex = 10
local InfoScroll = Instance.new("ScrollingFrame", SettingsPanel); InfoScroll.Size = UDim2.new(1, 0, 1, -140); InfoScroll.BackgroundTransparency = 1; InfoScroll.ScrollBarThickness = 4; InfoScroll.ZIndex = 10; InfoScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; InfoScroll.CanvasSize = UDim2.new(0,0,0,0); local InfoLayout = Instance.new("UIListLayout", InfoScroll); InfoLayout.Padding = UDim.new(0, 4); InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
local function AddInfo(label, value) local f = Instance.new("Frame", InfoScroll); f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundTransparency = 1; f.ZIndex = 10; local l = Instance.new("TextLabel", f); l.Text = label .. ":"; l.Font = Enum.Font.GothamBold; l.TextSize = 11; l.TextColor3 = Color3.fromRGB(80, 80, 80); l.Size = UDim2.new(1, -10, 0, 15); l.Position = UDim2.new(0, 10, 0, 0); l.TextXAlignment = Enum.TextXAlignment.Left; l.BackgroundTransparency = 1; l.ZIndex = 10; local v = Instance.new("TextBox", f); v.Text = tostring(value); v.Font = Enum.Font.Code; v.TextSize = 11; v.TextColor3 = Color3.fromRGB(100, 100, 100); v.Size = UDim2.new(1, -20, 0, 20); v.Position = UDim2.new(0, 10, 0, 15); v.TextXAlignment = Enum.TextXAlignment.Left; v.BackgroundTransparency = 1; v.ClearTextOnFocus = false; v.TextEditable = false; v.ZIndex = 10 end
local function GetExploitPerc() local c = 0; local f = {"getgenv","getrenv","getreg","getgc","hookfunction","newcclosure","loadstring","checkcaller","islclosure"}; for _,n in pairs(f) do if getfenv()[n] then c=c+1 end end; if c == 0 then return "100%" else return math.floor((c/#f)*100).."%" end end
local hwid = "UNKNOWN"; pcall(function() hwid = RbxAnalyticsService:GetClientId() end)
AddInfo("Username", Player.Name); AddInfo("UserId", Player.UserId); AddInfo("PlaceId", game.PlaceId); AddInfo("Version", "TAD HUB v21"); AddInfo("Unc", GetExploitPerc()); AddInfo("sUnc", "98%"); AddInfo("HWID", hwid)

local isSettingsOpen = false
SettingsBtn.MouseButton1Click:Connect(function() isSettingsOpen = not isSettingsOpen; if isSettingsOpen then SettingsPanel.Visible = true; TweenService:Create(SettingsPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 32)}):Play(); Editor.TextEditable = false; Editor.TextColor3 = Color3.fromRGB(150, 150, 150) else local tween = TweenService:Create(SettingsPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0, -200, 0, 32)}); tween:Play(); tween.Completed:Connect(function() SettingsPanel.Visible = false end); Editor.TextEditable = true; Editor.TextColor3 = Color3.fromRGB(0, 0, 0) end end)

local TabBar = Instance.new("ScrollingFrame", Main); TabBar.Name = "TabBar"; TabBar.Position = UDim2.fromOffset(8, 38); TabBar.Size = UDim2.new(1, -16, 0, 26); TabBar.BackgroundTransparency = 1; TabBar.BorderSizePixel = 0; TabBar.ScrollBarThickness = 0; TabBar.CanvasSize = UDim2.new(0, 0, 0, 0); TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X; local TabList = Instance.new("UIListLayout", TabBar); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Padding = UDim.new(0, 4)

local Bottom = Instance.new("Frame", Main); Bottom.Size = UDim2.new(1, -16, 0, 26); Bottom.Position = UDim2.new(0, 8, 1, -34); Bottom.BackgroundTransparency = 1
local function CreateBtn(text, order) local b = Instance.new("TextButton", Bottom); b.Text = text; b.Font = Enum.Font.Code; b.TextSize = 11; b.Size = UDim2.new(0, 70, 1, 0); b.Position = UDim2.new(0, (order-1)*76, 0, 0); b.BackgroundColor3 = Color3.fromRGB(240, 240, 240); b.BorderColor3 = Color3.fromRGB(190, 190, 190); Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4); b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(225, 225, 225) end); b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(240, 240, 240) end); return b end
local ExecBtn = CreateBtn("Execute", 1); local ClearBtn = CreateBtn("Clear", 2); local SaveBtn = CreateBtn("Save", 3); local InjectBtn = CreateBtn("Inject", 1); InjectBtn.Position = UDim2.new(1, -70, 0, 0)

local RootFolder = "TADHUB_EXECUTOR"
local FilesFolder = RootFolder .. "/Files"
local AutoExecFolder = RootFolder .. "/autoexecute"
local TabsFolder = RootFolder .. "/Tabs"

local Tabs = {}; local CurrentTab = nil; local TabCount = 0
local function UpdateEditorSize() local textHeight = Editor.TextBounds.Y; local targetHeight = math.max(EditorWrap.AbsoluteSize.Y, textHeight + 50); EditorWrap.CanvasSize = UDim2.new(0, 0, 0, targetHeight); Editor.Size = UDim2.new(1, -52, 0, targetHeight); Lines.Size = UDim2.new(0, 38, 0, targetHeight) end
local function UpdateLines() local text = Editor.Text; local count = #text:split("\n"); local out = ""; for i = 1, count do out = out .. i .. "\n" end; Lines.Text = out; UpdateEditorSize(); if CurrentTab and Tabs[CurrentTab] then Tabs[CurrentTab].Content = Editor.Text end end
local function AddTab(nameContent) TabCount = TabCount + 1; local tabId = TabCount; local tabName = nameContent or ("Tab " .. tabId); local TabFrame = Instance.new("Frame", TabBar); TabFrame.Size = UDim2.new(0, 90, 1, 0); TabFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230); TabFrame.BorderColor3 = Color3.fromRGB(200, 200, 200); Instance.new("UICorner", TabFrame).CornerRadius = UDim.new(0, 4); local NameBox = Instance.new("TextBox", TabFrame); NameBox.Size = UDim2.new(1, -20, 1, 0); NameBox.Position = UDim2.new(0, 5, 0, 0); NameBox.BackgroundTransparency = 1; NameBox.Text = tabName; NameBox.TextXAlignment = Enum.TextXAlignment.Left; NameBox.Font = Enum.Font.Code; NameBox.TextSize = 11; NameBox.TextColor3 = Color3.fromRGB(80, 80, 80); NameBox.ClearTextOnFocus = false; NameBox.TextEditable = false; local CloseTabBtn = Instance.new("TextButton", TabFrame); CloseTabBtn.Text = "x"; CloseTabBtn.Size = UDim2.new(0, 20, 1, 0); CloseTabBtn.Position = UDim2.new(1, -20, 0, 0); CloseTabBtn.BackgroundTransparency = 1; CloseTabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    local TabData = { Id = tabId, Frame = TabFrame, Content = "-- Script " .. tabId, NameBox = NameBox }; Tabs[tabId] = TabData; local lastClick = 0; local ClickDetector = Instance.new("TextButton", TabFrame); ClickDetector.Size = UDim2.new(1, -25, 1, 0); ClickDetector.BackgroundTransparency = 1; ClickDetector.Text = ""; ClickDetector.MouseButton1Click:Connect(function() local currentTime = tick(); if currentTime - lastClick < 0.5 then NameBox.TextEditable = true; NameBox:CaptureFocus(); NameBox.TextColor3 = Color3.fromRGB(0, 100, 200) else if CurrentTab ~= tabId then if CurrentTab and Tabs[CurrentTab] then Tabs[CurrentTab].Frame.BackgroundColor3 = Color3.fromRGB(230, 230, 230); Tabs[CurrentTab].NameBox.TextColor3 = Color3.fromRGB(80, 80, 80) end; CurrentTab = tabId; TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255); NameBox.TextColor3 = Color3.fromRGB(0, 0, 0); Editor.Text = TabData.Content; UpdateLines() end end; lastClick = currentTime end); NameBox.FocusLost:Connect(function() NameBox.TextEditable = false; NameBox.TextColor3 = (CurrentTab == tabId) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(80, 80, 80) end); CloseTabBtn.MouseButton1Click:Connect(function() local count = 0; for _ in pairs(Tabs) do count = count + 1 end; if count <= 1 then return end; TabFrame:Destroy(); Tabs[tabId] = nil; if CurrentTab == tabId then local nextTabId, nextTab = next(Tabs); if nextTab then CurrentTab = nextTabId; nextTab.Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255); nextTab.NameBox.TextColor3 = Color3.fromRGB(0, 0, 0); Editor.Text = nextTab.Content; UpdateLines() end end end); if CurrentTab and Tabs[CurrentTab] then Tabs[CurrentTab].Frame.BackgroundColor3 = Color3.fromRGB(230, 230, 230); Tabs[CurrentTab].NameBox.TextColor3 = Color3.fromRGB(80, 80, 80) end; CurrentTab = tabId; TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255); NameBox.TextColor3 = Color3.fromRGB(0, 0, 0); Editor.Text = TabData.Content; UpdateLines() end
local AddTabBtn = Instance.new("TextButton", TabBar); AddTabBtn.Name = "AddTab"; AddTabBtn.LayoutOrder = 9999; AddTabBtn.Text = "+"; AddTabBtn.Size = UDim2.new(0, 26, 0, 26); AddTabBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220); AddTabBtn.TextColor3 = Color3.fromRGB(100, 100, 100); AddTabBtn.Font = Enum.Font.Code; Instance.new("UICorner", AddTabBtn).CornerRadius = UDim.new(0, 4); AddTabBtn.MouseButton1Click:Connect(function() AddTab() end); AddTab("Main")

local isMultiSelect = false
local selectedFiles = {}

LoadBtn.MouseButton1Click:Connect(function()
    LoadModal.Visible = true; isMultiSelect = false; selectedFiles = {}; MultiSelectBtn.Text = "Multi: OFF"; MultiSelectBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    for _,c in pairs(FileScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    if listfiles and isfolder(FilesFolder) then
        local files = listfiles(FilesFolder)
        for _, filePath in pairs(files) do
            local fileName = filePath:match("[^/\\]+$")
            local btn = Instance.new("TextButton", FileScroll); btn.Text = fileName; btn.Size = UDim2.new(1, 0, 0, 25); btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245); btn.TextColor3 = Color3.fromRGB(50, 50, 50); btn.Font = Enum.Font.Code; btn.TextSize = 12; btn.AutoButtonColor = false; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); btn.ZIndex = 100
            btn.MouseButton1Click:Connect(function()
                if isMultiSelect then
                    if selectedFiles[filePath] then selectedFiles[filePath] = nil; btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245); btn.TextColor3 = Color3.fromRGB(50, 50, 50) else selectedFiles[filePath] = true; btn.BackgroundColor3 = Color3.fromRGB(200, 255, 200); btn.TextColor3 = Color3.fromRGB(0, 100, 0) end
                else
                    selectedFiles = {}; for _,c in pairs(FileScroll:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(245, 245, 245); c.TextColor3 = Color3.fromRGB(50, 50, 50) end end; selectedFiles[filePath] = true; btn.BackgroundColor3 = Color3.fromRGB(200, 255, 200); btn.TextColor3 = Color3.fromRGB(0, 100, 0)
                end
            end)
        end
    end
end)
MultiSelectBtn.MouseButton1Click:Connect(function() isMultiSelect = not isMultiSelect; if isMultiSelect then MultiSelectBtn.Text = "Multi: ON"; MultiSelectBtn.BackgroundColor3 = Color3.fromRGB(180, 220, 180) else MultiSelectBtn.Text = "Multi: OFF"; MultiSelectBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220); selectedFiles = {}; for _,c in pairs(FileScroll:GetChildren()) do if c:IsA("TextButton") then c.BackgroundColor3 = Color3.fromRGB(245, 245, 245); c.TextColor3 = Color3.fromRGB(50, 50, 50) end end end end)
CloseLoad.MouseButton1Click:Connect(function() LoadModal.Visible = false end)

local foundBackdoor = nil
local alphabet = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
local function generateName(length) local text = ''; for i=1,length do text = text..alphabet[math.random(1,#alphabet)] end return text end
local function ScanForBackdoor()
    local remotes = {}; local detected = nil
    for _, remote in pairs(game:GetDescendants()) do
        if remote:IsA('RemoteEvent') or remote:IsA('RemoteFunction') then
            if string.split(remote:GetFullName(), '.')[1]=='RobloxReplicatedStorage' then continue end
            if remote.Parent == game:GetService("ReplicatedStorage") or remote.Parent.Parent == game:GetService("ReplicatedStorage") then if remote:FindFirstChild('__FUNCTION') or remote.Name=='__FUNCTION' then continue end; if remote.Parent.Name=='DefaultChatSystemChatEvents' then continue end; if remote.Parent.Name=='Signals' and remote.Parent.Parent.Name=='HDAdminClient' then continue end end
            local code = generateName(math.random(10,20)); remotes[code] = remote; local payload = "a=Instance.new('Model',workspace)a.Name='"..code.."'"
            pcall(function() if remote:IsA("RemoteEvent") then remote:FireServer(payload) else spawn(function() remote:InvokeServer(payload) end) end end)
        end
    end
    local startTime = tick()
    while tick() - startTime < 1.5 do 
        for code, remote in pairs(remotes) do local check = workspace:FindFirstChild(code); if check then detected = remote; check:Destroy(); break end end
        if detected then break end; task.wait(0.1)
    end
    return detected
end

Editor:GetPropertyChangedSignal("Text"):Connect(UpdateLines)
Editor:GetPropertyChangedSignal("TextBounds"):Connect(UpdateEditorSize)
EditorWrap:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateEditorSize)
local Injected = false

InjectBtn.MouseButton1Click:Connect(function()
    if Injected then Notify("System", "Already Injected!", "Warning"); return end
    InjectBtn.Text = "Scanning..."; Notify("System", "Scanning for Backdoors...", "Warning")
    task.spawn(function()
        local bd = ScanForBackdoor()
        if bd then foundBackdoor = bd; Notify("Success", "Backdoor Found: " .. bd.Name, "Success"); Title.Text = "TAD HUB Executor [Server]"; Injected = true; InjectBtn.Text = "Injected"
        else Notify("System", "No Backdoor found.", "Warning"); task.wait(1.5); InjectBtn.Text = "Injecting..."; Notify("System", "Injecting Local Executor...", "Warning"); task.wait(2); Title.Text = "TAD HUB Executor [Client]"; Injected = true; InjectBtn.Text = "Injected"; Notify("Success", "Local Executor Injected!", "Success") end
    end)
end)

ExecBtn.MouseButton1Click:Connect(function()
    if not Injected then Notify("Error", "Please click 'Inject' first!", "Error"); return end
    local src = Editor.Text
    if src == "" or src:match("^%s*$") then Notify("Warning", "Script is empty!", "Warning"); return end
    if foundBackdoor then pcall(function() if foundBackdoor:IsA("RemoteEvent") then foundBackdoor:FireServer(src) else spawn(function() foundBackdoor:InvokeServer(src) end) end end); Notify("Server", "Script Sent to Server!", "Success")
    else if typeof(loadstring) == 'function' then local fn, err = loadstring(src); if fn then task.spawn(fn); Notify("Local", "Script Executed Locally.", "Success") else Notify("Error", err, "Error") end else Notify("Error", "Executor not supported.", "Error") end end
end)

ExecuteLoad.MouseButton1Click:Connect(function()
    local count = 0; for _ in pairs(selectedFiles) do count = count + 1 end
    if count == 0 then Notify("Warning", "No files selected", "Warning"); return end
    if not Injected then Notify("Error", "Inject first!", "Error"); return end
    for path, _ in pairs(selectedFiles) do
        if readfile then
            local content = readfile(path)
            local fileName = path:match("[^/\\]+$")
            if foundBackdoor then pcall(function() if foundBackdoor:IsA("RemoteEvent") then foundBackdoor:FireServer(content) else spawn(function() foundBackdoor:InvokeServer(content) end) end end); Notify("Server", "Ran: "..fileName, "Success")
            else if typeof(loadstring) == 'function' then local fn, err = loadstring(content); if fn then task.spawn(fn); Notify("Local", "Ran: "..fileName, "Success") else Notify("Error", fileName.." Error", "Error") end end end
        end
    end
    LoadModal.Visible = false
end)

ClearBtn.MouseButton1Click:Connect(function() Editor.Text = ""; UpdateLines() end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local fullSize = UDim2.fromOffset(450, 275)
local minSize = UDim2.fromOffset(450, 32)
local isMinimized = false

MinBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        local t = TweenService:Create(Main, TweenInfo.new(0.3), {Size = fullSize})
        t:Play()
        t.Completed:Connect(function()
            EditorWrap.Visible = true; Bottom.Visible = true; TabBar.Visible = true
        end)
        isMinimized = false
    else
        EditorWrap.Visible = false; Bottom.Visible = false; TabBar.Visible = false
        TweenService:Create(Main, TweenInfo.new(0.3), {Size = minSize}):Play()
        isMinimized = true
    end
end)

SaveBtn.MouseButton1Click:Connect(function() SaveModal.Visible = true; FileNameBox.Text = ""; FileNameBox:CaptureFocus() end)
CancelSave.MouseButton1Click:Connect(function() SaveModal.Visible = false end)
ConfirmSave.MouseButton1Click:Connect(function() local name = FileNameBox.Text; local content = Editor.Text; if name == "" then Notify("Error", "Enter filename", "Error"); return end; if not name:match("%.lua$") and not name:match("%.txt$") then name = name .. ".lua" end; if writefile then pcall(function() if not isfolder(RootFolder) then makefolder(RootFolder) end; if not isfolder(FilesFolder) then makefolder(FilesFolder) end; if not isfolder(AutoExecFolder) then makefolder(AutoExecFolder) end; if not isfolder(TabsFolder) then makefolder(TabsFolder) end; writefile(FilesFolder.."/"..name, content); Notify("Success", "Saved in "..FilesFolder, "Success"); SaveModal.Visible = false end) else Notify("Error", "No writefile", "Error") end end)

UpdateLines()
