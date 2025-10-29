ESX = exports['es_extended']:getSharedObject()

-- 调试函数
function DebugPrint(message)
    if Config.EnableDebug then
        print('[XC-Trash can] ' .. message)
    end
end

-- 计算奖励
function CalculateReward()
    local totalChance = 0
    for _, reward in pairs(Config.Rewards) do
        totalChance = totalChance + reward.chance
    end
    
    local random = math.random(1, totalChance)
    local currentChance = 0
    
    for _, reward in pairs(Config.Rewards) do
        currentChance = currentChance + reward.chance
        if random <= currentChance then
            local amount = math.random(reward.amount[1], reward.amount[2])
            return reward.item, reward.label, amount
        end
    end
    
    -- 如果没有找到奖励，返回空
    return nil, nil, 0
end

-- 检查物品是否存在
function ItemExists(item)
    local items = ESX.GetItems()
    for _, itemData in pairs(items) do
        if itemData.name == item then
            return true
        end
    end
    return false
end

-- 给玩家添加物品
function GiveItemToPlayer(xPlayer, item, amount)
    if item == 'money' then
        xPlayer.addMoney(amount)
        DebugPrint('给玩家添加现金: ' .. amount)
        return true
    else
        -- 直接尝试添加物品，不检查是否存在
        local success = xPlayer.addInventoryItem(item, amount)
        if success then
            DebugPrint('成功给玩家添加物品: ' .. item .. ' x' .. amount)
            return true
        else
            DebugPrint('添加物品失败: ' .. item .. ' x' .. amount)
            -- 如果添加失败，尝试给现金作为替代
            local cashAmount = amount * 10 -- 每个物品给10现金
            xPlayer.addMoney(cashAmount)
            DebugPrint('给玩家现金作为替代: ' .. cashAmount)
            return true
        end
    end
end

-- 获取物品标签（从配置中获取）
function GetItemLabel(item)
    for _, reward in pairs(Config.Rewards) do
        if reward.item == item then
            return reward.label
        end
    end
    
    -- 如果配置中没有找到，返回物品名称
    return item
end

-- 发送聊天通知
function SendChatNotification(playerName, itemLabel, amount, sourcePlayerId)
    if not Config.ChatNotifications.enabled then
        DebugPrint('聊天通知已禁用')
        return
    end
    
    local message = string.format(Config.ChatNotifications.success_message, playerName, itemLabel, amount)
    DebugPrint('准备发送聊天消息: ' .. message)
    
    if Config.ChatNotifications.message_type == 0 then
        -- 全局消息
        DebugPrint('发送全局聊天消息')
        -- 尝试多种聊天事件格式
        TriggerClientEvent('chat:addMessage', -1, {
            color = {255, 255, 255},
            multiline = true,
            args = {"星辰垃圾桶", message}
        })
        
        -- 备用方法：使用chatMessage事件
        TriggerClientEvent('chatMessage', -1, '星辰垃圾桶', {255, 255, 255}, message)
        
    else
        -- 附近玩家消息
        local xPlayer = ESX.GetPlayerFromId(sourcePlayerId)
        if xPlayer then
            local playerCoords = xPlayer.getCoords()
            local players = ESX.GetPlayers()
            local sentCount = 0
            
            DebugPrint('发送附近玩家聊天消息，距离范围: ' .. Config.ChatNotifications.nearby_distance)
            
            for _, playerId in pairs(players) do
                local targetPlayer = ESX.GetPlayerFromId(playerId)
                if targetPlayer then
                    local targetCoords = targetPlayer.getCoords()
                    -- 使用兼容的距离计算方法
                    local distance = math.sqrt(
                        (playerCoords.x - targetCoords.x)^2 + 
                        (playerCoords.y - targetCoords.y)^2 + 
                        (playerCoords.z - targetCoords.z)^2
                    )
                    
                    if distance <= Config.ChatNotifications.nearby_distance then
                        -- 尝试多种聊天事件格式
                        TriggerClientEvent('chat:addMessage', playerId, {
                            color = {255, 255, 255},
                            multiline = true,
                            args = {"星辰垃圾桶", message}
                        })
                        
                        -- 备用方法：使用chatMessage事件
                        TriggerClientEvent('chatMessage', playerId, '星辰垃圾桶', {255, 255, 255}, message)
                        
                        sentCount = sentCount + 1
                        DebugPrint('向玩家 ' .. playerId .. ' 发送聊天消息，距离: ' .. distance)
                    end
                end
            end
            
            DebugPrint('总共向 ' .. sentCount .. ' 个玩家发送了聊天消息')
        else
            DebugPrint('无法获取源玩家信息')
        end
    end
end

-- 翻垃圾桶事件处理
RegisterNetEvent('xc-trashcan:searchTrashCan')
AddEventHandler('xc-trashcan:searchTrashCan', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    
    DebugPrint('玩家 ' .. xPlayer.getName() .. ' 开始翻垃圾桶')
    
    -- 计算奖励
    local item, itemLabel, amount = CalculateReward()
    
    if item and amount > 0 then
        -- 成功找到物品
        local success = GiveItemToPlayer(xPlayer, item, amount)
        
        if success then
            DebugPrint('玩家 ' .. xPlayer.getName() .. ' 找到了 ' .. itemLabel .. ' x' .. amount)
            
            -- 通知客户端
            TriggerClientEvent('xc-trashcan:searchResult', source, true, itemLabel, amount)
            
            -- 发送聊天通知
            SendChatNotification(xPlayer.getName(), itemLabel, amount, source)
            
            -- 记录日志（已禁用）
            -- print('[XC-Trash can] 玩家 ' .. xPlayer.getName() .. ' 在垃圾桶中找到了 ' .. itemLabel .. ' x' .. amount)
        else
            DebugPrint('给玩家添加物品失败: ' .. item)
            TriggerClientEvent('xc-trashcan:searchResult', source, false)
        end
    else
        -- 没有找到物品
        DebugPrint('玩家 ' .. xPlayer.getName() .. ' 没有找到任何物品')
        TriggerClientEvent('xc-trashcan:searchResult', source, false)
    end
end)

-- 玩家连接时
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    DebugPrint('玩家 ' .. xPlayer.getName() .. ' 已连接')
end)

-- 玩家断开连接时
RegisterNetEvent('esx:playerDropped')
AddEventHandler('esx:playerDropped', function(playerId, reason)
    DebugPrint('玩家 ' .. playerId .. ' 已断开连接，原因: ' .. reason)
end)

-- 测试命令
RegisterCommand('testtrash', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- 直接给玩家一个测试奖励
        local item, itemLabel, amount = CalculateReward()
        if item and amount > 0 then
            local success = GiveItemToPlayer(xPlayer, item, amount)
            if success then
                TriggerClientEvent('xc-trashcan:searchResult', source, true, itemLabel, amount)
                -- 测试聊天通知
                SendChatNotification(xPlayer.getName(), itemLabel, amount, source)
                -- print('[XC-Trash can] 测试: 给玩家 ' .. xPlayer.getName() .. ' 发放了 ' .. itemLabel .. ' x' .. amount)
            end
        end
    end
end, false)

-- 测试聊天命令
RegisterCommand('testchat', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        -- 直接测试聊天消息
        SendChatNotification(xPlayer.getName(), "测试物品", 5, source)
        print('[XC-Trash can] 测试聊天消息已发送')
    end
end, false)

-- 资源启动时
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- 静默启动，不显示任何信息
    end
end)

-- 资源停止时
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- 静默停止，不显示任何信息
    end
end)
