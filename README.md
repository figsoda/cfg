# dotfiles

My dotfiles (nixos + awesome)


## Installation ([broken](https://github.com/NixOS/nix/issues/4081))

```sh
# as root, after partitioning
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
nixos-generate-config --root /mnt
rm /mnt/etc/nixos/configuration.nix
git clone https://github.com/figsoda/dotfiles
cp -r dotfiles/{lib,flake.*} /mnt/etc/nixos
nix-shell -p nixUnstable --run "nixos-install --flake /mnt/etc/nixos#nixos --no-channel-copy"
reboot

# as root
passwd nixos

# as user
git clone https://github.com/figsoda/dotfiles
dotfiles/install
mkdir -p ~/.config/secrets
openssl aes-256-cbc -in (read -sP "Enter secret: " | psub) -out ~/.config/secrets/github
```
