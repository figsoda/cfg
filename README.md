# dotfiles

My dotfiles (nixos + awesome)


## Installation (broken)

```sh
# as root, after partitioning
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
nixos-generate-config --root /mnt
git clone https://github.com/figsoda/dotfiles
nixos-install --flake "dotfiles#nixos" --no-channel-copy
reboot

# as root
passwd <username>

# as user
git clone https://github.com/figsoda/dotfiles
dotfiles/install
mkdir -p ~/.config/secrets
micro github_token
openssl aes-256-cbc -in github_token -out ~/.config/secrets/github
shred -u github_token
```
