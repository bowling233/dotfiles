
SRC=(
        '.vimrc',
        '.bashrc',
        '.zshrc',
        '.p10k.zsh',
        'config.fish'
)

DST=(
        '~/.vimrc',
        '~/.bashrc',
        '~/.zshrc',
        '~/.p10k.zsh',
        '~/.config/fish/config.fish'
)

for i in ${!SRC[@]}; do
        # check if file exists
        if [ -f ${DST[$i]} ]; then
                echo "File ${DST[$i]} exists, moving to ${DST[$i]}.bak"
                mv ${DST[$i]} ${DST[$i]}.bak
        fi
        echo "Linking ${SRC[$i]} to ${DST[$i]}"
        ln ${SRC[$i]} ${DST[$i]}
done
