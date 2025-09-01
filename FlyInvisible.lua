--[[ 
   _______    __       FLY & INVISIBLE GUI SCRIPT
  ╱       ╲╲╱╱  
 ╱  FLYGUI ╱
╱         ╱
ALCHEMY HUB MINI EDITION v2
Features:
1. Fly with adjustable speed
2. Toggle invisible
3. /fly command for everyone
4. Invisible for all parts
]]

repeat wait() until game:IsLoaded()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local flying = false
local speed = 50
local invisible = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyInvisibleGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,140)
frame.Position = UDim2.new(0,20,0,50)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0,0)
frame.Visible = true
frame.ClipsDescendants = true

-- Fly Button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0,200,0,50)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
flyBtn.TextColor3 = Color3.fromRGB(255,255,255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextScaled = true
flyBtn.Parent = frame

-- Invisible Button
local invisBtn = Instance.new("TextButton")
invisBtn.Size = UDim2.new(0,200,0,50)
invisBtn.Position = UDim2.new(0,10,0,80)
invisBtn.Text = "Invisible: OFF"
invisBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
invisBtn.TextColor3 = Color3.fromRGB(255,255,255)
invisBtn.Font = Enum.Font.GothamBold
invisBtn.TextScaled = true
invisBtn.Parent = frame

-- Fly velocity
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
bv.Velocity = Vector3.new(0,0,0)

-- Function apply invisibility
local function setInvisible(char, state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 1 or 0
            if part:FindFirstChild("Decal") then
                part.Decal.Transparency = state and 1 or 0
            end
        end
    end
end

-- Fly toggle function
local function toggleFly()
    flying = not flying
    flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
    if flying and player.Character then
        bv.Parent = player.Character:WaitForChild("HumanoidRootPart")
    else
        if bv.Parent then bv:Destroy() end
    end
end

-- Invisible toggle function
local function toggleInvis()
    invisible = not invisible
    invisBtn.Text = "Invisible: "..(invisible and "ON" or "OFF")
    if player.Character then
        setInvisible(player.Character, invisible)
    end
end

-- Button click connections
flyBtn.MouseButton1Click:Connect(toggleFly)
invisBtn.MouseButton1Click:Connect(toggleInvis)

-- Render step for flying
rs.RenderStepped:Connect(function()
    if flying and player.Character then
        local cam = workspace.CurrentCamera
        bv.Velocity = cam.CFrame.LookVector * speed
    end
end)

-- Speed adjustment
uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Up then
        speed = speed + 10
    elseif input.KeyCode == Enum.KeyCode.Down then
        speed = math.max(10, speed - 10)
    end
end)

-- Command chat /fly for everyone
Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg)
        if msg:lower() == "/fly" then
            if p.Character then
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local bvNew = Instance.new("BodyVelocity")
                    bvNew.MaxForce = Vector3.new(1e5,1e5,1e5)
                    bvNew.Velocity = Vector3.new(0,50,0)
                    bvNew.Parent = root
                end
            end
        end
    end)
end)

-- Make everyone invisible
for _, p in pairs(Players:GetPlayers()) do
    if p.Character then
        setInvisible(p.Character, invisible)
    end
    p.CharacterAdded:Connect(function(char)
        setInvisible(char, invisible)
    end)
end
