# 项目介绍
本项目是一个可以直接使用的一个hyprland配置，只需要将内容复制到`~/.config/`即可
## 依赖配置
```
sudo pacman -Syu;sudo pacman -S hyprland alacritty mako networkmanager waybar swaybg copyq zsh thunar rofi hyprlock grim flameshot libnotify xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprpolkitagent qt5-wayland qt6-wayland
```
## 配置archcn源
- 在`/etc/pacman.conf`中的最后一行配置
```
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```
## 其他配置
- 配置屏幕
使用`hyprctl monitors all`查看您的显示器修改hyprland的显示器
```
实例：
vim ~/.config/hypr/hyprland.conf

monitor=eDP-1,2560x1440@165,0x0,1.6
```

`eDP-1`: 是您的显示其名字
`2560x1440@165`: 是您的显示器分辨率和刷新率的标准配置
`0x0`: 是坐标，建议使用`auto`参数
`1.6`: 是缩放率,标准屏幕建议`1.25`，2.5k和4k屏幕建议`1.5`

### 修复thunar的问题
- 通过链接修复即可
```
sudo ln -s /usr/bin/alacritty /usr/bin/gnome-terminal
```
- 使用上面的命令修复即可，将终端模拟器链接伪装成`gnome-terminal`即可
### 修复home目录下的目录
```
sudo pacman -S xdg-user-dirs
```
输入`xdg-user-dirs-update`即可更新home下的目录
### 蓝牙修复
```
sudo pacman -S --needed bluez blueman
```
```
sudo systemctl enable --now bluetooth
```
### 修复网络面板组件
```
sudo pacman -S network-manager-applet dnsmasq
```
### 安装yay助手
```
pacman -S yay
```
### 修复截图
```
yay -S gradia slurp grim
```
### 配置软件商店(可选)
```
sudo pacman -S gnome-software flatpak
```
- flatpak换源
```
#原版源
sudo flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
```
#国内源
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```
### 安装输入法
```
sudo pacman -S fcitx5 fcitx5-rime fcitx5-chinese-addons fcitx5-configtool
```
### 配置cava(可选)
```
sudo pacman -S cava
```

