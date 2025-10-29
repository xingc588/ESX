ESX = exports['es_extended']:getSharedObject()

local isSearching = false
local nearbyTrashCan = nil
local searchedTrashCans = {} -- 已翻过的垃圾桶列表

-- 调试函数
function DebugPrint(message)
    if Config.EnableDebug then
        print('[XC-Trash can] ' .. message)
    end
end

-- 播放音效
function PlaySound(sound)
    PlaySoundFrontend(-1, sound.name, sound.set, false)
end

-- 显示通知
function ShowNotification(data, ...)
    local message = string.format(data.message, ...)
    local title = data.title or '翻垃圾桶'
    local type = data.type or 'info'
    
    -- 使用自定义通知UI
    SendNUIMessage({
        type = 'showNotification',
        title = title,
        message = message,
        notificationType = type,
        duration = 5000
    })
end

-- 检查是否为垃圾桶模型
function IsTrashCanModel(model)
    for _, trashModel in pairs(Config.TrashCanModels) do
        if model == trashModel then
            return true
        end
    end
    return false
end

-- 检查垃圾桶是否已被翻过
function IsTrashCanSearched(trashCan)
    local coords = GetEntityCoords(trashCan)
    local key = string.format("%.2f,%.2f,%.2f", coords.x, coords.y, coords.z)
    return searchedTrashCans[key] ~= nil
end

-- 标记垃圾桶为已翻过
function MarkTrashCanAsSearched(trashCan)
    local coords = GetEntityCoords(trashCan)
    local key = string.format("%.2f,%.2f,%.2f", coords.x, coords.y, coords.z)
    searchedTrashCans[key] = true
    DebugPrint('标记垃圾桶为已翻过: ' .. key)
end

-- 获取最近的垃圾桶
function GetNearestTrashCan()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local nearestTrashCan = nil
    local nearestDistance = Config.MaxDistance
    
    -- 获取附近的所有对象
    local objects = GetGamePool('CObject')
    
    for _, object in pairs(objects) do
        if DoesEntityExist(object) then
            local model = GetEntityModel(object)
            if IsTrashCanModel(model) then
                -- 检查是否已被翻过
                if not IsTrashCanSearched(object) then
                    local coords = GetEntityCoords(object)
                    local distance = #(playerCoords - coords)
                    
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestTrashCan = object
                    end
                end
            end
        end
    end
    
    return nearestTrashCan, nearestDistance
end

-- 播放翻垃圾桶动画
function PlaySearchAnimation()
    local playerPed = PlayerPedId()
    
    -- 加载动画字典
    RequestAnimDict(Config.Animations.dict)
    while not HasAnimDictLoaded(Config.Animations.dict) do
        Citizen.Wait(100)
    end
    
    -- 播放动画
    TaskPlayAnim(playerPed, Config.Animations.dict, Config.Animations.anim, 8.0, -8.0, -1, Config.Animations.flag, 0, false, false, false)
    
    -- 保持动画直到搜索完成
    Citizen.CreateThread(function()
        while isSearching do
            if not IsEntityPlayingAnim(playerPed, Config.Animations.dict, Config.Animations.anim, 3) then
                TaskPlayAnim(playerPed, Config.Animations.dict, Config.Animations.anim, 8.0, -8.0, -1, Config.Animations.flag, 0, false, false, false)
            end
            Citizen.Wait(1000)
        end
        
        -- 停止动画
        ClearPedTasks(playerPed)
    end)
end

-- 显示搜索进度
function ShowSearchProgress()
    SendNUIMessage({
        type = 'showProgress',
        duration = Config.SearchTime
    })
    SetNuiFocus(false, false)
end

-- 隐藏搜索进度
function HideSearchProgress()
    SendNUIMessage({
        type = 'hideProgress'
    })
end

-- 翻垃圾桶主函数
function SearchTrashCan()
    if isSearching then
        return
    end
    
    local trashCan, distance = GetNearestTrashCan()
    if not trashCan then
        ShowNotification(Config.Notifications.too_far)
        return
    end
    
    if distance > Config.MaxDistance then
        ShowNotification(Config.Notifications.too_far)
        return
    end
    
    isSearching = true
    nearbyTrashCan = trashCan
    
    DebugPrint('开始翻垃圾桶，距离: ' .. distance)
    
    -- 播放音效
    PlaySound(Config.Sounds.search)
    
    -- 播放动画
    PlaySearchAnimation()
    
    -- 显示进度条
    ShowSearchProgress()
    
    -- 等待搜索完成
    Citizen.Wait(Config.SearchTime)
    
    -- 隐藏进度条
    HideSearchProgress()
    
    -- 停止动画
    isSearching = false
    nearbyTrashCan = nil
    
    -- 标记垃圾桶为已翻过
    MarkTrashCanAsSearched(trashCan)
    
    -- 向服务端请求奖励
    TriggerServerEvent('xc-trashcan:searchTrashCan')
end

-- 绘制3D文字
function Draw3DText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z + 1.2)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        -- 获取当前时间用于动画效果
        local time = GetGameTimer() / 1000.0
        
        -- 创建彩虹渐变效果
        local colors = {
            {255, 0, 0},    -- 红色
            {255, 127, 0},  -- 橙色
            {255, 255, 0},  -- 黄色
            {0, 255, 0},    -- 绿色
            {0, 0, 255},    -- 蓝色
            {75, 0, 130},   -- 靛色
            {148, 0, 211}   -- 紫色
        }
        
        -- 计算当前颜色索引
        local colorIndex = (math.floor(time * 2) % #colors) + 1
        local nextColorIndex = (colorIndex % #colors) + 1
        
        -- 获取当前和下一个颜色
        local currentColor = colors[colorIndex]
        local nextColor = colors[nextColorIndex]
        
        -- 计算颜色插值
        local t = (time * 2) % 1
        local r = math.floor(currentColor[1] + (nextColor[1] - currentColor[1]) * t)
        local g = math.floor(currentColor[2] + (nextColor[2] - currentColor[2]) * t)
        local b = math.floor(currentColor[3] + (nextColor[3] - currentColor[3]) * t)
        
        -- 设置文字样式
        SetTextScale(0.35, 0.35)
        SetTextFont(1)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255) -- 使用渐变颜色
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        
        -- 添加发光效果（绘制多个偏移的文字）
        for i = 1, 3 do
            local offset = i * 0.001
            SetTextColour(r, g, b, 50) -- 更透明的发光效果
            DrawText(_x + offset, _y + offset)
        end
        
    end
end

-- 绘制红圈标记
function DrawRedCircle(coords)
    -- 使用DrawMarker绘制圆柱体红圈
    DrawMarker(
        1, -- 标记类型：圆柱体
        coords.x, coords.y, coords.z - 0.3, -- 位置（稍微降低一点）
        0.0, 0.0, 0.0, -- 方向
        0.0, 0.0, 0.0, -- 旋转
        1.5, 1.5, 1.0, -- 大小：直径1.5米，高度1米
        255, 0, 0, 150, -- 颜色：红色，半透明
        false, -- 不上下跳动
        true, -- 面向相机
        2, -- 渲染距离
        false, -- 不旋转
        nil, nil, -- 纹理
        false -- 不绘制在实体上
    )
end

-- 主循环
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        -- 检查是否在车内
        if IsPedInAnyVehicle(playerPed, false) then
            Citizen.Wait(1000)
            goto continue
        end
        
        -- 获取最近的垃圾桶
        local trashCan, distance = GetNearestTrashCan()
        
        if trashCan and distance <= Config.MaxDistance then
            -- 获取垃圾桶坐标
            local trashCoords = GetEntityCoords(trashCan)
            
            -- 绘制红圈标记
            DrawRedCircle(trashCoords)
            
            -- 绘制3D文字提示
            Draw3DText(trashCoords, '[E] 翻垃圾桶')
            
            -- 检查按键
            if IsControlJustPressed(0, 38) then -- E键
                SearchTrashCan()
            end
        else
            Citizen.Wait(500)
        end
        
        ::continue::
    end
end)

-- 服务端事件处理
RegisterNetEvent('xc-trashcan:searchResult')
AddEventHandler('xc-trashcan:searchResult', function(success, item, amount)
    if success then
        PlaySound(Config.Sounds.success)
        ShowNotification(Config.Notifications.success, item, amount)
    else
        PlaySound(Config.Sounds.failed)
        ShowNotification(Config.Notifications.failed)
    end
end)

-- 资源停止时清理
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        HideSearchProgress()
        if isSearching then
            local playerPed = PlayerPedId()
            ClearPedTasks(playerPed)
        end
    end
end)
