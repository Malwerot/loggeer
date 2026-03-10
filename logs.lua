-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local logEnabled = false

-- UI PRIMEIRO
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library.CreateLib("Logger", "DarkTheme")
local Tab = Window:NewTab("Logger")
local Section = Tab:NewSection("Controle")

Section:NewToggle("Ativar Logger", "Liga/Desliga", function(state)
    logEnabled = state
    print(state and "=== Logger ATIVADO ===" or "=== Logger DESATIVADO ===")
end)

-- Hook Remotes
local function hookRemotes()
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
end

game.DescendantAdded:Connect(function(obj)
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
        end
    end)
end)

-- Proximity Prompts
local function hookPrompt(prompt)
    prompt.Triggered:Connect(function(player)
        if player == LocalPlayer and logEnabled then
            print("[PROMPT]", prompt.Parent.Name, "|", prompt:GetFullName())
        end
    end)
end

for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then hookPrompt(obj) end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then hookPrompt(obj) end
end)

hookRemotes()
