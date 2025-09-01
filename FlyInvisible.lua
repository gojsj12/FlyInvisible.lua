--[[
   _______    __       FLY & INVISIBLE GUI SCRIPT
  ╱       ╲╲╱╱  
 ╱  FLYGUI ╱
╱         ╱
ALCHEMY HUB MINI EDITION
Features:
1. Fly with adjustable speed
2. Toggle invisible
]]

repeat wait() until game:IsLoaded()
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local flying = false
local speed = 50
local invisible = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyInvisibleGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,120)
frame.Position = UDim2.new(0,20,0,50)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0,180,0,40)
flyBtn.Position = UDim2.new(0,10,0,10)
flyBtn.Text = "Fly: OFF"
flyBtn.Parent = frame

local invisBtn = Instance.new("TextButton")
invisBtn.Size = UDim2.new(0,180,0,40)
invisBtn.Position = UDim2.new(0,10,0,60)
invisBtn.Text = "Invisible: OFF"
invisBtn.Parent = frame

-- BodyVelocity for flying
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
bv.Velocity = Vector3.new(0,0,0)

-- Fly toggle
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
    if flying and player.Character then
        bv.Parent = player.Character:WaitForChild("HumanoidRootPart")
    else
        bv:Destroy()
    end
end)

-- Invisible toggle
invisBtn.MouseButton1Click:Connect(function()
    invisible = not invisible
    invisBtn.Text = "Invisible: "..(invisible and "ON" or "OFF")
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = invisible and 1 or 0
                if part:FindFirstChild("Decal") then
                    part.Decal.Transparency = invisible and 1 or 0
                end
            end
        end
    end
end)

-- Update fly movement
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
