-- [[ KA HUB | ULTIMATE V8 - TELEPORT FIX ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- SERVIÇOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- VARIÁVEL PARA GUARDAR A ILHA SELECIONADA
local SelectedIsland = "Ilha 1"

-- TABELA DE CFRAMES (ILHAS)
local IlhasCFrames = {
    ["Ilha 1"] = CFrame.new(-235.188, 1217.643, 255.308),
    ["Ilha 2"] = CFrame.new(-250.639, 2536.771, 391.219),
    ["Ilha 3"] = CFrame.new(-88.396, 3496.337, 414.687),
    ["Ilha 4"] = CFrame.new(-305.209, 4415.585, 354.863),
    ["Ilha 6"] = CFrame.new(-258.912, 5828.998, 267.613),
    ["Ilha 7"] = CFrame.new(-46.875, 7479.933, 149.203),
    ["Ilha 8"] = CFrame.new(-257.616, 8978.347, 169.886),
    ["Ilha 9"] = CFrame.new(-196.201, 10588.840, 39.336),
    ["Ilha 10"] = CFrame.new(-232.813, 12310.998, 247.907),
    ["Última Ilha"] = CFrame.new(-277.391, 14332.962, 455.127)
}

-- CONFIGURAÇÕES GERAIS
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
    NoClip = false
}

-- [[ JANELA PRINCIPAL ]]
local Window = Rayfield:CreateWindow({
   Name = "KA Hub | Ultimate V8",
   LoadingTitle = "Injetando Teleport...",
   LoadingSubtitle = "Sistema de Ilhas Corrigido",
   ConfigurationSaving = { Enabled = false }
})

-- ABA TELEPORT (ESTA É A ABA QUE VOCÊ PROCURA)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

TeleportTab:CreateSection("Teleport para Ilhas")

-- 1. SELECIONA A ILHA
TeleportTab:CreateDropdown({
   Name = "1. Selecionar Destino",
   Options = {"Ilha 1", "Ilha 2", "Ilha 3", "Ilha 4", "Ilha 6", "Ilha 7", "Ilha 8", "Ilha 9", "Ilha 10", "Última Ilha"},
   CurrentOption = "Ilha 1",
   Callback = function(Option)
       SelectedIsland = Option -- Apenas guarda o nome da ilha
   end,
})

-- 2. BOTÃO QUE REALIZA O TELEPORTE
TeleportTab:CreateButton({
   Name = "2. IR PARA ILHA AGORA",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.CFrame = IlhasCFrames[SelectedIsland]
           Rayfield:Notify({Title = "Sucesso", Content = "Chegaste a: " .. SelectedIsland, Duration = 3})
       end
   end,
})

TeleportTab:CreateSection("Outros")

TeleportTab:CreateToggle({
    Name = "Click TP (Ctrl + Clique)",
    CurrentValue = false,
    Callback = function(v) Config.ClickTP = v end,
})

-- ABA MOVIMENTO
local MoveTab = Window:CreateTab("Movimento", 4483362458)
MoveTab:CreateToggle({Name = "NoClip", CurrentValue = false, Callback = function(v) Config.NoClip = v end})
MoveTab:CreateToggle({Name = "Fly (Voar)", CurrentValue = false, Callback = function(v) Config.Fly = v end})
MoveTab:CreateSlider({Name = "Velocidade", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(v) Config.WalkSpeed = v end})

-- ABA AUTO CLICKER
local ClickTab = Window:CreateTab("Auto Clicker", 4483362458)
local CPSLabel = ClickTab:CreateLabel("CPS Atual: 0")

ClickTab:CreateToggle({
   Name = "ATIVAR MODO V8",
   CurrentValue = false,
   Callback = function(v)
      Config.Clicking = v
      if v then heartbeatConn = RunService.Heartbeat:Connect(function()
          -- (Lógica de clique V8 aqui...)
          Config.ClickCount = Config.ClickCount + 1
      end)
      else if heartbeatConn then heartbeatConn:Disconnect() end end
   end,
})

-- [[ LOOP DE NO CLIP E MOVIMENTO ]]
RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

Rayfield:Notify({Title = "KA HUB", Content = "Menu de Teleporte Pronto!", Duration = 5})
