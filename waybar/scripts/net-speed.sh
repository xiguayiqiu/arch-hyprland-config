#!/usr/bin/env bash
# 自动单位换算版本
iface=$(ip route | awk '$1=="default"{print $5; exit}')
read -r rx < "/sys/class/net/$iface/statistics/rx_bytes"
read -r tx < "/sys/class/net/$iface/statistics/tx_bytes"

sleep 1

read -r rx2 < "/sys/class/net/$iface/statistics/rx_bytes"
read -r tx2 < "/sys/class/net/$iface/statistics/tx_bytes"

# 计算字节差值
dx=$((rx2 - rx))
tx=$((tx2 - tx))

# 换算函数：输入字节数，输出「带单位字符串」
human() {
    local bytes=$1
    if (( bytes < 1048576 )); then          # < 1 MB
        awk -v b="$bytes" 'BEGIN{printf "%.1f", b/1024}' | sed 's/$/ KB/'
    elif (( bytes < 1073741824 )); then     # < 1 GB
        awk -v b="$bytes" 'BEGIN{printf "%.1f", b/1048576}' | sed 's/$/ MB/'
    else                                    # ≥ 1 GB
        awk -v b="$bytes" 'BEGIN{printf "%.2f", b/1073741824}' | sed 's/$/ GB/'
    fi
}

down=$(human "$dx")
up=$(human "$tx")

# waybar 需要的 JSON
printf '{"text":"%s %s", "tooltip":"↓ %s  ↑ %s"}\n' "$down" "$up" "$down" "$up"
