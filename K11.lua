-- [[ KA HUB | ULTIMATE V8 - TELEPORT EDITION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURAÇÕES
local Config = {
    Aimbot = false,
    FOV = 150,
    ESP = false,
    Clicking = false,
    ClickCount = 0,
    LastClickCount = 0,
    LastUpdate = tick(),
    SpeedHack = false,
    WalkSpeed = 16,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 50,
    NoClip = false,
    ClickTP = false
}

local heartbeatConn

-- [[ MIRA FÍSICA V8 ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KA_V8_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local CursorHitbox = Instance.new("Frame", ScreenGui)
CursorHitbox.Size = UDim2.new(0, 60, 0, 60)
CursorHitbox.Position = UDim2.new(0.5, -30, 0.5, -30)
CursorHitbox.BackgroundTransparency = 1
CursorHitbox.Active = true
CursorHitbox.Draggable = true

local CursorVisual = Instance.new("Frame", CursorHitbox)
CursorVisual.Size = UDim2.new(0, 40, 0, 40)
CursorVisual.Position = UDim2.new(0.5, -20, 0.5, -20)
CursorVisual.BackgroundTransparency = 1

local function createLine(size, pos)
    local l = Instance.new("Frame", CursorVisual)
    l.Size = size; l.Position = pos
    l.BackgroundColor3 = Color3.new(1, 1, 1); l.BorderSizePixel = 0
    return l
end
createLine(UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 0.5, -1))
createLine(UDim2.new(0, 2, 1, 0), UDim2.new(0.5, -1, 0, 0))

-- [[ JANELA PRINCIPAL ]]
local Window = Rayfield:CreateWindow({
   Name = "KA Hub | Ultimate V8",
   LoadingTitle = "Injetando Teleport...",
   LoadingSubtitle = "Sistema de Viagem Instantânea",
   ConfigurationSaving = { Enabled = false }
})

-- ABA AUTO CLICKER
local ClickTab = Window:CreateTab("Auto Clicker", 4483362458)
local CPSLabel = ClickTab:CreateLabel("CPS Atual: 0")

ClickTab:CreateToggle({
   Name = "ATIVAR MODO V8",
   CurrentValue = false,
   Callback = function(v)
      Config.Clicking = v
      if v then heartbeatConn = RunService.Heartbeat:Connect(function()
          local pos = CursorHitbox.AbsolutePosition + (CursorHitbox.AbsoluteSize / 2)
          VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
          VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
          Config.ClickCount = Config.ClickCount + 1
      end)
      else if heartbeatConn then heartbeatConn:Disconnect() end end
   end,
})

-- ABA MOVIMENTO
local MoveTab = Window:CreateTab("Movimento", 4483362458)
MoveTab:CreateToggle({Name = "NoClip", CurrentValue = false, Callback = function(v) Config.NoClip = v end})
MoveTab:CreateToggle({Name = "Fly (Voar)", CurrentValue = false, Callback = function(v) Config.Fly = v end})
MoveTab:CreateToggle({Name = "Speed Hack", CurrentValue = false, Callback = function(v) Config.SpeedHack = v end})
MoveTab:CreateSlider({Name = "Velocidade", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) Config.WalkSpeed = v end})

-- [[ NOVA ABA TELEPORT ]]
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateToggle({
    Name = "Click TP (Ctrl + Clique)",
    CurrentValue = false,
    Callback = function(v) Config.ClickTP = v end,
})

TeleportTab:CreateSection("Teleportar para Jogador")

local PlayerDropdown = TeleportTab:CreateDropdown({
   Name = "Selecionar Jogador",
   Options = {"Atualizar Lista"},
   CurrentOption = "Atualizar Lista",
   Callback = function(Option)
       if Option == "Atualizar Lista" then return end
       local targetPlayer = Players:FindFirstChild(Option)
       if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
           Rayfield:Notify({Title = "Teleport", Content = "Teleportado para: "..Option, Duration = 2})
       end
   end,
})

-- Função para atualizar lista de jogadores
task.spawn(function()
    while task.wait(5) do
        local pList = {"Atualizar Lista"}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(pList, p.Name) end
        end
        PlayerDropdown:Refresh(pList)
    end
end)

-- ABA COMBATE
local CombatTab = Window:CreateTab("Combate", 4483362458)
CombatTab:CreateToggle({Name = "Aimbot (Head)", CurrentValue = false, Callback = function(v) Config.Aimbot = v end})
CombatTab:CreateToggle({Name = "ESP Highlights", CurrentValue = false, Callback = function(v) 
    Config.ESP = v 
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("V8_ESP") then p.Character.V8_ESP:Destroy() end
        end
    end
end})

-- [[ LÓGICA CLICK TP ]]
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and Config.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mousePos = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000)
        
        if raycastResult and LocalPlayer.Character then
            LocalPlayer.Character:MoveTo(raycastResult.Position)
        end
    end
end)

-- [[ LOOP PRINCIPAL ]]
RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if tick() - Config.LastUpdate >= 1 then
        CPSLabel:Set("CPS Atual: " .. (Config.ClickCount - Config.LastClickCount))
        Config.LastClickCount = Config.ClickCount
        Config.LastUpdate = tick()
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if hum and hrp then
        if Config.SpeedHack then hum.WalkSpeed = Config.WalkSpeed else hum.WalkSpeed = 16 end
        if Config.Fly then
            local moveDir = hum.MoveDirection
            local flyVel = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then flyVel = Vector3.new(0, Config.FlySpeed, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then flyVel = Vector3.new(0, -Config.FlySpeed, 0) end
            hrp.Velocity = (moveDir * Config.FlySpeed) + flyVel
        end
    end

    if Config.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("V8_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "V8_ESP"; h.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end

    if Config.Aimbot then
        local target = nil
        local dist = Config.FOV
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if mag < dist then dist = mag target = p end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
end)

Rayfield:Notify({Title = "KA HUB V8", Content = "Aba Teleport Adicionada!", Duration = 5})
