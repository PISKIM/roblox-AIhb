-- 防检测主框架
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local AntiDetect = {
    enabled = true,
    hooks = {},
    spoofData = function()
        -- 将所有异常数据还原为正常值
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end,
    blockRemotes = function()
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():match("anti") then
                v.OnClientEvent:Connect(function() return end)
            end
        end
    end
}

-- 启动检测
AntiDetect.blockRemotes()
runService.Heartbeat:Connect(AntiDetect.spoofData)
