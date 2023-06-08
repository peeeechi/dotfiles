#/bin/bash -eu
cd $0
this_dir=$(pwd)
# sudo apt-get update

if ! command -v fzf &> /dev/null
then
    echo "install fzf"
    git clone https://github.com/junegunn/fzf.git ~/.fzf
    yes | ~/.fzf/install
fi

if ! command -v xclip &> /dev/null
then
    echo "install xclip"
    sudo apt install -y xclip
fi

if ! command -v vim &> /dev/null
then
    echo "install vim"
    sudo apt install -y vim
fi

if ! command -v nvim &> /dev/null
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod +x nvim.appimage
    ./nvim.appimage --appimage-extract
    ln -s /squashfs-root/AppRun /usr/bin/nvim
fi

./link.sh
