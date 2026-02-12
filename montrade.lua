local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- [[ 🧹 ล้างหน้าต่างเก่าก่อนสร้างใหม่ ]] --
if gethui then
    for _, child in pairs(gethui():GetChildren()) do
        if child.Name == "TradeMonsterGUI" then child:Destroy() end
    end
else
    if CoreGui:FindFirstChild("TradeMonsterGUI") then
        CoreGui.TradeMonsterGUI:Destroy()
    end
end

-- [[ 🛠️ ค้นหา Knit & Replica ]] --
local KnitPath = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit")
local Knit = require(KnitPath)
local ReplicaController = Knit.ReplicaController
local TradeController = Knit.GetController("TradeController")

if not ReplicaController then
    for k, v in pairs(Knit) do 
        if k == "ReplicaController" then ReplicaController = v end
        if k == "TradeController" then TradeController = v end
    end
end

-- [[ 🎨 สร้าง GUI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TradeMonsterGUI"
if gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- 1. ปุ่มเปิด (Mini Button)
local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
OpenButton.Position = UDim2.new(0, 10, 0.9, -10)
OpenButton.Size = UDim2.new(0, 100, 0, 35)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Text = "OPEN UI"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 12
OpenButton.Visible = false
local UICornerOpen = Instance.new("UICorner")
UICornerOpen.CornerRadius = UDim.new(0, 8)
UICornerOpen.Parent = OpenButton

-- 2. หน้าต่างหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

-- หัวข้อ
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "  📦 Monster Trader"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 10)
UICornerTitle.Parent = Title

-- ปุ่มปิด (Close - X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 6)
UICornerClose.Parent = CloseButton

-- ปุ่มย่อ (Minimize - _)
local MinButton = Instance.new("TextButton")
MinButton.Name = "MinButton"
MinButton.Parent = MainFrame
MinButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MinButton.Position = UDim2.new(1, -70, 0, 5)
MinButton.Size = UDim2.new(0, 30, 0, 30)
MinButton.Font = Enum.Font.GothamBold
MinButton.Text = "_"
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.TextSize = 16
local UICornerMin = Instance.new("UICorner")
UICornerMin.CornerRadius = UDim.new(0, 6)
UICornerMin.Parent = MinButton

-- Logic ปุ่ม
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinButton.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenButton.Visible = false end)

-- [[ ส่วน Control ด้านบน ]] --

-- ช่องใส่ User ID (ปรับขนาดเล็กลง)
local UserIdInput = Instance.new("TextBox")
UserIdInput.Parent = MainFrame
UserIdInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
UserIdInput.Position = UDim2.new(0.05, 0, 0.12, 0)
UserIdInput.Size = UDim2.new(0.45, 0, 0, 35) -- กว้าง 45%
UserIdInput.Font = Enum.Font.Gotham
UserIdInput.PlaceholderText = "Waiting ID..."
UserIdInput.Text = ""
UserIdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UserIdInput.TextSize = 13
local UICornerInput = Instance.new("UICorner")
UICornerInput.CornerRadius = UDim.new(0, 6)
UICornerInput.Parent = UserIdInput

-- สถานะ Auto Detect
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = UserIdInput
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 1, 2)
StatusLabel.Size = UDim2.new(1, 0, 0, 15)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Text = "..."
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 9
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่ม MAX ALL (เลือกทั้งหมด)
local MaxAllBtn = Instance.new("TextButton")
MaxAllBtn.Parent = MainFrame
MaxAllBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- สีส้ม
MaxAllBtn.Position = UDim2.new(0.52, 0, 0.12, 0)
MaxAllBtn.Size = UDim2.new(0.20, 0, 0, 35)
MaxAllBtn.Font = Enum.Font.GothamBold
MaxAllBtn.Text = "MAX ALL"
MaxAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxAllBtn.TextSize = 11
local UICornerMax = Instance.new("UICorner")
UICornerMax.CornerRadius = UDim.new(0, 6)
UICornerMax.Parent = MaxAllBtn

-- ปุ่ม RESET (เคลียร์เป็น 0)
local ResetBtn = Instance.new("TextButton")
ResetBtn.Parent = MainFrame
ResetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- สีเทา
ResetBtn.Position = UDim2.new(0.74, 0, 0.12, 0)
ResetBtn.Size = UDim2.new(0.10, 0, 0, 35)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Text = "CLR"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 11
local UICornerReset = Instance.new("UICorner")
UICornerReset.CornerRadius = UDim.new(0, 6)
UICornerReset.Parent = ResetBtn

-- ปุ่ม Refresh
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Parent = MainFrame
RefreshBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
RefreshBtn.Position = UDim2.new(0.86, 0, 0.12, 0)
RefreshBtn.Size = UDim2.new(0.09, 0, 0, 35)
RefreshBtn.Text = "🔄"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 18
local UICornerRefresh = Instance.new("UICorner")
UICornerRefresh.CornerRadius = UDim.new(0, 6)
UICornerRefresh.Parent = RefreshBtn

-- Scroll List
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ScrollingFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
ScrollingFrame.Size = UDim2.new(0.9, 0, 0.57, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
local UICornerScroll = Instance.new("UICorner")
UICornerScroll.CornerRadius = UDim.new(0, 6)
UICornerScroll.Parent = ScrollingFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- ปุ่มส่ง
local SendButton = Instance.new("TextButton")
SendButton.Parent = MainFrame
SendButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
SendButton.Position = UDim2.new(0.05, 0, 0.85, 0)
SendButton.Size = UDim2.new(0.9, 0, 0, 45)
SendButton.Font = Enum.Font.GothamBold
SendButton.Text = "UPDATE / SEND TRADE"
SendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SendButton.TextSize = 16
local UICornerSend = Instance.new("UICorner")
UICornerSend.CornerRadius = UDim.new(0, 8)
UICornerSend.Parent = SendButton

-- [[ 🟢 AUTO ID DETECT SYSTEM ]] --
local function StartAutoTracker()
    task.spawn(function()
        while task.wait(0.5) do
            if not MainFrame or not MainFrame.Parent then break end

            local foundId = nil
            local TradingFrame = LocalPlayer.PlayerGui.Windows:FindFirstChild("TradingFrame")
            
            if TradingFrame and TradingFrame.Visible then
                if debug and debug.getupvalue and TradeController then
                    pcall(function()
                        local val = debug.getupvalue(TradeController.AddToTradeData, 5)
                        if val and type(val) == "number" then foundId = val end
                    end)
                end
                if not foundId then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer then
                            local match = false
                            for _, v in pairs(TradingFrame:GetDescendants()) do
                                if v:IsA("TextLabel") and v.Visible then
                                    if v.Text == p.Name or v.Text == p.DisplayName then match = true break end
                                end
                            end
                            if match then foundId = p.UserId break end
                        end
                    end
                end
            end

            if foundId then
                if UserIdInput.Text ~= tostring(foundId) then UserIdInput.Text = tostring(foundId) end
                StatusLabel.Text = "✅ Active: " .. tostring(foundId)
                StatusLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
            else
                if TradingFrame and TradingFrame.Visible then
                    StatusLabel.Text = "⚠️ Searching..."
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                else
                    StatusLabel.Text = "❌ No Trade"
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                end
            end
        end
    end)
end

StartAutoTracker()

-- [[ 🧠 Logic Inventory ]] --
local InventoryData = {} 
local Inputs = {}

local function ScanInventory()
    InventoryData = {} 
    if ReplicaController and ReplicaController._replicas then
        for id, replica in pairs(ReplicaController._replicas) do
            local owner = replica.Tags and replica.Tags.Player
            if owner == LocalPlayer then
                if replica.Data and replica.Data.MonsterService and replica.Data.MonsterService.SavedMonsters then
                    local monsters = replica.Data.MonsterService.SavedMonsters
                    for uuid, data in pairs(monsters) do
                        local mName = "Unknown"
                        if type(data) == "table" and data.Name then mName = data.Name
                        elseif type(data) == "string" then mName = data end
                        
                        if not InventoryData[mName] then InventoryData[mName] = {} end
                        table.insert(InventoryData[mName], uuid)
                    end
                    break 
                end
            end
        end
    end
end

local function UpdateList()
    ScanInventory()
    for _, v in pairs(ScrollingFrame:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    Inputs = {}
    
    local keys = {}
    for name in pairs(InventoryData) do table.insert(keys, name) end
    table.sort(keys)
    
    for _, name in ipairs(keys) do
        local uuids = InventoryData[name]
        local totalCount = #uuids
        
        local ItemFrame = Instance.new("Frame")
        ItemFrame.Parent = ScrollingFrame
        ItemFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ItemFrame.Size = UDim2.new(1, -10, 0, 40)
        local UICornerItem = Instance.new("UICorner")
        UICornerItem.CornerRadius = UDim.new(0, 6)
        UICornerItem.Parent = ItemFrame
        
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Parent = ItemFrame
        NameLabel.BackgroundTransparency = 1
        NameLabel.Position = UDim2.new(0.05, 0, 0, 0)
        NameLabel.Size = UDim2.new(0.5, 0, 1, 0)
        NameLabel.Font = Enum.Font.GothamSemibold
        NameLabel.Text = name .. " (" .. totalCount .. ")"
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.TextSize = 13
        
        local CountInput = Instance.new("TextBox")
        CountInput.Parent = ItemFrame
        CountInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        CountInput.Position = UDim2.new(0.6, 0, 0.2, 0)
        CountInput.Size = UDim2.new(0.15, 0, 0.6, 0)
        CountInput.Font = Enum.Font.Gotham
        CountInput.Text = "0"
        CountInput.TextColor3 = Color3.fromRGB(255, 255, 0)
        CountInput.TextSize = 14
        local UICornerBox = Instance.new("UICorner")
        UICornerBox.CornerRadius = UDim.new(0, 4)
        UICornerBox.Parent = CountInput
        
        CountInput.FocusLost:Connect(function()
            local num = tonumber(CountInput.Text)
            if not num or num < 0 then CountInput.Text = "0"
            elseif num > totalCount then CountInput.Text = tostring(totalCount) end
        end)
        
        local MaxBtn = Instance.new("TextButton")
        MaxBtn.Parent = ItemFrame
        MaxBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        MaxBtn.Position = UDim2.new(0.78, 0, 0.2, 0)
        MaxBtn.Size = UDim2.new(0.18, 0, 0.6, 0)
        MaxBtn.Font = Enum.Font.Gotham
        MaxBtn.Text = "ALL"
        MaxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        MaxBtn.TextSize = 11
        local UICornerMax = Instance.new("UICorner")
        UICornerMax.CornerRadius = UDim.new(0, 4)
        UICornerMax.Parent = MaxBtn
        
        MaxBtn.MouseButton1Click:Connect(function()
            CountInput.Text = tostring(totalCount)
        end)
        
        Inputs[name] = {Box = CountInput, Available = uuids}
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #keys * 45)
end

-- [[ Logic ปุ่ม Control ]] --

-- MAX ALL: ปรับเลขทุกช่องเป็นค่าสูงสุด
MaxAllBtn.MouseButton1Click:Connect(function()
    for name, data in pairs(Inputs) do
        local total = #data.Available
        data.Box.Text = tostring(total)
    end
end)

-- RESET: ปรับเลขทุกช่องเป็น 0
ResetBtn.MouseButton1Click:Connect(function()
    for name, data in pairs(Inputs) do
        data.Box.Text = "0"
    end
end)

-- Refresh: โหลดรายการใหม่
RefreshBtn.MouseButton1Click:Connect(UpdateList)

-- Send Trade
SendButton.MouseButton1Click:Connect(function()
    local targetId = tonumber(UserIdInput.Text)
    if not targetId then
        SendButton.Text = "❌ NO TRADE ID"
        task.wait(1)
        SendButton.Text = "UPDATE / SEND TRADE"
        return
    end
    
    local payload = {}
    local totalToSend = 0
    
    for name, data in pairs(Inputs) do
        local amount = tonumber(data.Box.Text) or 0
        if amount > 0 then
            for i = 1, amount do
                local uuid = data.Available[i]
                if uuid then
                    payload[uuid] = { Name = name }
                    totalToSend = totalToSend + 1
                end
            end
        end
    end
    
    if totalToSend == 0 then
        print("ℹ️ Clearing Trade (0 items)")
        SendButton.Text = "🧹 CLEARING..."
    end
    
    local args = {
        targetId,
        {
            MonsterService = { MonstersUnlocked = {}, SavedMonsters = payload },
            CratesService = {}, Currencies = {}, PetsService = {}, ItemsService = {}, AccessoryService = {}
        }
    }
    
    local Success, Error = pcall(function()
        ReplicatedStorage.Packages.Knit.Services.TradingService.RF.UpdateTradeOffer:InvokeServer(unpack(args))
    end)
    
    if Success then
        SendButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        SendButton.Text = (totalToSend == 0) and "✅ CLEARED!" or "✅ SENT SUCCESS!"
    else
        SendButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        SendButton.Text = "❌ ERROR: " .. tostring(Error)
    end
    
    task.wait(1.5)
    SendButton.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    SendButton.Text = "UPDATE / SEND TRADE"
end)

UpdateList()
