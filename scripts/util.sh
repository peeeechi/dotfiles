#! /bin/bash

link_data() {
    local src
    local dst
    src=$1
    dst=$2

    if [ -L ${dst} ]; then
        echo "$dst is exists.(link)"
        unlink ${dst}
    elif [ -e ${dst} ]; then
        echo "$dst is exists.(file)"
        mv "$dst" "${dst}.bak"
    fi
    ln -siv "${src}" "${dst}"
}