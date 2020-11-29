default: rebuild

luafmt:
    ~/LuaFormatter/lua-format -c.lua-format -i src/awesome/*.lua

nixfmt:
    nix-shell --run "nixfmt *.nix" -p nixfmt

rebuild:
    sudo cp configuration.nix /etc/nixos/
    sudo nixos-rebuild switch
