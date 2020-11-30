default: rebuild

luafmt:
    ~/LuaFormatter/lua-format -c.lua-format -i src/awesome/*.lua

rebuild:
    sudo cp configuration.nix /etc/nixos/
    sudo nixos-rebuild switch
