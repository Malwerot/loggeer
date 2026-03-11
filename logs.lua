-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local logEnabled = false

-- UI (estrutura original que funcionava)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library.CreateLib("Logger", "DarkTheme")
local TabLogger = Window:NewTab("Logger")
local SectionLogger = TabLogger:NewSection("Controle")

SectionLogger:NewToggle("Ativar Logger", "Liga/Desliga o registro de interações", function(state)
    logEnabled = state
    print(state and "=== Logger ATIVADO ===" or "=== Logger DESATIVADO ===")
end)

-- Hook em botões da GUI
local function hookButton(btn)
    btn.MouseButton1Click:Connect(function()
        if logEnabled then
            print("[CLIQUE GUI]", btn:GetFullName(), "| Texto:", btn.Text or "sem texto")
        end
    end)
end

local function hookAllButtons(gui)
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            hookButton(obj)
        end
    end
    gui.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            hookButton(obj)
        end
    end)
end

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
for _, gui in ipairs(playerGui:GetChildren()) do
    hookAllButtons(gui)
end
playerGui.ChildAdded:Connect(function(gui)
    hookAllButtons(gui)
end)

-- Hook Remotes
for _, obj in ipairs(game:GetDescendants()) do
    pcall(function()
        if obj:IsA("RemoteEvent") then
            local oldFire = obj.FireServer
            obj.FireServer = function(self, ...)
                if logEnabled then
                    local argsStr = ""
                    for _, v in ipairs({...}) do argsStr = argsStr .. tostring(v) .. ", " end
                    print("[REMOTE]", obj:GetFullName(), "| Enviou:", argsStr)
                end
                return oldFire(self, ...)
            end
        elseif obj:IsA("RemoteFunction") then
            local oldInvoke = obj.InvokeServer
            obj.InvokeServer = function(self, ...)
                if logEnabled then
                    local argsStr = ""
                    for _, v in ipairs({...}) do argsStr = argsStr .. tostring(v) .. ", " end
                    print("[INVOKE]", obj:GetFullName(), "| Enviou:", argsStr)
                end
                return oldInvoke(self, ...)
            end
        end
    end)
end
