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
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "WindUI 加载失败",
        Text = "请检查网络连接后重试",
        Duration = 5
    })
    return
end

local Window = WindUI:CreateWindow({
    Title = "AIhub-1.0.0",
    Author = "PISKIM",
    Icon = "house",
    Theme = "Dark",
    Folder = "MySuperScript",
    Size = UDim2.fromOffset(600, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 600),
    Resizable = true,
    ToggleKey = Enum.KeyCode.RightShift,
    SideBarWidth = 200,
    Transparent = true,
    Background = "rbxassetid://123456",
})

-- ===== 创建4个标签页 =====
local homeTab = Window:Tab({ Title = "主页", Icon = "home" })
local generalTab = Window:Tab({ Title = "通用", Icon = "sword" })
local otherTab = Window:Tab({ Title = "其他脚本", Icon = "box" })
local aiTab = Window:Tab({ Title = "AI主功能", Icon = "bot" })
local settingsTab = Window:Tab({ Title = "设置", Icon = "settings" })
local sanaoliTab=window:Tab({Title = "圣奥里”，Icon = "sun"})
aiTab:Paragraph({
    Title = "🤖 AI 智能助手",
    Description = "在下方输入问题，AI 会为你解答"
})

-- 存储聊天记录
local chatMessages = {"你好！我是免费AI助手，有什么可以帮你的吗？"}
local currentInput = ""
local chatContainer = aiTab  -- 用来添加消息

-- 显示已有聊天记录（用 Paragraph 显示所有消息）
local function updateChatDisplay()
    local fullText = table.concat(chatMessages, "\n\n")
    -- 用 Label 显示聊天记录
    if chatLabel then
        chatLabel:Set({
            Title = "💬 聊天记录",
            Description = fullText
        })
    end
end

-- 创建聊天记录显示区（用 Label）
local chatLabel = aiTab:Label({
    Title = "💬 聊天记录",
    Description = table.concat(chatMessages, "\n\n")
})

-- 输入框
aiTab:Input({
    Title = "✏️ 输入问题",
    Description = "在下方输入你想问的问题",
    Placeholder = "例如：如何快速升级？",
    Callback = function(text)
        currentInput = text or ""
    end
})

-- 发送按钮
aiTab:Button({
    Title = "📤 发送",
    Description = "点击发送你的问题给AI",
    Callback = function()
        if currentInput == "" or currentInput == nil then
            chatLabel:Set({
                Title = "💬 聊天记录",
                Description = table.concat(chatMessages, "\n\n") .. "\n\n⚠️ 请先输入问题"
            })
            return
        end
        
        -- 添加用户消息
        table.insert(chatMessages, "🧑 你: " .. currentInput)
        table.insert(chatMessages, "🤖 AI: 思考中...")
        chatLabel:Set({
            Title = "💬 聊天记录",
            Description = table.concat(chatMessages, "\n\n")
        })
        
        local question = currentInput
        currentInput = ""
        
        -- 发送请求
        local http = game:GetService("HttpService")
        local encoded = http:UrlEncode(question)
        local url = "https://api.xygeng.cn/api?msg=" .. encoded
        
        task.spawn(function()
            local ok, result = pcall(function()
                return http:GetAsync(url)
            end)
            
            if ok and result then
                local success, data = pcall(function()
                    return http:JSONDecode(result)
                end)
                
                if success and data and data.data and data.data.content then
                    -- 替换"思考中..."为实际回复
                    table.remove(chatMessages)
                    table.insert(chatMessages, "🤖 AI: " .. data.data.content)
                else
                    table.remove(chatMessages)
                    table.insert(chatMessages, "🤖 AI: ❌ 数据格式异常，请重试")
                end
            else
                table.remove(chatMessages)
                table.insert(chatMessages, "🤖 AI: ❌ 网络连接失败，请检查网络后重试")
            end
            
            chatLabel:Set({
                Title = "💬 聊天记录",
                Description = table.concat(chatMessages, "\n\n")
            })
        end)
    end
})

-- 清空聊天记录
aiTab:Button({
    Title = "🗑️ 清空聊天记录",
    Description = "清除所有对话历史",
    Callback = function()
        chatMessages = {"你好！我是免费AI助手，有什么可以帮你的吗？"}
        chatLabel:Set({
            Title = "💬 聊天记录",
            Description = table.concat(chatMessages, "\n\n")
        })
    end
})
