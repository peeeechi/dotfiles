#/bin/bash -eu
cd $(dirname $0)
source ./util.sh
this_dir=$(pwd)
sudo apt-get update

if ! command -v fzf &> /dev/null
then
    echo "install fzf"
    git clone https://github.com/junegunn/fzf.git ~/.fzf
    yes | ~/.fzf/install
fi

if ! command -v xclip &> /dev/null
then
    echo "install xclip"
    sudo apt-get install -y xclip
fi

if ! command -v vim &> /dev/null
then
    echo "install vim"
    sudo apt-get install -y vim
fi

if ! command -v nvim &> /dev/null
then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod +x nvim.appimage
    src=$this_dir/squashfs-root/AppRun
    dst=/usr/bin/nvim
    ./nvim.appimage --appimage-extract
    link_data $src $dst
fi

./link.sh
