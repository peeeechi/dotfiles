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

./link.sh
