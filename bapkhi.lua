-- ========================================================================
-- 🌌 BÁ KHÍ HUB - CYBERPUNK EDITION (BẢN AUTO-DOWNLOAD)
-- ========================================================================

local TweenService = game:GetService("TweenService")
RunService cục bộ = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Cấu hình cục bộ = {
    ScriptURL = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
    Tên tác giả = "Nhóm Bát Khí",
    HubName = "BÁ KHÍ",
    Phiên bản = "v5.0.0",
    AutoHideDelay = 0.8,
    ThemeColor = Color3.fromRGB(168, 85, 247),
    ThemeColorDark = Color3.fromRGB(15, 10, 25),
    ThemeColorLight = Color3.fromRGB(230, 200, 255),
    LogoEmoji = "🌌",
}

CẬP NHẬT cục bộ = {
    { Icon = "🚀", Title = "Auto Farm Bá Đạo", Color = Color3.fromRGB(168, 85, 247) },
    { Icon = "👁️", Title = "ESP Xuyên Thấu", Color = Color3.fromRGB(236, 72, 153) },
    { Icon = "⚡", Title = "Tốc Độ Ánh Sáng", Color = Color3.fromRGB(59, 130, 246) },
    { Icon = "🛡️", Title = "Bypass Mọi Loại", Color = Color3.fromRGB(16, 185, 129) },
}

hàm cục bộ New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do if k ~= "Parent" then inst[k] = v end end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    trả lại inst
kết thúc
local function Round(parent, px) return New("UICorner", { CornerRadius = UDim.new(0, px), Parent = parent }) end
local function Circle(parent) return New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = parent }) end
local function Stroke(parent, color, thickness) return New("UIStroke", { Color = color, Thickness = thickness or 1, Parent = parent }) end
hàm cục bộ Label(props)
    props.BackgroundTransparency = 1
    props.Font = props.Font hoặc Enum.Font.GothamMedium
    props.TextXAlignment = props.TextXAlignment hoặc Enum.TextXAlignment.Left
    return New("TextLabel", props)
kết thúc
local CENTER = Enum.TextXAlignment.Center

hàm cục bộ GetExecutorName()
    local ok, name, ver = pcall(function() if identifyexecutor then return identifyexecutor() end end)
    nếu ok và tên thì trả về tostring(name) .. (ver và (" " .. tostring(ver)) hoặc "") kết thúc
    trả về " . . "
kết thúc
local EXECUTOR = GetExecutorName()

local BASE_W = 320
cục bộ UPDATE_Y = 140
cục bộ UPDATE_H = 80
local authorY = UPDATE_Y + UPDATE_H + 10
local buttonY = authorY + 50
local belowY = buttonY + 55
cục bộ NORMAL_H = belowY + 30

hàm cục bộ GetResponsiveScale()
    camera cục bộ = workspace.CurrentCamera
    nếu không phải camera thì trả về 0.7.
    local vp = camera.ViewportSize
    đệm cục bộ = 40
    return math.clamp(math.min((vp.X - pad) / BASE_W, (vp.Y - pad) / NORMAL_H), 0.5, 1.0)
kết thúc

local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
for _, tên trong ipairs({ "BaKhi_Menu", "BaKhi_Toast" }) do
    cục bộ cũ = parentTarget:FindFirstChild(name)
    nếu cũ thì hủy bỏ cũ()
kết thúc

local ScreenGui = New("ScreenGui", {
    Name = "BaKhi_Menu", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 2147483647,
})
pcall(function() ScreenGui.Parent = parentTarget end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = New("Frame", {
    Tên = "MainFrame", Điểm neo = Vector2.new(0.5, 0.5),
    Kích thước = UDim2.new(0, BASE_W, 0, NORMAL_H), Vị trí = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = CONFIG.ThemeColorDark, BorderSizePixel = 0,
    ClipsDescendants = true, ZIndex = 30, Parent = ScreenGui,
})
Làm tròn(MainFrame, 20)
local MainScale = New("UIScale", { Scale = 0.5, Parent = MainFrame })

local MainStroke = New("UIStroke", {
    Độ dày = 2,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Màu sắc = CONFIG.ThemeColor,
    Cha = Máy chủ chính
})

local BgGrad = New("UIGradient", {
    Màu = Chuỗi màu.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 15))
    }),
    Góc quay = 45,
    Cha = Máy chủ chính
})

kết nối cục bộ = {}
local function Track(conn) table.insert(connections, conn) return conn end

Theo dõi (RunService.RenderStepped:Connect(function())
    local val = (math.sin(tick() * 3) + 1) / 2
    MainStroke.Color = CONFIG.ThemeColor:Lerp(Color3.fromRGB(255, 255, 255), val * 0.3)
    MainStroke.Transparency = 0.2 + (val * 0.3)
kết thúc))

local HeaderBar = New("Frame", { Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame })
local MiniLogo = New("Frame", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0, 0, 0.5, -12), BackgroundColor3 = CONFIG.ThemeColor, ZIndex = 32, Parent = HeaderBar })
Hình tròn (Logo nhỏ)
Nhãn({ Kích thước = UDim2.new(1, 0, 1, 0), Văn bản = CONFIG.LogoEmoji, Kích thước văn bản = 12, Căn chỉnh văn bản theo chiều ngang = TRUNG TÂM, Chỉ số Z = 33, Phần tử cha = MiniLogo })
Label({ Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 32, 0, 0), Text = "BÁ KHÍ CYBER " .. CONFIG.Version, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBlack, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeaderBar })

local CloseBtn = New("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -24, 0.5, -12), BackgroundColor3 = Color3.fromRGB(40, 12, 10), Text = "✕", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 32, Parent = HeaderBar })
Khoanh tròn (Nút Đóng)

local HeroSection = New("Frame", { Size = UDim2.new(1, -28, 0, 80), Position = UDim2.new(0, 14, 0, 45), BackgroundColor3 = Color3.fromRGB(25, 10, 35), ZIndex = 31, Parent = MainFrame })
Vòng (Phần Anh hùng, 14)
Stroke(HeroSection, Color3.fromRGB(80, 40, 100), 1.5)

local CenterLogoBox = New("Frame", { Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0, 12, 0.5, -28), BackgroundColor3 = Color3.fromRGB(40, 20, 60), ZIndex = 32, Parent = HeroSection })
Round(CenterLogoBox, 16)
Stroke(CenterLogoBox, CONFIG.ThemeColor, 2)
Nhãn({ Kích thước = UDim2.new(1, 0, 1, 0), Văn bản = CONFIG.LogoEmoji, Kích thước văn bản = 28, Căn chỉnh văn bản theo chiều ngang = TRUNG TÂM, Chỉ số Z = 33, Phần tử cha = CenterLogoBox })

Label({ Size = UDim2.new(1, -85, 0, 22), Position = UDim2.new(0, 78, 0, 16), Text = "BÁ KHÍ SIÊU CẤP", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.GothamBlack, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection })
Label({ Size = UDim2.new(1, -85, 0, 16), Position = UDim2.new(0, 78, 0, 42), Text = "Phiên bản Siêu Tốc 5.0", TextColor3 = CONFIG.ThemeColorLight, TextSize = 10, Font = Enum.Font.GothamMedium, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection })

Label({ Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, 130), Text = "✨ TÍNH NĂNG NỔI BẬT", TextColor3 = CONFIG.ThemeColorLight, TextSize = 10, Font = Enum.Font.GothamBold, ZIndex = 32, Parent = MainFrame })
local UpdateRow = New("Frame", { Size = UDim2.new(1, -28, 0, UPDATE_H), Position = UDim2.new(0, 14, 0, UPDATE_Y), BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame })
New("UIGridLayout", { CellSize = UDim2.new(0, 140, 0, 36), CellPadding = UDim2.new(0, 8, 0, 8), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = UpdateRow })

for i, upd in ipairs(UPDATES) do
    local badge = New("Frame", { BackgroundColor3 = Color3.fromRGB(35, 15, 50), LayoutOrder = i, ZIndex = 33, Parent = UpdateRow })
    Làm tròn (huy hiệu, 10)
    Stroke(badge, upd.Color, 1.5)
    Nhãn({ Kích thước = UDim2.new(0, 26, 0, 26), Vị trí = UDim2.new(0, 5, 0.5, -13), Văn bản = upd.Icon, Kích thước văn bản = 16, Căn chỉnh văn bản theo chiều ngang = TRUNG TÂM, Chỉ số Z = 34, Phần tử cha = huy hiệu })
    Label({ Size = UDim2.new(1, -36, 1, -4), Position = UDim2.new(0, 33, 0, 2), Text = upd.Title, TextColor3 = upd.Color, TextSize = 9.5, Font = Enum.Font.GothamBold, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 34, Parent = badge })
kết thúc

local AuthorCard = New("Frame", { Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0, 14, 0, authorY), BackgroundColor3 = Color3.fromRGB(35, 15, 50), ZIndex = 31, Parent = MainFrame })
Vòng (AuthorCard, 10)
Stroke(AuthorCard, Color3.fromRGB(80, 40, 100), 1)
local AvatarCircle = New("Frame", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 6, 0.5, -14), BackgroundColor3 = CONFIG.ThemeColor, ZIndex = 32, Parent = AuthorCard })
Circle(AvatarCircle)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = "👑", TextSize = 14, TextXAlignment = CENTER, ZIndex = 33, Parent = AvatarCircle })
Nhãn({ Kích thước = UDim2.new(1, -48, 0, 14), Vị trí = UDim2.new(0, 42, 0, 6), Văn bản = CONFIG.AuthorName, Màu văn bản 3 = Màu 3.fromRGB(255, 255, 255), Kích thước văn bản = 11, Phông chữ = Enum.Font.GothamBold, ZIndex = 33, Phần tử cha = AuthorCard })
Label({ Size = UDim2.new(1, -48, 0, 12), Position = UDim2.new(0, 42, 0, 21), Text = "Tác giả · " .. CONFIG.Version, TextColor3 = Color3.fromRGB(180, 150, 200), TextSize = 9, ZIndex = 33, Parent = AuthorCard })

local DownloadBtn = New("TextButton", {
    Kích thước = UDim2.new(1, -28, 0, 46),
    Vị trí = UDim2.new(0, 14, 0, buttonY),
    BackgroundColor3 = CONFIG.ThemeColor,
    Text = "🚀 KÍCH HOẠT BÁ KHÍ",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Kích thước chữ = 14,
    Phông chữ = Enum.Font.GothamBlack,
    AutoButtonColor = false,
    Chỉ số Z = 32,
    Cha = Máy chủ chính
})
Vòng (Nút Tải xuống, 12)

cục bộ BtnGrad = New("UIGradient", {
    Màu = Chuỗi màu.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 72, 153))
    }),
    Góc quay = 0,
    Cha = Nút Tải xuống
})
local BtnScale = New("UIScale", { Scale = 1, Parent = DownloadBtn })

DownloadBtn.MouseEnter:Connect(function()
    TweenService:Create(BtnScale, TweenInfo.new(0.1), {Scale = 1.05}):Play()
kết thúc)
DownloadBtn.MouseLeave:Connect(function()
    TweenService:Create(BtnScale, TweenInfo.new(0.1), {Scale = 1}):Play()
kết thúc)

local StatusLabel = Label({ Size = UDim2.new(1, -28, 0, 16), Position = UDim2.new(0, 14, 0, belowY + 4), Text = "Sột sàng. Bấm nút để kích hoạt.", TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 10, TextXAlignment = CENTER, TextWrapped = true, ZIndex = 32, Parent = MainFrame })

tải cục bộ = sai
DownloadBtn.MouseButton1Click:Connect(function()
    nếu đang tải thì trả về kết thúc
    đang tải = đúng
    DownloadBtn.Text = "⏳ ĐANG KÍCH HOẠT..."
    DownloadBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    StatusLabel.Text = "Tải dữ liệu và ép tốc độ..."
    
    task.spawn(function()
        thành công cục bộ, err = pcall(function()
            local mainCode = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")
            
            mainCode = mainCode:gsub("Ớt", "Bá Khí")
            mainCode = mainCode:gsub("Venyx", "Bá Khí Lite")
            mainCode = mainCode:gsub("ớt", "bá khí")
            
            fn cục bộ = chuỗi tải (mã chính)
            nếu fn thì fn() kết thúc
        kết thúc)

        nếu thành công thì
            StatusLabel.Text = " ✅ KÍCH HOẠT THÀNH CÔNG!"
            StatusLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
            DownloadBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
            
            task.delay(2, function()
                pcall(function()
                    nếu getgenv().ChilliConfig và getgenv().ChilliConfig.States thì
                        getgenv().ChilliConfig.States["Farm > Auto Steal > Tween Speed"] = {Value = 150, Type = "slider"}
                        getgenv().ChilliConfig.States["Farm > Auto Steal > Carry Speed"] = {Value = 150, Type = "slider"}
                    kết thúc
                    local char = LocalPlayer.Character
                    nếu char và char:FindFirstChildOfClass("Humanoid") thì
                        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 200
                    kết thúc
                kết thúc)
            kết thúc)

            task.wait(CONFIG.AutoHideDelay + 0.5)
            for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
            ScreenGui:Destroy()
        khác
            StatusLabel.Text = "❌ LỖI TẢI SCRIPT CHÍNH!"
            StatusLabel.TextColor3 = Color3.fromRGB(252, 165, 165)
            DownloadBtn.Text = "🔄THỬ LẠI"
            DownloadBtn.BackgroundColor3 = CONFIG.ThemeColor
            đang tải = sai
            Warn("[Bá Khí] Error: " .. tostring(err))
        kết thúc
    kết thúc)
kết thúc)

CloseBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    ScreenGui:Destroy()
kết thúc)

task.spawn(function()
    trong khi ScreenGui.Parent thực hiện
        task.wait(0.3)
        MainScale.Scale = GetResponsiveScale()
    kết thúc
kết thúc)

MainScale.Scale = 0.5
TweenService:Create(MainScale, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = GetResponsiveScale() }):Play()

print("[Bá Khí Cyberpunk] Loader đã chạy. Executor: " .. EXECUTOR)
