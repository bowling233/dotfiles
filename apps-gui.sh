#!/bin/bash
set -x
trap 'exit 130' INT

if [ "$EUID" -eq 0 ]; then
        echo "Do not run as root"
        exit 1
fi

PREREQ=(
        curl wget jq
        flatpak pipx
        gnome-tweaks
        fcitx5 fcitx5-chinese-addons
)

alias wget='wget -q'

FLATPAK_PKGS=(
        com.qq.QQ
        # com.microsoft.Edge
        net.agalwood.Motrix
        com.tencent.WeChat
        com.qq.QQmusic
)

GNOME_EXTS=(
        kimpanel@kde.org              # https://extensions.gnome.org/extension/261/kimpanel/
        dash-to-dock@micxgx.gmail.com # https://extensions.gnome.org/extension/307/dash-to-dock/
)

sudo apt-get install -y "${PREREQ[@]}" >/dev/null

install_deb_from_url() {
        url=$1
        tmpfile=$(mktemp).deb
        if ! wget -O "$tmpfile" "$url"; then
                echo "Failed to download $url"
                exit 1
        fi
        sudo dpkg -i "$tmpfile"
        rm "$tmpfile"
}

# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8
install_deb_from_github() {
        repo=$1
        match=$2
        url=$(curl --silent "https://api.github.com/repos/$repo/releases/latest" | jq -r ".assets[] | select(.name|match(\"$match\")) | .browser_download_url")
        install_deb_from_url "$url"
}

# https://superuser.com/questions/1224532/get-links-from-an-html-page
#install_deb_from_href() {
#        link=$1
#        match=$2
#        url=$(lynx -listonly -nonumbers -dump "$link" | grep "$match")
#        install_deb_from_url "$url"
#}

#############
# microsoft #
#############
# now use flatpak
# Microsoft Edge
if ! command -v microsoft-edge &>/dev/null; then
        echo "Installing Microsoft Edge"
        install_deb_from_url 'https://go.microsoft.com/fwlink?linkid=2149051'
fi
## Visual Studio Code
if ! command -v code &>/dev/null; then
        echo "Installing Visual Studio Code"
        install_deb_from_url 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
fi

##########
# Others #
##########

# Tabby
if ! command -v tabby &>/dev/null; then
        echo "Installing Tabby"
        install_deb_from_github 'Eugeny/tabby' 'amd64.deb'
fi
# Dingtalk
if ! dpkg -l | grep --quiet com.alibabainc.dingtalk; then
        echo "Installing Dingtalk"
        install_deb_from_url 'https://www.dingtalk.com/win/d/qd=linux_amd64'
fi

# Motrix
#        install_deb_from_github 'agalwood/Motrix' 'amd64.deb'
# QQ
#        url=$(curl -s https://cdn-go.cn/qq-web/im.qq.com_new/latest/rainbow/linuxQQDownload.js | grep -oP '"x64DownloadUrl":\{"deb":"\K[^"]+')
#        install_deb_from_url "$url"

###########
# Flatpak #
###########

for i in "${FLATPAK_PKGS[@]}"; do
        if flatpak list | grep --quiet "$i"; then
                continue
        else
                echo "Installing $i"
                flatpak install -y flathub "$i"
        fi
done

#########
# gnome #
#########

pipx --quiet install gnome-extensions-cli --system-site-packages

for i in "${GNOME_EXTS[@]}"; do
        if gnome-extensions list | grep --quiet "$i"; then
                continue
        else
                echo "Enabling $i"
                gext install "$i"
        fi
done

##########
# fcitx5 #
##########

# auto start, can be set in gnome-tweaks
if [[ ! -d ~/.config/autostart ]]; then
        mkdir -p ~/.config/autostart
fi

if [[ ! -f ~/.config/autostart/org.fcitx.Fcitx5.desktop ]]; then
        cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/
fi

# dicts
tmpdir=$(mktemp -d)
declare -A DICTS_MATCH=(
        [felixonmars/fcitx5-pinyin-zhwiki]='endswith(".dict")'
        [outloudvi/mw2fcitx]='endswith(".dict")'
        [wuhgit/CustomPinyinDictionary]='endswith(".tar.gz")'
)
for i in "${!DICTS_MATCH[@]}"; do
        url=$(curl --silent "https://api.github.com/repos/$i/releases/latest" | jq -r ".assets[] | select(.name|${DICTS_MATCH[$i]}) | .browser_download_url")
        readarray -t urls <<<"$url"
        wget -qP "$tmpdir" "${urls[-1]}"
done
# untar gzip file
for i in "$tmpdir"/*.tar.gz; do
        tar -C "$tmpdir" -xzf "$i"
done
if [[ ! -d ~/.local/share/fcitx5/pinyin/dictionaries ]]; then
        mkdir -p ~/.local/share/fcitx5/pinyin/dictionaries
fi
cp -r "$tmpdir"/*.dict ~/.local/share/fcitx5/pinyin/dictionaries/
rm -r "$tmpdir"
