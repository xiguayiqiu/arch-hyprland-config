#!/bin/bash

# CAVA启动脚本
FIFO="/tmp/cava.fifo"

# 如果fifo不存在则创建
[ -p "$FIFO" ] || mkfifo "$FIFO"

# 启动cava（后台运行）
cava -p ~/.config/cava/config &

# 等待cava启动
sleep 0.5

# 读取fifo并输出给waybar
while true; do
    if [ -p "$FIFO" ]; then
        # 读取一行数据（16个数值）
        if read -r line < "$FIFO"; then
            # 将数值转换为Unicode柱状图
            bars=""
            for value in $line; do
                # 将0-65535的数值转换为0-8的高度
                height=$(( (value * 8) / 65535 ))
                case $height in
                    0) bars="${bars}▁";;
                    1) bars="${bars}▂";;
                    2) bars="${bars}▃";;
                    3) bars="${bars}▄";;
                    4) bars="${bars}▅";;
                    5) bars="${bars}▆";;
                    6) bars="${bars}▇";;
                    7|8) bars="${bars}█";;
                    *) bars="${bars} ";;
                esac
            done
            echo "{\"text\":\"$bars\",\"tooltip\":\"音频可视化\"}"
        fi
    else
        sleep 1
    fi
done
