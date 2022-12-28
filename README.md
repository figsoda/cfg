# cfg

NixOS configuration featuring [awesome](https://github.com/awesomewm/awesome) and [neovim](https://github.com/neovim/neovim)


## Installation

```ShellSession
# mount /dev/disk/by-label/nixos /mnt
# mkdir /mnt/boot
# mount /dev/disk/by-label/BOOT /mnt/boot
# swapon /dev/disk/by-label/swap
# nixos-generate-config --root /mnt
# rm /mnt/etc/nixos/configuration.nix
# git clone https://github.com/figsoda/cfg
# cp -r cfg/{src,flake.*} /mnt/etc/nixos
# nixos-install --flake /mnt/etc/nixos#nixos --no-channel-copy
# reboot

# passwd figsoda

$ git clone https://github.com/figsoda/cfg
$ cfg/install
$ secret-tool store github git --label github-token
```
