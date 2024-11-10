#!/bin/bash
#https://gist.github.com/incogbyte/373f37817742c53891a076391533fe6d

sudo apt install fontconfig
cd ~ || exit
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
mkdir -p .local/share/fonts
unzip Meslo.zip -d .local/share/fonts
cd .local/share/fonts || exit
rm -- *Windows*
cd ~ || exit
rm Meslo.zip
fc-cache -fv
