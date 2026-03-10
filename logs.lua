-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local logEnabled = false

local function hookCharacter(char)
    -- Loga TUDO que for adicionado/removido do character
    char.DescendantAdded:Connect(function(obj)
        print("[ADDED]", obj.ClassName, "|", obj:GetFullName())
    end)

    char.DescendantRemoving:Connect(function(obj)
        print("[REMOVED]", obj.ClassName, "|", obj:GetFullName())
    end)

    -- Loga TODA mudança de propriedade em qualquer objeto do character
    for _, obj in ipairs(char:GetDescendants()) do
        obj.Changed:Connect(function(prop)
            if logEnabled then
                print("[CHANGED]", obj:GetFullName(), "|", prop, "=", tostring(obj[prop]))
            end
        end)
    end

    -- Conecta Changed nos novos objetos também
    char.DescendantAdded:Connect(function(obj)
        obj.Changed:Connect(function(prop)
            if logEnabled then
                pcall(function()
                    print("[CHANGED]", obj:GetFullName(), "|", prop, "=", tostring(obj[prop]))
                end)
            end
        end)
    end)

    -- RemoteEvents e RemoteFunctions disparadas pelo character
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local old = obj.OnClientEvent
            pcall(function()
                obj.OnClientEvent:Connect(function(...)
                    if logEnabled then
                        print("[REMOTE EVENT]", obj:GetFullName(), "| args:", ...)
                    end
                end)
            end)
        end
    end
end

-- Conecta no character atual e futuros
if LocalPlayer.Character then
    hookCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    hookCharacter(char)
end)

-- UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library.CreateLib("Logger", "DarkTheme")

local TabLogger = Window:NewTab("Logger")
local SectionLogger = TabLogger:NewSection("Controle")

SectionLogger:NewToggle("Ativar Logger", "Liga/Desliga", function(state)
    logEnabled = state
    print(state and "=== Logger ATIVADO ===" or "=== Logger DESATIVADO ===")
end)
