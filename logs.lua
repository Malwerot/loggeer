-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local logEnabled = false

-- Hook em TODAS RemoteEvents e RemoteFunctions do jogo
local function hookRemotes()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            -- Intercepta o FireServer (quando VOCÊ manda pro servidor)
            local oldFire = obj.FireServer
            obj.FireServer = function(self, ...)
                if logEnabled then
                    local args = {...}
                    local argsStr = ""
                    for _, v in ipairs(args) do
                        argsStr = argsStr .. tostring(v) .. ", "
                    end
                    print("[LOJA/REMOTE]", obj:GetFullName(), "| Enviou:", argsStr)
                end
                return oldFire(self, ...)
            end
        end

        if obj:IsA("RemoteFunction") then
            local oldInvoke = obj.InvokeServer
            obj.InvokeServer = function(self, ...)
                if logEnabled then
                    local args = {...}
                    local argsStr = ""
                    for _, v in ipairs(args) do
                        argsStr = argsStr .. tostring(v) .. ", "
                    end
                    print("[LOJA/INVOKE]", obj:GetFullName(), "| Enviou:", argsStr)
                end
                return oldInvoke(self, ...)
            end
        end
    end
end

-- Novos remotes que aparecerem
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("RemoteEvent") then
        local oldFire = obj.FireServer
        obj.FireServer = function(self, ...)
            if logEnabled then
                local args = {...}
                local argsStr = ""
                for _, v in ipairs(args) do
                    argsStr = argsStr .. tostring(v) .. ", "
                end
                print("[LOJA/REMOTE]", obj:GetFullName(), "| Enviou:", argsStr)
            end
            return oldFire(self, ...)
        end
    end
end)

hookRemotes()

-- Proximity Prompts (lojas físicas)
local function hookPrompt(prompt)
    prompt.Triggered:Connect(function(player)
        if player == LocalPlayer and logEnabled then
            print("[LOJA/PROMPT]", prompt.Parent.Name, "|", prompt:GetFullName())
        end
    end)
end

local function registerPrompts()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then hookPrompt(obj) end
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then hookPrompt(obj) end
end)

registerPrompts()

-- UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library.CreateLib("Logger", "DarkTheme")
local Tab = Window:NewTab("Logger")
local Section = Tab:NewSection("Controle")

Section:NewToggle("Ativar Logger", "Liga/Desliga", function(state)
    logEnabled = state
    print(state and "=== Logger ATIVADO ===" or "=== Logger DESATIVADO ===")
end)
```

Agora quando você interagir com a loja vai aparecer:
```
[LOJA/REMOTE] ReplicatedStorage.Remotes.BuyItem | Enviou: Sword, 1, 
[LOJA/INVOKE] ReplicatedStorage.Shop.Purchase | Enviou: ItemID_123, 
[LOJA/PROMPT] Vendedor | Workspace.Shop.NPC.ProximityPrompt
