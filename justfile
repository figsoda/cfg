rebuild:
    nixfmt configuration.nix
    sudo cp configuration.nix /etc/nixos/
    sudo nixos-rebuild switch
