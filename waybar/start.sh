#!/bin/bash

# Waybar启动脚本 - 修复DISPLAY冲突问题

# 1. 清理冲突的环境变量
echo "清理环境变量..."
unset DISPLAY
unset XAUTHORITY

# 2. 设置Wayland环境变量
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

# 3. 获取Hyprland的Wayland显示
if [[ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]]; then
    export WAYLAND_DISPLAY=wayland-$HYPRLAND_INSTANCE_SIGNATURE
    echo "使用Hyprland的Wayland显示: $WAYLAND_DISPLAY"
else
    # 尝试其他Wayland显示
    if ls /tmp/wayland-* 2>/dev/null | grep -q wayland; then
        export WAYLAND_DISPLAY=$(ls /tmp/wayland-* | head -1 | xargs basename)
        echo "检测到Wayland显示: $WAYLAND_DISPLAY"
    else
        echo "错误: 未找到Wayland显示"
        exit 1
    fi
fi

# 4. 停止已有的进程
echo "停止现有的waybar进程..."
pkill -9 waybar 2>/dev/null
pkill -9 cava 2>/dev/null
sleep 0.5

# 5. 创建CAVA FIFO
echo "设置CAVA..."
rm -f /tmp/cava.fifo 2>/dev/null
mkfifo /tmp/cava.fifo
chmod 600 /tmp/cava.fifo

# 6. 启动waybar（确保没有DISPLAY变量干扰）
echo "启动waybar..."
# 使用env命令清除所有X11相关变量
env -u DISPLAY -u XAUTHORITY waybar 2>&1 | tee /tmp/waybar.log &
WAYBAR_PID=$!

# 7. 检查启动状态
sleep 2
if ps -p $WAYBAR_PID > /dev/null; then
    echo "✓ Waybar启动成功! PID: $WAYBAR_PID"
    
    # 等待并显示日志
    sleep 1
    echo "=== Waybar日志前5行 ==="
    tail -n 5 /tmp/waybar.log 2>/dev/null || echo "无日志输出"
else
    echo "✗ Waybar启动失败!"
    echo "=== 最后10行日志 ==="
    tail -n 10 /tmp/waybar.log 2>/dev/null
    
    echo "=== 调试信息 ==="
    echo "当前用户: $(whoami)"
    echo "会话类型: $XDG_SESSION_TYPE"
    echo "Wayland显示: $WAYLAND_DISPLAY"
    echo "Hyprland签名: $HYPRLAND_INSTANCE_SIGNATURE"
    
    # 尝试使用不同的方法启动
    echo "尝试替代启动方法..."
    
    # 方法1: 直接使用wayland显示
    echo "尝试方法1: 直接启动"
    waybar 2>&1 | tee /tmp/waybar2.log &
    sleep 2
fi
