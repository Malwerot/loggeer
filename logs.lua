--[[
    SCRIPT DE TESTE DE ESTRESSE - BRONX MARKET 2
    Objetivo: Disparar 2 vendas por clique para testar validação do servidor.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

-- Aguarda o carregamento do jogo
if not game:IsLoaded() then game.Loaded:Wait() end

-- 1. Carregamento da Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library.CreateLib("Market Debugger", "DarkTheme")
local Tab = Window:NewTab("Testes")
local Section = Tab:NewSection("Venda Dupla")

--[[ 
    FUNÇÕES LOCAIS (Lógica de Disparo)
--]]

-- Localiza o Remote que processa as vendas no seu jogo
local function getMarketRemote()
    -- Verifique no seu Explorer se o nome é exatamente esse:
    return ReplicatedStorage:FindFirstChild("RemoteEvent") or ReplicatedStorage:FindFirstChild("MarketEvent")
end

-- Função que executa a "Venda Dupla"
local function dispararVendaDupla(itemName)
    local remote = getMarketRemote()
    
    if not remote then 
        warn("ERRO: RemoteEvent não encontrado no ReplicatedStorage!")
        return 
    end

    -- Dispara o evento 2 vezes instantaneamente
    for i = 1, 2 do
        task.spawn(function()
            -- O formato dos argumentos deve seguir o que o seu script de servidor espera
            -- Exemplo comum: Remote:FireServer("Sell", "NomeDoItem")
            remote:FireServer("Sell", itemName)
        end)
    end
    
    print("Solicitação de venda dupla enviada para: " .. itemName)
end

--[[ 
    INTERFACE (Botões)
--]]

-- Define qual item será usado no teste (Ex: Phone, Gun, etc)
local itemAlvo = "Phone"
Section:NewTextBox("Item para Teste", "Digite o nome do item", function(txt)
    itemAlvo = txt
end)

-- Botão que executa a ação de 2 vendas por clique
Section:NewButton("Vender 2x de uma vez", "Testa se o servidor aceita 2 vendas simultâneas", function()
    dispararVendaDupla(itemAlvo)
end)

Section:NewButton("Checar Remote (F9)", "Verifica o caminho do Remote no console", function()
    local r = getMarketRemote()
    if r then
        print("Caminho do Remote: " .. r:GetFullName())
    else
        print("Nenhum Remote detectado.")
    end
end)

print("Script de Teste de Mercado carregado.")
