# dotfiles

My dotfiles (nixos + awesome)


## Installation

```sh
# as root, after partitioning
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --update
nixos-generate-config --root /mnt
curl -LSso /mnt/etc/nixos/configuration.nix https://raw.githubusercontent.com/figsoda/dotfiles/main/configuration.nix
nixos-install
reboot

# as root
passwd <username>

# as user
git clone https://github.com/figsoda/dotfiles
dotfiles/install
```
