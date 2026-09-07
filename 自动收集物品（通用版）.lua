-- 自动拾取最近物品
local player = game.Players.LocalPlayer
local char = player.Character
local hrp = char:FindFirstChild("HumanoidRootPart")

while wait(0.1) do
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("BasePart") and v.Name:match("Pickup|Coin|Item") then
            if (v.Position - hrp.Position).Magnitude < 20 then
                hrp.CFrame = CFrame.new(v.Position)
                wait(0.1)
            end
        end
    end
end
