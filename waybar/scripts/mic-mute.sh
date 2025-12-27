#!/usr/bin/env bash
if pactl get-source-mute @DEFAULT_SOURCE@ | grep -qi yes; then
    echo '{"text":"󰍭","class":"muted","tooltip":"麦克风已静音"}'
else
    echo '{"text":"󰍬","class":"unmuted","tooltip":"麦克风已启用"}'
fi
