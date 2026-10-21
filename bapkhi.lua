-- =========================================================================
-- 🌌 BÁ KHÍ HUB - CYBERPUNK EDITION (BẢN FULL ALL-IN-ONE OFFLINE)
-- =========================================================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    AuthorName = "Bá Khí Team",
    HubName = "BÁ KHÍ",
    Version = "v4.0.0",
    AutoHideDelay = 0.8,
    ThemeColor = Color3.fromRGB(168, 85, 247),
    ThemeColorDark = Color3.fromRGB(15, 10, 25),
    ThemeColorLight = Color3.fromRGB(230, 200, 255),
    LogoEmoji = "🌌",
}

local UPDATES = {
    { Icon = "🚀", Title = "Auto Farm Bá Đạo", Color = Color3.fromRGB(168, 85, 247) },
    { Icon = "👁️", Title = "ESP Xuyên Thấu",   Color = Color3.fromRGB(236, 72, 153) },
    { Icon = "⚡", Title = "Tốc Độ Ánh Sáng",  Color = Color3.fromRGB(59, 130, 246) },
    { Icon = "🛡️", Title = "Bypass Mọi Loại",  Color = Color3.fromRGB(16, 185, 129) },
}

local function New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do if k ~= "Parent" then inst[k] = v end end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end
local function Round(parent, px) return New("UICorner", { CornerRadius = UDim.new(0, px), Parent = parent }) end
local function Circle(parent) return New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent }) end
local function Stroke(parent, color, thickness) return New("UIStroke", { Color = color, Thickness = thickness or 1, Parent = parent }) end
local function Label(props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.GothamMedium
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    return New("TextLabel", props)
end
local CENTER = Enum.TextXAlignment.Center

local function GetExecutorName()
    local ok, name, ver = pcall(function() if identifyexecutor then return identifyexecutor() end end)
    if ok and name then return tostring(name) .. (ver and (" " .. tostring(ver)) or "") end
    return "Không rõ"
end
local EXECUTOR = GetExecutorName()

local BASE_W = 320
local UPDATE_Y = 140
local UPDATE_H = 80
local authorY = UPDATE_Y + UPDATE_H + 10
local buttonY = authorY + 50
local belowY = buttonY + 55
local NORMAL_H = belowY + 30

local function GetResponsiveScale()
    local camera = workspace.CurrentCamera
    if not camera then return 0.7 end
    local vp = camera.ViewportSize
    local pad = 40
    return math.clamp(math.min((vp.X - pad) / BASE_W, (vp.Y - pad) / NORMAL_H), 0.5, 1.0)
end

local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
for _, name in ipairs({ "BaKhi_Menu", "BaKhi_Toast" }) do
    local old = parentTarget:FindFirstChild(name)
    if old then old:Destroy() end
end

local ScreenGui = New("ScreenGui", {
    Name = "BaKhi_Menu", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 2147483647,
})
pcall(function() ScreenGui.Parent = parentTarget end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = New("Frame", {
    Name = "MainFrame", AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, BASE_W, 0, NORMAL_H), Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = CONFIG.ThemeColorDark, BorderSizePixel = 0,
    ClipsDescendants = true, ZIndex = 30, Parent = ScreenGui,
})
Round(MainFrame, 20)
local MainScale = New("UIScale", { Scale = 0.5, Parent = MainFrame })

local MainStroke = New("UIStroke", { 
    Thickness = 2, 
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
    Color = CONFIG.ThemeColor, 
    Parent = MainFrame 
})

local BgGrad = New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 15))
    }),
    Rotation = 45,
    Parent = MainFrame
})

local connections = {}
local function Track(conn) table.insert(connections, conn) return conn end

Track(RunService.RenderStepped:Connect(function()
    local val = (math.sin(tick() * 3) + 1) / 2
    MainStroke.Color = CONFIG.ThemeColor:Lerp(Color3.fromRGB(255, 255, 255), val * 0.3)
    MainStroke.Transparency = 0.2 + (val * 0.3)
end))

local HeaderBar = New("Frame", { Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame })
local MiniLogo = New("Frame", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 0, 0.5, -12), BackgroundColor3 = CONFIG.ThemeColor, ZIndex = 32, Parent = HeaderBar })
Circle(MiniLogo)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = CONFIG.LogoEmoji, TextSize = 12, TextXAlignment = CENTER, ZIndex = 33, Parent = MiniLogo })
Label({ Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 32, 0, 0), Text = "BÁ KHÍ CYBER " .. CONFIG.Version, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBlack, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeaderBar })

local CloseBtn = New("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -24, 0.5, -12), BackgroundColor3 = Color3.fromRGB(40, 12, 10), Text = "✕", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 32, Parent = HeaderBar })
Circle(CloseBtn)

local HeroSection = New("Frame", { Size = UDim2.new(1, -28, 0, 80), Position = UDim2.new(0, 14, 0, 45), BackgroundColor3 = Color3.fromRGB(25, 10, 35), ZIndex = 31, Parent = MainFrame })
Round(HeroSection, 14)
Stroke(HeroSection, Color3.fromRGB(80, 40, 100), 1.5)

local CenterLogoBox = New("Frame", { Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0, 12, 0.5, -28), BackgroundColor3 = Color3.fromRGB(40, 20, 60), ZIndex = 32, Parent = HeroSection })
Round(CenterLogoBox, 16)
Stroke(CenterLogoBox, CONFIG.ThemeColor, 2)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = CONFIG.LogoEmoji, TextSize = 28, TextXAlignment = CENTER, ZIndex = 33, Parent = CenterLogoBox })

Label({ Size = UDim2.new(1, -85, 0, 22), Position = UDim2.new(0, 78, 0, 16), Text = "BÁ KHÍ SIÊU CẤP", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.GothamBlack, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection })
Label({ Size = UDim2.new(1, -85, 0, 16), Position = UDim2.new(0, 78, 0, 42), Text = "Phiên bản Offline 4.0", TextColor3 = CONFIG.ThemeColorLight, TextSize = 10, Font = Enum.Font.GothamMedium, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection })

Label({ Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, 130), Text = "✨ TÍNH NĂNG NỔI BẬT", TextColor3 = CONFIG.ThemeColorLight, TextSize = 10, Font = Enum.Font.GothamBold, ZIndex = 32, Parent = MainFrame })
local UpdateRow = New("Frame", { Size = UDim2.new(1, -28, 0, UPDATE_H), Position = UDim2.new(0, 14, 0, UPDATE_Y), BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame })
New("UIGridLayout", { CellSize = UDim2.new(0, 140, 0, 36), CellPadding = UDim2.new(0, 8, 0, 8), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = UpdateRow })

for i, upd in ipairs(UPDATES) do
    local badge = New("Frame", { BackgroundColor3 = Color3.fromRGB(35, 15, 50), LayoutOrder = i, ZIndex = 33, Parent = UpdateRow })
    Round(badge, 10)
    Stroke(badge, upd.Color, 1.5)
    Label({ Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 5, 0.5, -13), Text = upd.Icon, TextSize = 16, TextXAlignment = CENTER, ZIndex = 34, Parent = badge })
    Label({ Size = UDim2.new(1, -36, 1, -4), Position = UDim2.new(0, 33, 0, 2), Text = upd.Title, TextColor3 = upd.Color, TextSize = 9.5, Font = Enum.Font.GothamBold, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 34, Parent = badge })
end

local AuthorCard = New("Frame", { Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0, 14, 0, authorY), BackgroundColor3 = Color3.fromRGB(35, 15, 50), ZIndex = 31, Parent = MainFrame })
Round(AuthorCard, 10)
Stroke(AuthorCard, Color3.fromRGB(80, 40, 100), 1)
local AvatarCircle = New("Frame", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 6, 0.5, -14), BackgroundColor3 = CONFIG.ThemeColor, ZIndex = 32, Parent = AuthorCard })
Circle(AvatarCircle)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = "👑", TextSize = 14, TextXAlignment = CENTER, ZIndex = 33, Parent = AvatarCircle })
Label({ Size = UDim2.new(1, -48, 0, 14), Position = UDim2.new(0, 42, 0, 6), Text = CONFIG.AuthorName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 11, Font = Enum.Font.GothamBold, ZIndex = 33, Parent = AuthorCard })
Label({ Size = UDim2.new(1, -48, 0, 12), Position = UDim2.new(0, 42, 0, 21), Text = "Tác giả · " .. CONFIG.Version, TextColor3 = Color3.fromRGB(180, 150, 200), TextSize = 9, ZIndex = 33, Parent = AuthorCard })

local DownloadBtn = New("TextButton", { 
    Size = UDim2.new(1, -28, 0, 46), 
    Position = UDim2.new(0, 14, 0, buttonY), 
    BackgroundColor3 = CONFIG.ThemeColor, 
    Text = "🚀 KÍCH HOẠT BÁ KHÍ", 
    TextColor3 = Color3.fromRGB(255, 255, 255), 
    TextSize = 14, 
    Font = Enum.Font.GothamBlack, 
    AutoButtonColor = false, 
    ZIndex = 32, 
    Parent = MainFrame 
})
Round(DownloadBtn, 12)

local BtnGrad = New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
    }),
    Rotation = 0,
    Parent = DownloadBtn
})
local BtnScale = New("UIScale", { Scale = 1, Parent = DownloadBtn })

DownloadBtn.MouseEnter:Connect(function()
    TweenService:Create(BtnScale, TweenInfo.new(0.1), {Scale = 1.05}):Play()
end)
DownloadBtn.MouseLeave:Connect(function()
    TweenService:Create(BtnScale, TweenInfo.new(0.1), {Scale = 1}):Play()
end)

local StatusLabel = Label({ Size = UDim2.new(1, -28, 0, 16), Position = UDim2.new(0, 14, 0, belowY + 4), Text = "Sẵn sàng. Bấm nút để kích hoạt.", TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 10, TextXAlignment = CENTER, TextWrapped = true, ZIndex = 32, Parent = MainFrame })

local loading = false
DownloadBtn.MouseButton1Click:Connect(function()
    if loading then return end
    loading = true
    DownloadBtn.Text = "⏳ ĐANG KÍCH HOẠT..."
    DownloadBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    StatusLabel.Text = "Đang nạp Bá Khí Hub (Offline)..."
    
    task.spawn(function()
        task.wait(0.5)
        
        local success, err = pcall(function()
            -- TẢI TRỰC TIẾP TỪ FILE MAIN TRÊN GITHUB CỦA MÀY
            local mainCode = game:HttpGet("https://raw.githubusercontent.com/baon1712y-png/Bakhi/main/bakhi_main.lua")
            
            -- Xóa sạch chữ Chilli/Venyx
            mainCode = mainCode:gsub("Chilli", "Bá Khí")
            mainCode = mainCode:gsub("Venyx", "Bá Khí Lite")
            mainCode = mainCode:gsub("chilli", "bá khí")
            
            local fn = loadstring(mainCode)
            if fn then fn() end
        end)

        if success then
            StatusLabel.Text = "✅ KÍCH HOẠT THÀNH CÔNG!"
            StatusLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
            DownloadBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            
            -- Tự động ép xung tốc độ bay (Mức an toàn 150)
            task.delay(2, function()
                pcall(function()
                    if getgenv().ChilliConfig and getgenv().ChilliConfig.States then
                        getgenv().ChilliConfig.States["Farm > Auto Steal > Tween Speed"] = {Value = 150, Type = "slider"}
                        getgenv().ChilliConfig.States["Farm > Auto Steal > Carry Speed"] = {Value = 150, Type = "slider"}
                    end
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 200
                    end
                end)
            end)

            task.wait(CONFIG.AutoHideDelay + 0.5)
            for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
            ScreenGui:Destroy()
        else
            StatusLabel.Text = "❌ LỖI TẢI SCRIPT CHÍNH!"
            StatusLabel.TextColor3 = Color3.fromRGB(252, 165, 165)
            DownloadBtn.Text = "🔄 THỬ LẠI"
            DownloadBtn.BackgroundColor3 = CONFIG.ThemeColor
            loading = false
            warn("[Bá Khí] Lỗi: " .. tostring(err))
        end
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    ScreenGui:Destroy()
end)

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.3)
        MainScale.Scale = GetResponsiveScale()
    end
end)

MainScale.Scale = 0.5
TweenService:Create(MainScale, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = GetResponsiveScale() }):Play()

print("[Bá Khí Cyberpunk] Loader đã chạy. Executor: " .. EXECUTOR)
