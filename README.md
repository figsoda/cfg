# dotfiles

My dotfiles (nixos + awesome)


## Installation

```sh
# as root, after partitioning
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap
nixos-generate-config --root /mnt
cd /mnt/etc/nixos
curl -LSso flake.nix https://raw.githubusercontent.com/figsoda/dotfiles/main/flake.nix
curl -LSso flake.lock https://raw.githubusercontent.com/figsoda/dotfiles/main/flake.lock
nixos-install --flake ".#nixos" --no-channel-copy
reboot

# as root
passwd <username>

# as user
git clone https://github.com/figsoda/dotfiles
sudo ln -sft /etc/nixos ~/dotfiles/flake.{lock,nix}
dotfiles/install
mkdir -p ~/.config/secrets
micro github_token
openssl aes-256-cbc -in github_token -out ~/.config/secrets/github
shred -u github_token
```
