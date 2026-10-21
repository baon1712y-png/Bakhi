local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BaKhi_Loader"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MainFrame.Parent = ScreenGui
local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(168, 85, 247)
stroke.Thickness = 2

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "BÁ KHÍ CYBER - LOADER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.Parent = MainFrame

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0, 200, 0, 45)
Btn.Position = UDim2.new(0.5, 0, 0.5, 0)
Btn.AnchorPoint = Vector2.new(0.5, 0.5)
Btn.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
Btn.Text = "🚀 KÍCH HOẠT BÁ KHÍ"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 14
Btn.Parent = MainFrame
local btnCorner = Instance.new("UICorner", Btn)
btnCorner.CornerRadius = UDim.new(0, 8)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 1, -30)
Status.BackgroundTransparency = 1
Status.Text = "Nhấn nút để bắt đầu..."
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Font = Enum.Font.Gotham
Status.TextSize = 11
Status.Parent = MainFrame

Btn.MouseButton1Click:Connect(function()
    Btn.Text = "⏳ ĐANG TẢI..."
    Status.Text = "Đang kết nối..."
    task.spawn(function()
        local ok, err = pcall(function()
            -- Tự động tải script chính từ link gốc của tác giả qua CDN
            local url = "https://cdn.jsdelivr.net/gh/tienkhanh1/spicy@main/Chilli.lua"
            local code = game:HttpGet(url)
            code = code:gsub("Chilli", "Bá Khí")
            code = code:gsub("chilli", "bá khí")
            local fn = loadstring(code)
            if fn then fn() end
        end)
        
        if ok then
            Status.Text = "✅ THÀNH CÔNG!"
            task.wait(0.5)
            ScreenGui:Destroy()
        else
            Status.Text = "❌ LỖI MẠNG, THỬ LẠI!"
            Btn.Text = "🔄 THỬ LẠI"
            warn("Lỗi: " .. tostring(err))
        end
    end)
end)
