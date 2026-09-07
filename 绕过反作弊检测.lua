-- 劫持检测Remote，阻断上报
local antiCheat = game:GetService("ReplicatedStorage"):FindFirstChild("AntiCheat")
if antiCheat then
    antiCheat.OnClientEvent:Connect(function(data)
        -- 拦截并丢弃检测数据
        return
    end)
end

-- 伪造客户端数据，让服务端认为一切正常
local function spoofData()
    -- 修改客户端上报的数值
    local stats = player:FindFirstChild("Stats")
    if stats then
        stats.WalkSpeed.Value = 16  -- 正常值
        stats.JumpPower.Value = 50  -- 正常值
    end
end
