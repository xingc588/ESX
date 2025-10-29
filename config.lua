-- 配置表定义
Config = {}

-- ==================== 插件基本设置 ====================
-- 是否启用调试模式，开启后会在控制台输出调试信息
Config.EnableDebug = false -- 是否启用调试模式 false,
-- 翻垃圾桶所需的时间，单位：毫秒
Config.SearchTime = 5000 -- 翻垃圾桶时间（毫秒）
-- 玩家与垃圾桶的最大距离，超过此距离无法翻垃圾桶，单位：米
Config.MaxDistance = 2.0 -- 最大距离

-- ==================== 垃圾桶模型配置 ====================
-- 垃圾桶模型列表，所有在此列表中的模型都可以被翻
Config.TrashCanModels = {
    `prop_bin_01a`,      -- 大型垃圾桶模型
    `prop_bin_02a`,      -- 中型垃圾桶模型
    `prop_bin_03a`,      -- 小型垃圾桶模型
    `prop_bin_04a`,      -- 方形垃圾桶模型
    `prop_bin_05a`,      -- 圆形垃圾桶模型
    `prop_bin_06a`,      -- 绿色垃圾桶模型
    `prop_bin_07a`,      -- 蓝色垃圾桶模型
    `prop_bin_08a`,      -- 红色垃圾桶模型
    `prop_bin_09a`,      -- 黄色垃圾桶模型
    `prop_bin_10a`,      -- 黑色垃圾桶模型
    `prop_bin_11a`,      -- 白色垃圾桶模型
    `prop_bin_12a`,      -- 灰色垃圾桶模型
    `prop_bin_13a`,      -- 棕色垃圾桶模型
    `prop_bin_14a`,      -- 橙色垃圾桶模型
    `prop_bin_15a`,      -- 紫色垃圾桶模型
    `prop_dumpster_01a`, -- 大型工业垃圾桶模型（绿色）
    `prop_dumpster_02a`, -- 大型工业垃圾桶模型（蓝色）
    `prop_dumpster_03a`, -- 大型工业垃圾桶模型（红色）
    `prop_dumpster_04a`, -- 大型工业垃圾桶模型（黄色）
    `prop_dumpster_05a`, -- 大型工业垃圾桶模型（黑色）
    `prop_dumpster_06a`, -- 大型工业垃圾桶模型（白色）
    `prop_dumpster_07a`, -- 大型工业垃圾桶模型（灰色）
    `prop_dumpster_08a`, -- 大型工业垃圾桶模型（棕色）
    `prop_dumpster_09a`, -- 大型工业垃圾桶模型（橙色）
    `prop_dumpster_10a`, -- 大型工业垃圾桶模型（紫色）
    `prop_trashcan_01a`, -- 带银色圆顶盖的垃圾桶模型
    `prop_trashcan_02a`, -- 带银色圆顶盖的垃圾桶模型（变体1）
    `prop_trashcan_03a`, -- 带银色圆顶盖的垃圾桶模型（变体2）
    `prop_trashcan_04a`, -- 带银色圆顶盖的垃圾桶模型（变体3）
    `prop_trashcan_05a`, -- 带银色圆顶盖的垃圾桶模型（变体4）
    `prop_trashcan_06a`, -- 带银色圆顶盖的垃圾桶模型（变体5）
    `prop_trashcan_07a`, -- 带银色圆顶盖的垃圾桶模型（变体6）
    `prop_trashcan_08a`, -- 带银色圆顶盖的垃圾桶模型（变体7）
    `prop_trashcan_09a`, -- 带银色圆顶盖的垃圾桶模型（变体8）
    `prop_trashcan_10a`, -- 带银色圆顶盖的垃圾桶模型（变体9）
}

-- ==================== 奖励物品配置 ====================
-- 翻垃圾桶可能获得的奖励物品列表
Config.Rewards = {
    -- 常见物品类别 (总概率约70%)
    {
        item = 'bread',        -- 物品代码名称
        label = '面包',        -- 物品显示的中文名称
        amount = {1, 3},       -- 获得数量范围，最小1个，最大3个
        chance = 70            -- 获得概率，数值越大越容易获得
    },
    {
        item = 'water',        -- 物品代码名称
        label = '水',          -- 物品显示的中文名称
        amount = {1, 2},       -- 获得数量范围，最小1个，最大2个
        chance = 70            -- 获得概率，数值越大越容易获得
    },
    {
        item = 'black_money',        -- 物品代码名称
        label = '黑钱',        -- 物品显示的中文名称
        amount = {100, 200},       -- 获得数量范围，最小100，最大200
        chance = 70            -- 获得概率，数值越大越容易获得
    },
    {
        item = 'perc30',       -- 物品代码名称
        label = '泰勒宁 30MG',        -- 物品显示的中文名称
        amount = {1, 1},       -- 获得数量范围，最小1个，最大10个
        chance = 70            -- 获得概率，数值越大越容易获得
    },
    
    -- 稀有物品类别 (总概率约25%)
    {
        item = 'money',        -- 物品代码名称（现金）
        label = '现金',        -- 物品显示的中文名称
        amount = {50, 200},    -- 获得数量范围，最小50，最大200
        chance = 30            -- 获得概率，数值越大越容易获得
    },
    {
        item = 'lockpick',     -- 物品代码名称
        label = '撬锁器',      -- 物品显示的中文名称
        amount = {1, 1},       -- 获得数量范围，固定1个
        chance = 50             -- 获得概率，数值越大越容易获得
    },
    {
        item = 'phone',        -- 物品代码名称
        label = '手机',        -- 物品显示的中文名称
        amount = {1, 1},       -- 获得数量范围，固定1个
        chance = 3             -- 获得概率，数值越大越容易获得
    },
    {
        item = 'radio',        -- 物品代码名称
        label = '对讲机',      -- 物品显示的中文名称
        amount = {1, 1},       -- 获得数量范围，固定1个
        chance = 50             -- 获得概率，数值越大越容易获得
    },
    
    -- 非常稀有物品类别 (总概率约5%)
    {
        item = 'diamond',      -- 物品代码名称
        label = '钻石',        -- 物品显示的中文名称
        amount = {1, 1},       -- 获得数量范围，固定1个
        chance = 2             -- 获得概率，数值越大越容易获得
    },
    {
        item = 'gold',         -- 物品代码名称
        label = '黄金',        -- 物品显示的中文名称
        amount = {1, 2},       -- 获得数量范围，最小1个，最大2个
        chance = 80             -- 获得概率，数值越大越容易获得
    },
    {
        item = 'viagra',         -- 物品代码名称
        label = '伟哥',        -- 物品显示的中文名称
        amount = {1, 2},       -- 获得数量范围，最小1个，最大2个
        chance = 80             -- 获得概率，数值越大越容易获得
    },
    {
        item = 'morphine30', -- 物品代码名称
        label = '吗啡 30MG',        -- 物品显示的中文名称
        amount = {1, 1},       -- 获得数量范围，固定1个
        chance = 80             -- 获得概率，数值越大越容易获得
    }
}

-- ==================== 动画设置 ====================
-- 翻垃圾桶时播放的动画配置
Config.Animations = {
    dict = 'amb@world_human_bum_wash@male@low@idle_a', -- 动画字典名称
    anim = 'idle_a',                                   -- 动画名称
    flag = 49                                          -- 动画标志，控制动画播放方式
}

-- ==================== 通知消息设置 ====================
-- 各种情况下显示的通知消息配置
Config.Notifications = {
    -- 成功找到物品时的通知
    success = {
        type = 'success',                    -- 通知类型：成功
        title = '翻垃圾桶',                  -- 通知标题
        message = '你找到了 %s x%d'          -- 通知消息，%s为物品名称，%d为数量
    },
    -- 没有找到物品时的通知
    failed = {
        type = 'error',                      -- 通知类型：错误
        title = '翻垃圾桶',                  -- 通知标题
        message = '这个垃圾桶是空的...'      -- 通知消息
    },
    -- 距离垃圾桶太远时的通知
    too_far = {
        type = 'error',                      -- 通知类型：错误
        title = '翻垃圾桶',                  -- 通知标题
        message = '你离垃圾桶太远了'         -- 通知消息
    }
}

-- ==================== 音效设置 ====================
-- 各种情况下播放的音效配置
Config.Sounds = {
    -- 开始翻垃圾桶时的音效
    search = {
        name = 'SEARCH_TRASH',                    -- 音效名称
        set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'     -- 音效集合
    },
    -- 成功找到物品时的音效
    success = {
        name = 'PICK_UP_WEAPON',                  -- 音效名称
        set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'     -- 音效集合
    },
    -- 没有找到物品时的音效
    failed = {
        name = 'ERROR',                           -- 音效名称
        set = 'HUD_FRONTEND_DEFAULT_SOUNDSET'     -- 音效集合
    }
}

-- ==================== 聊天通知设置 ====================
-- 聊天框通知配置
Config.ChatNotifications = {
    -- 是否启用聊天框通知
    enabled = true,
    -- 成功找到物品时的聊天消息格式
    success_message = '^2[垃圾桶]^7 %s 在翻垃圾桶时获得了 ^3%s x%d^7',
    -- 聊天消息类型 (0=全局, 1=附近玩家)
    message_type = 1,
    -- 附近玩家的距离范围（当message_type为1时有效）
    nearby_distance = 50.0
}