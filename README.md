# cfg

NixOS configuration featuring [awesome](https://github.com/awesomewm/awesome) and [neovim](https://github.com/neovim/neovim)

![](https://user-images.githubusercontent.com/40620903/232329160-f3b4ff47-185a-4b4b-ad5f-ad1720e2dbc9.png)

## Installation

```ShellSession
# mount /dev/disk/by-label/nixos /mnt
# mkdir /mnt/boot
# mount -o umask=077 /dev/disk/by-label/BOOT /mnt/boot
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
