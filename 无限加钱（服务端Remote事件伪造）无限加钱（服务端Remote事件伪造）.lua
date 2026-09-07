-- 找到游戏的加钱Remote事件（需要自己分析）
local remote = game:GetService("ReplicatedStorage"):FindFirstChild("AddMoney")

-- 伪造请求发送给服务端
local function addMoney(amount)
    if remote then
        remote:FireServer(amount, "legit_source")
    end
end

-- 循环自动加钱
while wait(0.5) do
    addMoney(1000)
end
