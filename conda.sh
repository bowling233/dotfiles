#!/bin/bash
set -x

MIRROR="https://mirrors.zju.edu.cn/anaconda/"
FILEPATH="miniconda/Miniconda3-latest-Linux-x86_64.sh"

if command -v conda &>/dev/null; then
        echo "Conda already installed"
        exit 1
fi

if [ -d "$HOME/miniconda" ]; then
        echo "Miniconda already installed"
        exit 1
fi

if [ "$EUID" -eq 0 ]; then
        echo "Do not run as root"
        exit 1
fi

tmpfile=$(mktemp).sh
if ! wget -qO "$tmpfile" "$MIRROR$FILEPATH"; then
        echo "Failed to download $MIRROR$PATH"
        exit 1
fi

bash "$tmpfile" -b -p "$HOME/miniconda"

rm "$tmpfile"

if [ -f "$HOME"/.condarc ]; then
        echo "File $HOME/.condarc exists, moving to $HOME/.condarc.bak"
        mv "$HOME"/.condarc "$HOME"/.condarc.bak
fi

cat >> "$HOME"/.condarc <<EOF
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.zju.edu.cn/anaconda/pkgs/main
  - https://mirrors.zju.edu.cn/anaconda/pkgs/r
  - https://mirrors.zju.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.zju.edu.cn/anaconda/cloud
  msys2: https://mirrors.zju.edu.cn/anaconda/cloud
  bioconda: https://mirrors.zju.edu.cn/anaconda/cloud
  menpo: https://mirrors.zju.edu.cn/anaconda/cloud
  pytorch: https://mirrors.zju.edu.cn/anaconda/cloud
  pytorch-lts: https://mirrors.zju.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.zju.edu.cn/anaconda/cloud
  nvidia: https://mirrors.zju.edu.cn/anaconda-r
EOF
