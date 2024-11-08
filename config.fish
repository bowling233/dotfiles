source ~/.bowlingrc

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniconda3/bin/conda
    eval $HOME/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

# if eza is installed
if command -v eza > /dev/null
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
end

# Created by `pipx` on 2024-09-16 12:08:37
set PATH $PATH $HOME/.local/bin

# if spack is installed
if test -d /opt/spack
    source /opt/spack/share/spack/setup-env.fish
end
