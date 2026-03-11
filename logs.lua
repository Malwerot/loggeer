--[[
    INTEGRAÇÃO TOTAL: UI + LÓGICA DE MERCADO (LOCAL FUNCTIONS)
    Alvo: Bronx Market 2
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer

-- Configurações de Inicialização
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library:CreateLib("Dev Console - Market", "DarkTheme")
local Tab = Window:NewTab("Mercado")
local Section = Tab:NewSection("Controle de Vendas/Compras")

-- Variáveis de Estado
_G.BatchAmount = 2
_G.AutoMode = false

--[[ 
    FUNÇÕES LOCAIS (Lógica de Backend)
--]]

-- Função para localizar o Remote do seu jogo (Ajuste o nome se necessário)
local function getMarketRemote()
    -- Tenta encontrar o Remote de compra ou venda no ReplicatedStorage
    return ReplicatedStorage:FindFirstChild("MarketEvent") or ReplicatedStorage:FindFirstChild("RemoteEvent")
end

local function processAction(actionType, itemName, amount)
    local remote = getMarketRemote()
    if not remote then 
        warn("Remote de mercado não encontrado no ReplicatedStorage!")
        return 
    end

    for i = 1, amount do
        -- task.spawn garante que os disparos ocorram quase no mesmo milissegundo
        task.spawn(function()
            remote:FireServer(actionType, itemName) 
            -- Exemplo: remote:FireServer("Sell", "Phone")
        end)
    end
    print("Processado: " .. amount .. "x " .. itemName)
end

-- Função para clicar nos botões da UI do jogo (Baseado na sua imagem)
local function forceClickMarketButton(buttonName)
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    local marketGui = playerGui and playerGui:FindFirstChild("Bronx Market 2")
    
    if marketGui then
        -- Tenta encontrar o botão "Phone" ou outro pelo caminho da imagem
        local btn = marketGui.Body.Frames.Guns.ScrollingFrame:FindFirstChild(buttonName)
        if btn and btn:IsA("ImageButton") then
            firesignal(btn.MouseButton1Click)
        end
    end
end

--[[ 
    ELEMENTOS DA UI (Interação)
--]]

-- Input para definir a quantidade (Ex: colocar 2 ou 5 de uma vez)
Section:NewTextBox("Quantidade Multiplicadora", "Padrão é 2", function(txt)
    local num = tonumber(txt)
    if num then
        _G.BatchAmount = num
        print("Nova quantidade definida: " .. num)
    end
end)

-- Botão para vender o item da imagem (Phone) em dobro/lote
Section:NewButton("Vender Lote (Phone)", "Vende a quantidade definida acima", function()
    processAction("Sell", "Phone", _G.BatchAmount)
end)

-- Toggle para automação de cliques (Sem Cooldown de espera de animação)
Section:NewToggle("Auto-Venda Rápida", "Ignora delays visuais da UI", function(state)
    _G.AutoMode = state
    task.spawn(function()
        while _G.AutoMode do
            -- Chama a função local de processamento
            processAction("Sell", "Phone", 1)
            task.wait(0.1) -- Delay mínimo para não crashar o servidor
        end
    end)
end)

Section:NewButton("Abrir Celular via Script", "Clica no botão da imagem", function()
    forceClickMarketButton("Phone")
end)

--[[
    DICA DE INTEGRAÇÃO:
    Como o jogo é seu, verifique no seu ServerScript se existe um 
    cheque de 'anti-spam'. Se houver, o FireServer múltiplo 
    pode te kickar. Se for o caso, aumente o limite no Servidor.
--]]

print("Script carregado com sucesso!")
