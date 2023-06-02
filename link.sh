#/bin/bash -eu
cd $0
this_dir=$(pwd)

targets=(
    ".bashrc" 
    ".bash_aliases" 
    ".vimrc" 
)

for target in ${targets[@]}; do
    # echo "$this_dir/dotfiles/$target"
    if [ -e ~/$target ]; then
        echo "~/$target is exists."
        mv "~/$target" "~/$target.bak"
    fi
    ln -siv "$this_dir/dotfiles/$target" "~/$target"
done