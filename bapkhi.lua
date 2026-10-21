-- =========================================================================
-- 🔥 BÁ KHÍ SIÊU CẤP — ALL IN ONE
-- Loader + Chilli Hub V6 (đã đổi tên)
-- =========================================================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    ScriptURL = "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua",
    AuthorName = "Bá Khí",
    HubName = "BÁ KHÍ",
    Version = "v1.0.0",
    AutoHideDelay = 0.8,
    GameLoadTimeout = 10,
    ThemeColor = Color3.fromRGB(255, 69, 0),
    ThemeColorDark = Color3.fromRGB(18, 6, 8),
    LogoEmoji = "🔥",
}

local UPDATES = {
    { Icon = "🔥", Title = "Auto Farm Siêu Tốc", Color = Color3.fromRGB(255, 69, 0) },
    { Icon = "💀", Title = "ESP Bá Khí",           Color = Color3.fromRGB(239, 68, 68) },
    { Icon = "⚡", Title = "Speed Không Giới Hạn", Color = Color3.fromRGB(251, 191, 36) },
    { Icon = "🎯", Title = "Aim Thần Thánh",       Color = Color3.fromRGB(168, 85, 247) },
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

local function HasGameHttpGet()
    local ok, fn = pcall(function() return game.HttpGet end)
    return ok and fn ~= nil
end
local function GetRequestFunction()
    local fn = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    if type(fn) == "function" then return fn end
    return nil
end
local function Has(str, ...)
    for _, needle in ipairs({ ... }) do if str:find(needle, 1, true) then return true end end
    return false
end
local STAGE_NAME = { env = "Executor", http = "Tải script", compile = "Biên dịch", runtime = "Chạy" }
local function Err(stage, title, hint, raw) return { stage = stage, title = title, hint = hint, raw = tostring(raw or "") } end

local function ClassifyHttp(raw)
    local low = tostring(raw):lower()
    if Has(low, "404", "not found") then return Err("http", "Không tìm thấy script (404)", "Link chết.", raw)
    elseif Has(low, "403", "forbidden") then return Err("http", "Bị chặn (403)", "Thử VPN.", raw)
    elseif Has(low, "429", "too many") then return Err("http", "Quá tải (429)", "Đợi 1-2 phút.", raw)
    elseif Has(low, "timed out", "timeout") then return Err("http", "Timeout", "Mạng chậm.", raw)
    elseif Has(low, "ssl", "certificate", "tls") then return Err("http", "Lỗi SSL", "Đổi executor.", raw)
    elseif Has(low, "trust", "not allowed", "blocked", "permission") then return Err("http", "Executor chặn", "Đổi executor.", raw)
    elseif Has(low, "resolve", "dns", "connect", "network") then return Err("http", "Không có mạng", "Kiểm tra Wi-Fi.", raw) end
    return Err("http", "Tải thất bại", "Copy chi tiết báo tác giả.", raw)
end

local function ClassifyCompile(raw)
    local low = tostring(raw):lower()
    if Has(low, "unexpected symbol", "expected", "malformed", "unfinished", "near") then
        return Err("compile", "Cú pháp không hỗ trợ", "Executor chưa hỗ trợ Luau.", raw)
    end
    return Err("compile", "Không biên dịch được", "File lỗi.", raw)
end

local function ClassifyRuntime(raw)
    raw = tostring(raw)
    local low = raw:lower()
    local _, fname = raw:match("attempt to call a nil value %((%a+) '([^']+)'%)")
    if fname then return Err("runtime", "Thiếu hàm: " .. fname, "Executor không có.", raw)
    elseif Has(low, "not a valid member") then return Err("runtime", "Thiếu thành phần game", "Vào lại game.", raw)
    elseif Has(low, "lacking capability", "access denied") then return Err("runtime", "Thiếu quyền", "Executor mạnh hơn.", raw)
    elseif Has(low, "attempt to index nil") then return Err("runtime", "Lỗi dữ liệu", "Chờ game load.", raw) end
    return Err("runtime", "Script lỗi", "Copy chi tiết.", raw)
end

local function Preflight()
    if type(loadstring) ~= "function" then return Err("env", "Thiếu loadstring", "Đổi executor.", "nil") end
    if not HasGameHttpGet() and not GetRequestFunction() then return Err("env", "Thiếu HTTP", "Đổi executor.", "nil") end
    return nil
end

local function LoadMainScript()
    local pre = Preflight()
    if pre then return false, pre end
    local body, rawErr
    if HasGameHttpGet() then
        local ok, res = pcall(function() return game:HttpGet(CONFIG.ScriptURL) end)
        if ok then body = res else rawErr = tostring(res) end
    end
    if body == nil then
        local req = GetRequestFunction()
        if req then
            local ok, res = pcall(req, { Url = CONFIG.ScriptURL, Method = "GET" })
            if ok and type(res) == "table" then
                local status = tonumber(res.StatusCode or res.Status)
                if res.Success == false or (status and status >= 400) then
                    local e = "HTTP " .. tostring(status) .. " " .. tostring(res.StatusMessage or "")
                    rawErr = rawErr and (rawErr .. " | " .. e) or e
                else body = res.Body end
            elseif not ok then
                local e = tostring(res)
                rawErr = rawErr and (rawErr .. " | " .. e) or e
            end
        end
    end
    if body == nil then return false, ClassifyHttp(rawErr or "unknown") end
    if type(body) ~= "string" or body:match("^%s*$") then return false, Err("http", "Rỗng", "File trống.", "empty") end
    if body:match("^%s*<!DOCTYPE") or body:match("^%s*<[Hh][Tt][Mm][Ll]") then
        return false, Err("http", "Nhận HTML", "Mạng chặn.", body:sub(1, 120))
    end
    local fn, compileErr = loadstring(body)
    if not fn then return false, ClassifyCompile(compileErr) end
    local t0 = os.clock()
    while not game:IsLoaded() and os.clock() - t0 < CONFIG.GameLoadTimeout do task.wait(0.2) end
    local state = { done = false, err = nil }
    task.spawn(function()
        local ok, runErr = pcall(fn)
        state.done = true
        if not ok then state.err = runErr warn("[Bá Khí] Script lỗi: " .. tostring(runErr)) end
    end)
    local t1 = os.clock()
    while os.clock() - t1 < 1.5 and not state.done do task.wait(0.1) end
    if state.done and state.err then return false, ClassifyRuntime(state.err) end
    return true
end

local function BuildReport(e)
    return table.concat({
        "[Bá Khí " .. CONFIG.Version .. "]", "Executor: " .. EXECUTOR,
        "Bước: " .. (STAGE_NAME[e.stage] or e.stage), "Lỗi: " .. e.title,
        "Chi tiết: " .. e.raw, "URL: " .. CONFIG.ScriptURL,
    }, "\n")
end

local BASE_W = 340
local UPDATE_Y = 146
local UPDATE_H = 78
local authorY = UPDATE_Y + UPDATE_H + 8
local buttonY = authorY + 55
local belowY = buttonY + 57
local NORMAL_H = belowY + 28

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
Round(MainFrame, 16)
local MainScale = New("UIScale", { Scale = 0.5, Parent = MainFrame })
local MainStroke = New("UIStroke", { Thickness = 1.6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = CONFIG.ThemeColor, Parent = MainFrame })

local connections = {}
local function Track(conn) table.insert(connections, conn) return conn end
Track(RunService.RenderStepped:Connect(function()
    local val = (math.sin(tick() * 2.5) + 1) / 2
    local c = CONFIG.ThemeColor
    MainStroke.Color = Color3.new(math.clamp(c.R*0.85+val*0.15,0,1), math.clamp(c.G*0.85+val*0.15,0,1), math.clamp(c.B*0.85+val*0.15,0,1))
end))

local HeaderBar = New("Frame", { Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame })
local MiniLogo = New("Frame", { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 0, 0.5, -11), BackgroundColor3 = Color3.fromRGB(45, 15, 10), ZIndex = 32, Parent = HeaderBar })
Circle(MiniLogo)
Stroke(MiniLogo, CONFIG.ThemeColor)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = CONFIG.LogoEmoji, TextSize = 11, TextXAlignment = CENTER, ZIndex = 33, Parent = MiniLogo })
Label({ Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 28, 0, 0), Text = "BÁ KHÍ " .. CONFIG.Version, TextColor3 = Color3.fromRGB(255, 230, 220), TextSize = 10.5, Font = Enum.Font.GothamBold, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeaderBar })
local CloseBtn = New("TextButton", { Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -22, 0.5, -11), BackgroundColor3 = Color3.fromRGB(40, 12, 10), Text = "✕", TextColor3 = Color3.fromRGB(252, 165, 165), TextSize = 10, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 32, Parent = HeaderBar })
Round(CloseBtn, 6)

local HeroSection = New("Frame", { Size = UDim2.new(1, -28, 0, 78), Position = UDim2.new(0, 14, 0, 44), BackgroundColor3 = Color3.fromRGB(32, 10, 8), ZIndex = 31, Parent = MainFrame })
Round(HeroSection, 12)
Stroke(HeroSection, Color3.fromRGB(90, 30, 20))
local CenterLogoBox = New("Frame", { Size = UDim2.new(0, 54, 0, 54), Position = UDim2.new(0, 12, 0.5, -27), BackgroundColor3 = Color3.fromRGB(40, 12, 8), ZIndex = 32, Parent = HeroSection })
Round(CenterLogoBox, 14)
Stroke(CenterLogoBox, CONFIG.ThemeColor, 1.5)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = CONFIG.LogoEmoji, TextSize = 26, TextXAlignment = CENTER, ZIndex = 33, Parent = CenterLogoBox })
Label({ Size = UDim2.new(1, -80, 0, 20), Position = UDim2.new(0, 74, 0, 18), Text = "BÁ KHÍ SIÊU CẤP", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBlack, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection })
Label({ Size = UDim2.new(1, -80, 0, 16), Position = UDim2.new(0, 74, 0, 40), Text = "Bá khí · Siêu cấp · Vô đối", TextColor3 = CONFIG.ThemeColor, TextSize = 10, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 32, Parent = HeroSection })

Label({ Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, 128), Text = "🔥 TÍNH NĂNG BÁ KHÍ", TextColor3 = CONFIG.ThemeColor, TextSize = 10, Font = Enum.Font.GothamBold, ZIndex = 32, Parent = MainFrame })
local UpdateRow = New("Frame", { Size = UDim2.new(1, -28, 0, UPDATE_H), Position = UDim2.new(0, 14, 0, UPDATE_Y), BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame })
New("UIGridLayout", { CellSize = UDim2.new(0, 145, 0, 36), CellPadding = UDim2.new(0, 8, 0, 6), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = UpdateRow })
for i, upd in ipairs(UPDATES) do
    local badge = New("Frame", { BackgroundColor3 = Color3.fromRGB(40, 14, 10), LayoutOrder = i, ZIndex = 33, Parent = UpdateRow })
    Round(badge, 9)
    Stroke(badge, upd.Color, 1.2)
    Label({ Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 5, 0.5, -13), Text = upd.Icon, TextSize = 16, TextXAlignment = CENTER, ZIndex = 34, Parent = badge })
    Label({ Size = UDim2.new(1, -36, 1, -4), Position = UDim2.new(0, 33, 0, 2), Text = upd.Title, TextColor3 = upd.Color, TextSize = 9.5, Font = Enum.Font.GothamBold, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 34, Parent = badge })
end

local AuthorCard = New("Frame", { Size = UDim2.new(1, -28, 0, 40), Position = UDim2.new(0, 14, 0, authorY), BackgroundColor3 = Color3.fromRGB(32, 10, 8), ZIndex = 31, Parent = MainFrame })
Round(AuthorCard, 10)
Stroke(AuthorCard, Color3.fromRGB(90, 30, 20))
local AvatarCircle = New("Frame", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 6, 0.5, -14), BackgroundColor3 = Color3.fromRGB(55, 15, 10), ZIndex = 32, Parent = AuthorCard })
Circle(AvatarCircle)
Stroke(AvatarCircle, CONFIG.ThemeColor)
Label({ Size = UDim2.new(1, 0, 1, 0), Text = "🔥", TextSize = 13, TextXAlignment = CENTER, TextColor3 = Color3.fromRGB(252, 165, 165), ZIndex = 33, Parent = AvatarCircle })
Label({ Size = UDim2.new(1, -48, 0, 14), Position = UDim2.new(0, 42, 0, 6), Text = CONFIG.AuthorName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 11, Font = Enum.Font.GothamBold, ZIndex = 33, Parent = AuthorCard })
Label({ Size = UDim2.new(1, -48, 0, 12), Position = UDim2.new(0, 42, 0, 21), Text = "Tác giả · " .. CONFIG.Version, TextColor3 = Color3.fromRGB(160, 160, 160), TextSize = 9, ZIndex = 33, Parent = AuthorCard })

local DownloadBtn = New("TextButton", { Size = UDim2.new(1, -28, 0, 44), Position = UDim2.new(0, 14, 0, buttonY), BackgroundColor3 = CONFIG.ThemeColor, Text = "🚀 KÍCH HOẠT BÁ KHÍ", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 32, Parent = MainFrame })
Round(DownloadBtn, 10)

local StatusLabel = Label({ Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, belowY + 4), Text = "Sẵn sàng. Bấm nút để kích hoạt.", TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 9.5, TextXAlignment = CENTER, TextWrapped = true, ZIndex = 32, Parent = MainFrame })

local loading = false
DownloadBtn.MouseButton1Click:Connect(function()
    if loading then return end
    loading = true
    DownloadBtn.Text = "⏳ Đang kích hoạt..."
    DownloadBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    StatusLabel.Text = "Đang kết nối tới server..."
    task.spawn(function()
        local ok, err = LoadMainScript()
        if ok then
            StatusLabel.Text = "✅ Bá khí đã kích hoạt!"
            StatusLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
            task.wait(CONFIG.AutoHideDelay)
            for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
            ScreenGui:Destroy()
        else
            StatusLabel.Text = "❌ " .. err.title
            StatusLabel.TextColor3 = Color3.fromRGB(252, 165, 165)
            DownloadBtn.Text = "🔄 THỬ LẠI"
            DownloadBtn.BackgroundColor3 = CONFIG.ThemeColor
            loading = false
            print(BuildReport(err))
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
TweenService:Create(MainScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = GetResponsiveScale() }):Play()

print("[Bá Khí] Loader đã chạy. Executor: " .. EXECUTOR)
