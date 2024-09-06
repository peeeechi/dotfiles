#/bin/bash -eu
cd $(dirname $0)
source ./util.sh
this_dir=$(pwd)

targets=(
    ".bashrc" 
    ".bash_aliases" 
    ".vimrc" 
)

for target in ${targets[@]}; do
    src=$this_dir/dotfiles/$target
    dst=$HOME/$target
    link_data $src $dst
done

# nvim config
nvim_dir=".config/nvim"
src="$this_dir/dotfiles/$nvim_dir"
dst=$HOME/$nvim_dir

if [ -L $dst ]; then
    echo "$dst is exists.(Link)"
    unlink $dst
elif [ -d $dst ]; then
    echo "$dst is exists.(Dir)"
    mv "$dst" "${dst}.bak"
fi

if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
fi

ln -siv "$src" "$dst"
