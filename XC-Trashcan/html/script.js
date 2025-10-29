// XC-Trash can JavaScript
let progressInterval = null;
let currentProgress = 0;
let notificationQueue = [];

// 监听来自Lua的消息
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.type) {
        case 'showProgress':
            showProgress(data.duration);
            break;
        case 'hideProgress':
            hideProgress();
            break;
        case 'showNotification':
            showNotification(data.title, data.message, data.notificationType, data.duration);
            break;
    }
});

// 显示进度条
function showProgress(duration) {
    const container = document.getElementById('progress-container');
    const progressFill = document.getElementById('progress-fill');
    const progressText = document.getElementById('progress-text');
    
    // 显示容器
    container.classList.remove('hidden');
    
    // 重置进度
    currentProgress = 0;
    progressFill.style.width = '0%';
    progressText.textContent = '0%';
    
    // 计算进度更新间隔
    const updateInterval = 50; // 每50ms更新一次
    const totalSteps = duration / updateInterval;
    const progressStep = 100 / totalSteps;
    
    // 开始进度动画
    progressInterval = setInterval(() => {
        currentProgress += progressStep;
        
        if (currentProgress >= 100) {
            currentProgress = 100;
            clearInterval(progressInterval);
        }
        
        // 更新进度条
        progressFill.style.width = currentProgress + '%';
        progressText.textContent = Math.round(currentProgress) + '%';
        
    }, updateInterval);
}

// 隐藏进度条
function hideProgress() {
    const container = document.getElementById('progress-container');
    
    // 清除进度间隔
    if (progressInterval) {
        clearInterval(progressInterval);
        progressInterval = null;
    }
    
    // 隐藏容器
    container.classList.add('hidden');
    
    // 重置进度
    currentProgress = 0;
    const progressFill = document.getElementById('progress-fill');
    const progressText = document.getElementById('progress-text');
    progressFill.style.width = '0%';
    progressText.textContent = '0%';
}

// 页面加载完成后的初始化
document.addEventListener('DOMContentLoaded', function() {
    // console.log('XC-Trash can UI loaded');
    
    // 确保初始状态是隐藏的
    hideProgress();
});

// 防止页面被选中
document.addEventListener('selectstart', function(e) {
    e.preventDefault();
});

// 防止右键菜单
document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
});

// 防止拖拽
document.addEventListener('dragstart', function(e) {
    e.preventDefault();
});

// 显示通知
function showNotification(title, message, type = 'info', duration = 5000) {
    const container = document.getElementById('notification-container');
    
    // 创建通知元素
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    
    // 获取图标
    const icon = getNotificationIcon(type);
    
    // 设置通知内容
    notification.innerHTML = `
        <div class="notification-header">
            <div class="notification-icon">${icon}</div>
            <h3 class="notification-title">${title}</h3>
            <button class="notification-close" onclick="closeNotification(this)">&times;</button>
        </div>
        <p class="notification-message">${message}</p>
    `;
    
    // 添加到容器
    container.appendChild(notification);
    
    // 触发显示动画
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    // 自动关闭
    setTimeout(() => {
        closeNotification(notification.querySelector('.notification-close'));
    }, duration);
}

// 获取通知图标
function getNotificationIcon(type) {
    switch(type) {
        case 'success':
            return '✓';
        case 'error':
            return '✕';
        case 'info':
        default:
            return 'i';
    }
}

// 关闭通知
function closeNotification(closeButton) {
    const notification = closeButton.closest('.notification');
    if (notification) {
        notification.classList.add('hide');
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 400);
    }
}
