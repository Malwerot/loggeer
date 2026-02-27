-- Serviços
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Variável de controle
local logEnabled = false

-- Função para registrar interações
local function logPrompt(prompt)
    prompt.Triggered:Connect(function(player)
        if logEnabled and player == LocalPlayer then
            print(">>> Interagiu com:", prompt.Parent.Name, " | Caminho:", prompt:GetFullName())
        end
    end)
end

-- Percorre todos os ProximityPrompts do jogo e conecta o logger
local function registerAllPrompts()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            logPrompt(obj)
        end
    end
end

-- Atualiza automaticamente quando novos prompts aparecem
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        logPrompt(obj)
    end
end)

-- Inicializa
registerAllPrompts()

-- UI básica
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library.CreateLib("Logger", "DarkTheme")

local TabLogger = Window:NewTab("Logger")
local SectionLogger = TabLogger:NewSection("Controle")

SectionLogger:NewToggle("Ativar Logger", "Liga/Desliga o registro de interações", function(state)
    logEnabled = state
    if state then
        print("Logger ativado! Todas as interações vão aparecer nos logs.")
    else
        print("Logger desativado! Nenhuma interação será registrada.")
    end
end)
