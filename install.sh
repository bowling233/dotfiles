#! /usr/bin/bash
echo '+ Installing vim-plug'
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo '+ Installing yarn'
sudo apt install npm
npm install --global yarn
yarn --version
echo '+ Installing YCM'
sudo apt install python3 python3-pip python-is-python3 
sudo apt install build-essential cmake vim-nox python3-dev
sudo apt install mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
pip install --user cmake
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all
vim -c ':PlugInstall' -c ':PlugStatus' -c 'qa!'

echo '+ Installing oh-my-zsh'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo '+ Installing powerlevel10k'
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo '+ Installing zsh-autosuggestions'
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
