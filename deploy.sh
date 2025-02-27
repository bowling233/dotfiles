#!/bin/bash
set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR" || exit

. common.sh

# bash provides $OSTYPE
case "$OSTYPE" in
linux-gnu*)
	# shellcheck disable=SC1091
	# os-release provides $ID
	. /etc/os-release
	;;
darwin*)
	ID=macos
	;;
*)
	print_error "Unsupported OS"
	exit 1
	;;
esac
print_info "OS: $ID"

PREREQ=(
	zsh tmux curl git git-extras zoxide eza
)

# choose package manager
case $ID in
ubuntu | debian)
	alias pkg_install="sudo apt-get update && sudo apt-get install -y"
	;;
macos)
	# check if brew is installed
	if ! command -v brew &>/dev/null; then
		print_error "Homebrew is not installed"
		exit 1
	fi
	alias pkg_install="brew install"
	;;
*)
	print_error "Unsupported OS"
	exit 1
	;;
esac

for i in "${PREREQ[@]}"; do
	if ! command -v "$i" &>/dev/null; then
		print_info "Installing $i"
		pkg_install "$i" || true
	fi
done

case "$OSTYPE" in
linux-gnu*)
	if ! getent passwd "$(whoami)" | grep -q "$(which zsh)"; then
		print_info "+ Changing default shell to zsh"
		chsh -s "$(which zsh)"
	fi
	;;
darwin*)
	# zsh is default shell on macOS
	;;
esac

# oh-my-zsh, themes, plugins
if [ ! -e ~/.oh-my-zsh/oh-my-zsh.sh ]; then
	print_info "+ Installing oh-my-zsh"
	rm -rf ~/.oh-my-zsh
	sh -c "$(curl -fsSL https://install.ohmyz.sh)" "" --unattended
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
	print_info "+ Installing powerlevel10k"
	git clone https://gitee.com/romkatv/powerlevel10k.git \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode" ]; then
	print_info "+ Installing zsh-vi-mode"
	git clone https://github.com/jeffreytse/zsh-vi-mode \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	print_info "+ Installing zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
	print_info "+ Installing zsh-syntax-highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/autoupdate" ]; then
	print_info "+ Installing autoupdate"
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
		print_warning "File ${DST[$i]} exists, moving to ${DST[$i]}.bak"
		mv "${DST[$i]}" "${DST[$i]}".bak
	fi
	# if [ ! -d "$(dirname "${DST[$i]}")" ]; then
	# 	print_info "Creating directory $(dirname "${DST[$i]}")"
	# 	mkdir -p "$(dirname "${DST[$i]}")"
	# fi
	print_info "+ Linking ${SRC[$i]} to ${DST[$i]}"
	ln -sf "${SRC[$i]}" "${DST[$i]}"
done

# add crontab to git -C "$SCRIPT_DIR" pull
if ! crontab -l | grep -q "git -C $SCRIPT_DIR pull"; then
	print_info "+ Adding crontab to git pull"
	(
		crontab -l 2>/dev/null
		echo "0 0 * * * git -C $SCRIPT_DIR pull"
	) | crontab -
fi
