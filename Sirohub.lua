-- ============================
-- Rayfield
-- ============================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================
-- Window
-- ============================
local Window = Rayfield:CreateWindow({
    Name = "siro hub",
    LoadingTitle = "siro hub",
    LoadingSubtitle = "Utility Hub",
    ConfigurationSaving = { Enabled = false }
})

-- ============================
-- Main Tab
-- ============================
local MainTab = Window:CreateTab("Main",4483362458)

local SelectedPlayer
local function getPlayers()
    local t={}
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer then table.insert(t,p.Name) end
    end
    return t
end

local Drop = MainTab:CreateDropdown({
    Name="Select Player",
    Options=getPlayers(),
    Callback=function(v)
        SelectedPlayer = type(v)=="table" and v[1] or v
    end
})

Players.PlayerAdded:Connect(function() Drop:Refresh(getPlayers(),true) end)
Players.PlayerRemoving:Connect(function() Drop:Refresh(getPlayers(),true) end)

MainTab:CreateButton({
    Name="Teleport",
    Callback=function()
        local t = Players:FindFirstChild(SelectedPlayer or "")
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame =
                t.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    end
})

-- Infinite Jump
local InfJump=false
MainTab:CreateToggle({
    Name="Infinite Jump",
    Callback=function(v) InfJump=v end
})

UIS.JumpRequest:Connect(function()
    if InfJump then
        local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Speed
local Speed=false
local SpeedPower=70

MainTab:CreateToggle({
    Name="Speed",
    Callback=function(v) Speed=v end
})

MainTab:CreateSlider({
    Name="Speed Power",
    Range={20,300},
    Increment=1,
    CurrentValue=70,
    Callback=function(v) SpeedPower=v end
})

RunService.Heartbeat:Connect(function()
    if Speed then
        local c=LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") then
            local d=c.Humanoid.MoveDirection
            local v=c.HumanoidRootPart.AssemblyLinearVelocity
            c.HumanoidRootPart.AssemblyLinearVelocity=Vector3.new(d.X*SpeedPower,v.Y,d.Z*SpeedPower)
        end
    end
end)

-- Jump Power
local JumpOn=false
local JumpVal=50

MainTab:CreateToggle({
    Name="Jump Power",
    Callback=function(v) JumpOn=v end
})

MainTab:CreateSlider({
    Name="Jump Value",
    Range={10,300},
    Increment=1,
    CurrentValue=50,
    Callback=function(v) JumpVal=v end
})

RunService.Heartbeat:Connect(function()
    if JumpOn then
        local h=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then h.JumpPower=JumpVal end
    end
end)

MainTab:CreateButton({
    Name="Emote",
    Callback=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/1p6xnBNf"))()
    end
})

-- ============================
-- ESP Tab
-- ============================
local ESPTab = Window:CreateTab("ESP",4483362458)

local ESP_ON=false
local HL_ON=false

local function removeESP(plr)
    if plr.Character then
        local b=plr.Character:FindFirstChild("SIRO_ESP")
        if b then b:Destroy() end
    end
end

local function createESP(plr)
    if plr==LocalPlayer or not plr.Character then return end
    local head=plr.Character:FindFirstChild("Head")
    if not head then return end

    removeESP(plr)

    local bb=Instance.new("BillboardGui",head)
    bb.Name="SIRO_ESP"
    bb.Adornee=head
    bb.AlwaysOnTop=true
    bb.Size=UDim2.new(0,90,0,55)
    bb.StudsOffset=Vector3.new(0,2.8,0)

    local icon=Instance.new("ImageLabel",bb)
    icon.Size=UDim2.new(0,32,0,32)
    icon.Position=UDim2.new(0.5,-16,0,0)
    icon.BackgroundTransparency=1
    icon.Image=Players:GetUserThumbnailAsync(
        plr.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size48x48
    )
    Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)

    local name=Instance.new("TextLabel",bb)
    name.Size=UDim2.new(1,0,0,16)
    name.Position=UDim2.new(0,0,0,34)
    name.BackgroundTransparency=1
    name.Text=plr.Name
    name.TextScaled=true
    name.TextColor3=Color3.new(1,1,1)
    name.TextStrokeTransparency=0.6
end

local function removeHL(plr)
    local h=workspace:FindFirstChild("SIRO_HL_"..plr.Name)
    if h then h:Destroy() end
end

local function createHL(plr)
    if plr==LocalPlayer or not plr.Character then return end
    removeHL(plr)

    local hl=Instance.new("Highlight")
    hl.Name="SIRO_HL_"..plr.Name
    hl.Adornee=plr.Character
    hl.FillColor=Color3.fromRGB(255,0,0)
    hl.OutlineColor=Color3.fromRGB(255,255,255)
    hl.FillTransparency=0.5
    hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent=workspace
end

local function hook(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.2)
        if ESP_ON then createESP(plr) end
        if HL_ON then createHL(plr) end
    end)
end

for _,p in pairs(Players:GetPlayers()) do
    if p~=LocalPlayer then
        hook(p)
        if p.Character then
            if ESP_ON then createESP(p) end
            if HL_ON then createHL(p) end
        end
    end
end

Players.PlayerAdded:Connect(hook)

ESPTab:CreateToggle({
    Name="Icon ESP",
    Callback=function(v)
        ESP_ON=v
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer then
                if v then createESP(p) else removeESP(p) end
            end
        end
    end
})

ESPTab:CreateToggle({
    Name="Highlight",
    Callback=function(v)
        HL_ON=v
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer then
                if v then createHL(p) else removeHL(p) end
            end
        end
    end
})

-- ============================
-- FOV Tab（追加のみ）
-- ============================
local FOVTab = Window:CreateTab("FOV",4483362458)

local DefaultFOV = Camera.FieldOfView
local FOV_ON = false
local FOV_Value = DefaultFOV

task.spawn(function()
    while true do
        task.wait(0.15)
        if FOV_ON and Camera then
            Camera.FieldOfView = FOV_Value
        end
    end
end)

FOVTab:CreateToggle({
    Name="FOV Enable",
    Callback=function(v)
        FOV_ON=v
        if not v then
            Camera.FieldOfView = DefaultFOV
        end
    end
})

FOVTab:CreateSlider({
    Name="FOV Value",
    Range={70,120},
    Increment=1,
    CurrentValue=DefaultFOV,
    Callback=function(v)
        FOV_Value=v
        if FOV_ON then
            Camera.FieldOfView=v
        end
    end
})
