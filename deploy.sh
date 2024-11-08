#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

SRC=(
        "$SCRIPT_DIR/.bowlingrc"
        "$SCRIPT_DIR/.vimrc"
        "$SCRIPT_DIR/.bashrc"
        "$SCRIPT_DIR/.zshrc"
        "$SCRIPT_DIR/.p10k.zsh"
        "$SCRIPT_DIR/config.fish"
)

DST=(
        "$HOME/.bowlingrc"
        "$HOME/.vimrc"
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
        "$HOME/.config/fish/config.fish"
)

for i in ${!SRC[@]}; do
        if [ -f ${DST[$i]} ]; then
                echo "File ${DST[$i]} exists, moving to ${DST[$i]}.bak"
                mv ${DST[$i]} ${DST[$i]}.bak
        fi
        if [ ! -d $(dirname ${DST[$i]}) ]; then
                echo "Creating directory $(dirname ${DST[$i]})"
                mkdir -p $(dirname ${DST[$i]})
        fi
        echo "Linking ${SRC[$i]} to ${DST[$i]}"
        ln -sf ${SRC[$i]} ${DST[$i]}
done
