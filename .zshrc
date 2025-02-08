source ~/.bowlingrc
# zmodload zsh/zprof

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode auto
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# make git status faster
DISABLE_UNTRACKED_FILES_DIRTY="true"

# omz plugin info *
# git-extras gitfast git-flow git-flow-avh git-hubflow git-remote-branch
plugins+=(git)
# (colors)
plugins+=(colored-man-pages colorize)
# (misc)
plugins+=(command-not-found copyfile copypath rand-quote)
# e64 d64 ef64
plugins+=(encode64)
# cpv (progress bar, use rsync)
plugins+=(cp)
# x (archive extracting)
plugins+=(extract)
# h hs hsi (history with grep)
plugins+=(history)
# ta ts tkss tl (tmux)
plugins+=(tmux)
# urlencode urldecode
plugins+=(urltools)
# gi list (fetch from gitignore.io)
plugins+=(gitignore)
# sc-* (systemd)
plugins+=(systemd)
# zoxide
plugins+=(zoxide)
# need installation
plugins+=(autoupdate zsh-vi-mode zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
# speed up by cache per day
# https://medium.com/@dannysmith/little-thing-2-speeding-up-zsh-f1860390f92
#autoload -Uz compinit
#for dump in ~/.zcompdump(N.mh+24); do
#  compinit
#done
#compinit -C

# remove bunch of zcompdump file
# https://www.reddit.com/r/zsh/comments/fqpidr/removing_zcompdump_file_creation/
local -r cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
zstyle ':completion:*' cache-path $cache_dir/.zcompcache
compinit -C -d $cache_dir/.zcompdump

# https://gist.github.com/AppleBoiy/04a249b6f64fd0fe1744aff759a0563b
if command -v eza > /dev/null; then
	alias ls='eza'
	alias l='eza -lbF --git'
	alias ll='eza -lbGF --git'
	alias llm='eza -lbGd --git --sort=modified'
	alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale'
	alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'

	# specialty views
	alias lS='eza -1'
	alias lt='eza --tree --level=2'
	alias l.="eza -a | grep -E '^\.'"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# conda
if [ -d "/opt/conda" ]; then
  CONDA_ROOT="/opt/conda"
elif [ -d "$HOME/conda" ]; then
  CONDA_ROOT="$HOME/conda"
fi

__conda_setup="$("$CONDA_ROOT/conda" 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
    . "$CONDA_ROOT/etc/profile.d/conda.sh"
  else
    export PATH="$CONDA_ROOT/bin:$PATH"
  fi
fi
unset __conda_setup
unset CONDA_ROOT

# homebrew
if [ -d "/opt/homebrew" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
fi

# flutter
if [ -d "$HOME/development/flutter" ]; then
  export PATH="$PATH:$HOME/development/flutter/bin"
  export PUB_HOSTED_URL="https://pub.flutter-io.cn"
  export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
fi

# ruby
if [ -d "/opt/homebrew/opt/ruby" ]; then
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
  # gem
  export GEM_HOME=$HOME/.gem
  export PATH=$GEM_HOME/bin:$PATH
fi

# zprof > /tmp/zprof
