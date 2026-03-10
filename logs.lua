-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local logEnabled = false

local function hookCharacter(char)
    local humanoid = char:WaitForChild("Humanoid")

    -- Morte
    humanoid.Died:Connect(function()
        if logEnabled then print("[MORTE] Personagem morreu") end
    end)

    -- Sentar
    humanoid.Seated:Connect(function(active, seat)
        if logEnabled then
            if active and seat then
                print("[SENTOU] Em:", seat:GetFullName())
            else
                print("[LEVANTOU]")
            end
        end
    end)

    -- Tools equipadas/desequipadas
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and logEnabled then
            print("[EQUIPOU TOOL]", child.Name)

            child.Activated:Connect(function()
                if logEnabled then print("[USOU TOOL]", child.Name) end
            end)
        end
    end)

    char.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and logEnabled then
            print("[DESEQUIPOU TOOL]", child.Name)
        end
    end)
end

-- Proximity Prompts
local function hookPrompt(prompt)
    prompt.Triggered:Connect(function(player)
        if player == LocalPlayer and logEnabled then
            print("[INTERAGIU]", prompt.Parent.Name, "|", prompt:GetFullName())
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

-- Backpack
local backpack = LocalPlayer:WaitForChild("Backpack")
backpack.ChildAdded:Connect(function(child)
    if logEnabled then print("[PEGOU ITEM]", child.Name) end
end)
backpack.ChildRemoved:Connect(function(child)
    if logEnabled then print("[PERDEU ITEM]", child.Name) end
end)

-- Chat
LocalPlayer.Chatted:Connect(function(msg)
    if logEnabled then print("[CHAT]", msg) end
end)

-- Character
if LocalPlayer.Character then hookCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(hookCharacter)

-- UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Malwerot/test1/refs/heads/main/UUII.lua"))()
local Window = Library.CreateLib("Logger", "DarkTheme")
local Tab = Window:NewTab("Logger")
local Section = Tab:NewSection("Controle")

Section:NewToggle("Ativar Logger", "Liga/Desliga", function(state)
    logEnabled = state
    print(state and "=== Logger ATIVADO ===" or "=== Logger DESATIVADO ===")
end)
