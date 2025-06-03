print("V1")
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/C0dexDev/gradletemplate/refs/heads/main/exp.lua'))()
--//Variables
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AttackMultiplier = 6
local MinHealth = 50
local MaxAttackDistance = 20

local AttackEvent = ReplicatedStorage:WaitForChild("AttackHandlerRemoteEvent")
--//Functions
function Teleport(targetPlayer)
    local localPlayer = Players.LocalPlayer
    if not (targetPlayer and targetPlayer:IsDescendantOf(Players)) then return end
    if not (localPlayer and localPlayer.Character and localPlayer.Character.PrimaryPart) then return end
    if not (targetPlayer.Character and targetPlayer.Character.PrimaryPart) then return end
    local swimConn = localPlayer.Character.PrimaryPart.ChildAdded:Connect(function(child)
        if child.Name == "SwimFloatBodyPosition" then
            child:Destroy()
        end
    end)
    local startPos = localPlayer.Character.PrimaryPart.Position
    local endPos = targetPlayer.Character.PrimaryPart.Position + Vector3.new(0,10,0)
    local distance = (endPos - startPos).Magnitude
    local tw = TweenService:Create(
        localPlayer.Character.PrimaryPart,
        TweenInfo.new(2, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(localPlayer.Character.PrimaryPart.Position - Vector3.new(0,10,0))}
    )
    tw:Play()
    tw.Completed:Wait()
    repeat
        local startPos = localPlayer.Character.PrimaryPart.Position
        local endPos = targetPlayer.Character.PrimaryPart.Position - Vector3.new(0,15,0)
        distance = (endPos - startPos).Magnitude

        local walkSpeed = 18
        if localPlayer.Character:FindFirstChildOfClass("Humanoid") and localPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed > 0 then
            walkSpeed = localPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed
        end
        local time = distance / walkSpeed
        local tw = TweenService:Create(
            localPlayer.Character.PrimaryPart,
            TweenInfo.new(time, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(endPos)}
        )
        tw:Play()
        task.wait(.5)
    until distance < 10 or not targetPlayer or not targetPlayer.Character
    for i=0,10 do
       task.wait(.05)
       if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character.Humanoid or targetPlayer.Character.Humanoid.Health <= 0 or not localPlayer.Character or not localPlayer.Character.Humanoid or localPlayer.Character.Humanoid.Health <= 0 then break end
       localPlayer.Character.PrimaryPart.CFrame = CFrame.new(targetPlayer.Character.PrimaryPart.Position - Vector3.new(0,15,0))
       AttackEvent:FireServer(targetPlayer.Character.Humanoid)
    end
    local tw = TweenService:Create(
        localPlayer.Character.PrimaryPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(startPos + Vector3.new(0,5,0))}
    )
    tw:Play()
    tw.Completed:Wait()
    task.wait(3)
    swimConn:Disconnect()
end

function Kill(player)

end

Teleport(game.Players["iChronux"])
