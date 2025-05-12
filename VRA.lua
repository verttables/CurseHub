-- Configuration
local AIM_KEY = "e" -- Key to toggle aimbot (you can change this)
local SMOOTHNESS = 0.1 -- Lower values for faster aiming, higher for smoother

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Aiming = false

-- Function to get the closest enemy
local function GetClosestEnemy()
    local closestTarget = nil
    local closestDistance = math.huge
    local localCharacter = LocalPlayer.Character
    if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then return nil end
    local localPosition = localCharacter.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
                -- Check if the player is an enemy (you'd need to know how Arsenal handles teams)
                -- Example (this might need adjustment based on Arsenal's team system):
                if -- player:GetAttribute("Team") ~= LocalPlayer:GetAttribute("Team") then
                    local targetPosition = character.HumanoidRootPart.Position
                    local distance = (localPosition - targetPosition).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = player
                    end
                end
            end
        end
    end
    return closestTarget and closestTarget.Character and closestTarget.Character:FindFirstChild("HumanoidRootPart")
end

-- Function to calculate the angles to a target
local function GetAnglesToTarget(targetPosition)
    local localCharacter = LocalPlayer.Character
    local head = localCharacter:FindFirstChild("Head") -- Assuming the head is the aiming origin
    local camera = workspace.CurrentCamera

    if head and camera then
        local direction = (targetPosition - head.Position).Unit
        local lookVector = camera.CFrame.LookVector

        local yaw = math.atan2(direction.X, direction.Z) - math.atan2(lookVector.X, lookVector.Z)
        local pitch = math.asin(direction.Y) - math.asin(lookVector.Y)

        return yaw, pitch
    end
    return 0, 0
end

-- Function to move the mouse smoothly
local function SmoothMouseMove(yaw, pitch)
    local currentMousePos = UserInputService:GetMouseLocation()
    local deltaX = yaw * 1000 * SMOOTHNESS -- Adjust multiplier for sensitivity
    local deltaY = pitch * 1000 * SMOOTHNESS

    mousemoverel(deltaX, deltaY) -- Assuming an external function 'mousemoverel' exists (common in exploits)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode[AIM_KEY:upper()] then
        Aiming = true
        print("Aimbot Activated")
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode[AIM_KEY:upper()] then
        Aiming = false
        print("Aimbot Deactivated")
    end
end)

RunService.RenderStepped:Connect(function()
    if Aiming then
        local target = GetClosestEnemy()
        if target then
            local targetPosition = target.Position
            local yaw, pitch = GetAnglesToTarget(targetPosition)
            SmoothMouseMove(yaw, pitch)
        end
    end
end)

print("vert's retarded aimbot loaded.... penaur sniffing penaur")
print("Toggle Key:", AIM_KEY)
