#!/bin/bash
set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR" || exit

PREREQ=(
	zsh tmux curl git zoxide
)

for i in "${PREREQ[@]}"; do
	if ! command -v "$i" &>/dev/null; then
		echo "+ Installing $i"
		sudo apt install -y "$i"
	fi
done

if ! getent passwd "$(whoami)" | grep -q "$(which zsh)"; then
	echo "+ Changing default shell to zsh"
	chsh -s "$(which zsh)"
fi

# oh-my-zsh, themes, plugins
if [ ! -e ~/.oh-my-zsh/oh-my-zsh.sh ]; then
	echo "+ Installing oh-my-zsh"
	rm -rf ~/.oh-my-zsh
	sh -c "$(curl -fsSL https://install.ohmyz.sh)" "" --unattended
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
	echo "+ Installing powerlevel10k"
	git clone https://gitee.com/romkatv/powerlevel10k.git \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode" ]; then
	echo "+ Installing zsh-vi-mode"
	git clone https://github.com/jeffreytse/zsh-vi-mode \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	echo "+ Installing zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
	echo "+ Installing zsh-syntax-highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/autoupdate" ]; then
	echo "+ Installing autoupdate"
	git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/autoupdate"
fi

# link dotfiles
SRC=(
	"$SCRIPT_DIR/.bowlingrc"
	"$SCRIPT_DIR/.vimrc"
	"$SCRIPT_DIR/.zshrc"
	"$SCRIPT_DIR/.p10k.zsh"
	"$SCRIPT_DIR/.gitconfig"
)

DST=(
	"$HOME/.bowlingrc"
	"$HOME/.vimrc"
	"$HOME/.zshrc"
	"$HOME/.p10k.zsh"
	"$HOME/.gitconfig"
)

for i in "${!SRC[@]}"; do
	if [ -e "${DST[$i]}" ] && [ ! -L "${DST[$i]}" ]; then
		echo "File ${DST[$i]} exists, moving to ${DST[$i]}.bak"
		mv "${DST[$i]}" "${DST[$i]}".bak
	fi
	# if [ ! -d "$(dirname "${DST[$i]}")" ]; then
	# 	echo "Creating directory $(dirname "${DST[$i]}")"
	# 	mkdir -p "$(dirname "${DST[$i]}")"
	# fi
	echo "+ Linking ${SRC[$i]} to ${DST[$i]}"
	ln -sf "${SRC[$i]}" "${DST[$i]}"
done
