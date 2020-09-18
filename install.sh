#!/bin/bash

src="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/src"

while IFS=" " read -r file dir sudo; do
    dir="$(eval echo "$dir")"
    if [ -n "$file" ] && [ -n "$dir" ]; then
        [ -f "$dir/$file" ] && $sudo rm "$dir/$file"
        [ ! -d "$dir" ] && $sudo mkdir -p "$dir"
        $sudo ln -s "$src/$file" -t "$dir"
    fi
done < symlinks.txt
