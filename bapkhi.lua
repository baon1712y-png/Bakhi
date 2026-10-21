-- =========================================================================
-- 🌌 BÁ KHÍ SIÊU CẤP VŨ TRỤ - BẢN FULL TÍNH NĂNG
-- Tự viết lại từ đầu - Không phụ thuộc bên thứ 3
-- =========================================================================

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CONFIG = {
    HubName = "BÁ KHÍ VŨ TRỤ",
    Version = "v1.0.0",
    ThemeColor = Color3.fromRGB(0, 255, 255),
    ThemeColorDark = Color3.fromRGB(10, 15, 25),
}

local function New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do if k ~= "Parent" then inst[k] = v end end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end
local function Round(parent, px) return New("UICorner", { CornerRadius = UDim.new(0, px), Parent = parent }) end
local function Stroke(parent, color, thickness) return New("UIStroke", { Color = color, Thickness = thickness or 1, Parent = parent }) end
local function Label(props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.GothamMedium
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    return New("TextLabel", props)
end

local parentTarget = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")
for _, name in ipairs({ "VuTru_Menu" }) do
    local old = parentTarget:FindFirstChild(name)
    if old then old:Destroy() end
end

local ScreenGui = New("ScreenGui", {
    Name = "VuTru_Menu", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 2147483647,
})
pcall(function() ScreenGui.Parent = parentTarget end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = New("Frame", {
    Name = "MainFrame", AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 300, 0, 250), Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = CONFIG.ThemeColorDark, BorderSizePixel = 0,
    ClipsDescendants = true, ZIndex = 30, Parent = ScreenGui,
})
Round(MainFrame, 12)

local MainStroke = New("UIStroke", { 
    Thickness = 2, 
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, 
    Color = CONFIG.ThemeColor, 
    Parent = MainFrame 
})

-- HEADER
local HeaderBar = New("Frame", { Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, ZIndex = 31, Parent = MainFrame })
Label({ Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), Text = "🌌 " .. CONFIG.HubName .. " " .. CONFIG.Version, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.GothamBlack, ZIndex = 32, Parent = HeaderBar })

local CloseBtn = New("TextButton", { Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -24, 0.5, -12), BackgroundColor3 = Color3.fromRGB(40, 12, 10), Text = "✕", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 32, Parent = HeaderBar })
Round(CloseBtn, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
-- ==================== CÁC NÚT BẤM TÍNH NĂNG ====================
local function CreateToggle(name, yPos, callback)
    local btn = New("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 35),
        Position = UDim2.new(0.05, 0, 0, yPos),
        BackgroundColor3 = Color3.fromRGB(25, 35, 50),
        Text = name .. " [ TẮT ]",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = MainFrame,
        ZIndex = 32
    })
    Round(btn, 6)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " [ BẬT ]" or " [ TẮT ]")
        btn.BackgroundColor3 = state and CONFIG.ThemeColor or Color3.fromRGB(25, 35, 50)
        btn.TextColor3 = state and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

local isAutoSteal = false
local isESP = false
local isSpeed = false

-- BẬT TÍNH NĂNG
CreateToggle("Tự Động Cướp Trứng", 50, function(state) isAutoSteal = state end)
CreateToggle("Xuyên Thấu (ESP)", 95, function(state) 
    isESP = state 
    if not state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Name == "VuTru_ESP" then obj:Destroy() end
        end
    end
end)
CreateToggle("Tốc Độ Ánh Sáng", 140, function(state) 
    isSpeed = state 
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = state and 200 or 16
    end
end)

local StatusLabel = Label({ Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 1, -30), Text = "Trạng thái: Sẵn sàng", TextColor3 = CONFIG.ThemeColor, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, Parent = MainFrame })

-- ==================== VÒNG LẶP XỬ LÝ ====================
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.2)
        local char = LocalPlayer.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then continue end

        if isSpeed then hum.WalkSpeed = 200 else hum.WalkSpeed = 16 end

        if isAutoSteal then
            StatusLabel.Text = "Trạng thái: Đang tìm trứng..."
            local closestEgg, minDist = nil, 150
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                    local dist = (obj.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        closestEgg = obj
                        minDist = dist
                    end
                end
            end
            if closestEgg then
                hrp.CFrame = closestEgg.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.05)
                local click = closestEgg:FindFirstChildOfClass("ClickDetector")
                if click then pcall(function() fireclickdetector(click) end) end
            end
        else
            StatusLabel.Text = "Trạng thái: Đang chờ lệnh..."
        end

        if isESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                    if not obj:FindFirstChild("VuTru_ESP") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "VuTru_ESP"
                        hl.FillColor = CONFIG.ThemeColor
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = obj
                    end
                end
            end
        end
    end
end)
-- ==================== KÉO THẢ MENU ====================
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== HIỆU ỨNG XUẤT HIỆN ====================
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 250)
}):Play()

print("[Bá Khí Vũ Trụ] Đã khởi chạy thành công! Bản quyền thuộc về mày.")
