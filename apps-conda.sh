#!/bin/bash
set -x

CONDA_PATH=/opt/conda
MIRROR="https://mirrors.zju.edu.cn/anaconda/miniconda/"
# if is macos
if [ "$(uname)" == "Darwin" ]; then
	FILEPATH="Miniconda3-latest-MacOSX-x86_64.sh"
elif [ "$(uname)" == "Linux" ]; then
	FILEPATH="Miniconda3-latest-Linux-x86_64.sh"
else
	echo "Unsupported OS"
	exit 1
fi

if command -v conda &>/dev/null; then
        echo "Conda already installed"
        exit 1
fi

if [ -d "$CONDA_PATH" ]; then
        echo "Directory $CONDA_PATH exists, please check if conda is installed"
        exit 1
fi

tmpfile=$(mktemp -u).sh
if ! wget -O "$tmpfile" "$MIRROR$FILEPATH"; then
        echo "Failed to download $MIRROR$FILEPATH"
        exit 1
fi

bash "$tmpfile" -b -p "$CONDA_PATH"

rm "$tmpfile"

cat > "$CONDA_PATH"/.condarc <<EOF
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
