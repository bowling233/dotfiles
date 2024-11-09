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
        "$SCRIPT_DIR/.gitconfig"
)

DST=(
        "$HOME/.bowlingrc"
        "$HOME/.vimrc"
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
        "$HOME/.config/fish/config.fish"
        "$HOME/.gitconfig"
)

if [ ! -e ~/.oh-my-zsh/oh-my-zsh.sh ]; then
        echo "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://install.ohmyz.sh)" "" --unattended
fi

for i in ${!SRC[@]}; do
        if [ -e ${DST[$i]} ] && [ ! -L ${DST[$i]} ]; then
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

git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull \
  || git clone https://gitee.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode pull \
  || git clone https://github.com/jeffreytse/zsh-vi-mode \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull \
  || git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull \
  || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
