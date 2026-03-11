--[[
    SCRIPT INTEGRADO - BRONX MARKET 2 (DEV EDITION)
    Lógica: Funções Locais para Performance
    Objetivo: Venda/Compra sem cooldown visual
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

-- Garante que o jogo carregou antes de iniciar a UI
if not game:IsLoaded() then game.Loaded:Wait() end

-- 1. Carregamento da Library com tratamento de erro
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()

-- 2. Criação da Janela (Algumas libraries precisam de variáveis específicas)
local Window = Library.CreateLib("Market Dev", "DarkTheme")

-- 3. Abas e Seções
local TabMarket = Window:NewTab("Mercado")
local SectionAction = TabMarket:NewSection("Ações Rápidas")

-- 4. Variáveis de Controle (Locais)
local batchQuantity = 2
local isAutoSelling = false
local itemName = "Phone" -- Nome do item baseado na sua imagem

--[[ 
    FUNÇÕES LOCAIS (CORE)
--]]

-- Localiza o Remote de forma segura
local function getRemote()
    -- Procure pelo nome exato do seu RemoteEvent no ReplicatedStorage
    -- Exemplo: "SellItem", "MarketRemote", etc.
    return ReplicatedStorage:FindFirstChild("RemoteEvent") or ReplicatedStorage:FindFirstChild("MarketEvent")
end

-- Processa a ação múltipla (Onde ocorre a "duplicação" de envio)
local function sendMarketRequest(action, name, amount)
    local remote = getRemote()
    if not remote then 
        warn("Remote não encontrado! Verifique o nome no ReplicatedStorage.")
        return 
    end

    for i = 1, amount do
        task.spawn(function()
            -- O formato do FireServer depende de como você programou seu servidor
            remote:FireServer(action, name)
        end)
    end
end

--[[ 
    INTERAÇÃO COM A UI (LIBRARY)
--]]

-- TextBox para definir a quantidade de uma vez
SectionAction:NewTextBox("Qtd p/ Venda/Compra", "Ex: 2", function(txt)
    local n = tonumber(txt)
    if n then batchQuantity = n end
end)

-- Botão para disparar a venda múltipla
SectionAction:NewButton("Vender " .. itemName .. " (Multi)", "Vende " .. batchQuantity .. " de uma vez", function()
    sendMarketRequest("Sell", itemName, batchQuantity)
end)

-- Toggle para o modo automático (Ignora cooldowns da UI visual)
SectionAction:NewToggle("Auto-Venda (No Cooldown)", "Loop infinito de venda rápida", function(state)
    isAutoSelling = state
    
    task.spawn(function()
        while isAutoSelling do
            sendMarketRequest("Sell", itemName, 1)
            task.wait(0.1) -- Delay de segurança para o servidor
        end
    end)
end)

-- Botão de Debug para ver se o Remote existe
SectionAction:NewButton("Checar Remote no Console", "Aperte F9 após clicar", function()
    local r = getRemote()
    if r then
        print("Remote encontrado: " .. r:GetFullName())
    else
        warn("Nenhum Remote de Mercado foi localizado!")
    end
end)

print("--- Script de Mercado Carregado ---")
