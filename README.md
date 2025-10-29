#
SJ工作室星辰 - 翻垃圾桶插件

一个为FiveM ESX服务器设计的翻垃圾桶插件，玩家可以翻垃圾桶来获得随机奖励。

## 功能特点

- 🗑️ 支持多种垃圾桶模型
- 🎁 随机奖励系统
- ⏱️ 可配置的搜索时间和冷却时间
- 🎨 美观的进度条界面
- 🔊 音效支持
- 📱 响应式设计
- 🛡️ 防作弊保护

## 安装说明

1. 确保已安装 `okokNotify` 通知系统
2. 将 `XC-Trashcan` 文件夹放入 `resources目录
3. 在 `server.cfg` 中添加：`ensure XC-Trash can`
4. 重启服务器

## 依赖要求

- ESX 1.10.1+
- okokNotify (通知系统)

## 配置说明

### 基本设置
- `Config.EnableDebug`: 是否启用调试模式
- `Config.SearchTime`: 翻垃圾桶时间（毫秒）
- `Config.CooldownTime`: 冷却时间（毫秒）
- `Config.MaxDistance`: 最大距离

### 奖励配置
在 `Config.Rewards` 中配置奖励物品：
```lua
{
    item = 'bread',        -- 物品名称
    amount = {1, 3},       -- 数量范围
    chance = 25            -- 概率（百分比）
}
```

### 垃圾桶模型
在 `Config.TrashCanModels` 中添加支持的垃圾桶模型：
```lua
`prop_bin_01a`,  -- 大型垃圾桶
`prop_bin_02a`,  -- 中型垃圾桶
-- 更多模型...
```

## 使用方法

1. 靠近任何配置的垃圾桶模型
2. 按 `E` 键开始翻垃圾桶
3. 等待进度条完成
4. 获得随机奖励

## 奖励物品

### 常见物品 (70% 概率)
- 面包 (bread)
- 水 (water)
- 苹果 (apple)
- 香蕉 (banana)

### 稀有物品 (25% 概率)
- 现金 (money)
- 撬锁器 (lockpick)
- 手机 (phone)
- 对讲机 (radio)

### 非常稀有物品 (5% 概率)
- 钻石 (diamond)
- 黄金 (gold)
- 刀具 (weapon_knife)

## 技术特性

- 使用最新的ESX框架
- 客户端-服务端分离架构
- 防作弊验证
- 性能优化
- 错误处理

## 文件结构

```
XC-Trashcan/
├── fxmanifest.lua      # 资源清单
├── config.lua          # 配置文件
├── client.lua          # 客户端脚本
├── server.lua          # 服务端脚本
├── html/               # 界面文件
│   ├── index.html      # HTML界面
│   ├── style.css       # CSS样式
│   └── script.js       # JavaScript脚本
└── README.md           # 说明文档
```

## 版本信息

- 版本: 1.0.0
- 作者: 星辰
- 兼容性: ESX 1.10.1+
- 框架: FiveM-ESX,es_extended

## 支持

如有问题或建议，请联系作者。

## 更新日志

### v1.0.0
- 初始版本发布
- 基础翻垃圾桶功能
- 随机奖励系统
- 进度条界面
- 音效支持

