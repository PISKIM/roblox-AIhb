-- 在客户端脚本中劫持弹药获取逻辑
local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- 监听武器加入背包
backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        local ammo = tool:FindFirstChild("Ammo")
        if ammo then
            -- 锁定弹药值为999
            game:GetService("RunService").Heartbeat:Connect(function()
                if ammo.Value < 999 then
                    ammo.Value = 999
                end
            end)
        end
    end
end)
