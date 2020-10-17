#!/bin/bash

id="$(id -u "$USER")" || exit
[ "$id" -eq 0 ] && exit

echo Installing void packages
xbps-install -Suy void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree
xbps-install -Suy $(< xbps-pkgs.txt)

echo Creating runit service symlinks
ln -st /var/service /etc/sv/{NetworkManager,bluetoothd,chronyd,dbus,elogind}

sudo -u "$USER" bash install_user.sh

echo Creating symlinks
src="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/src"
while IFS=" " read -r file d; do
    dir="$(eval echo "$d")"
    if [ -n "$file" ] && [ -n "$dir" ]; then
        [ -f "$dir/$file" ] && rm "$dir/$file"
        if [[ "$d" == ~* ]]; then
            [ ! -d "$dir" ] && sudo -u "$USER" mkdir -p "$dir"
            sudo -u "$USER" ln -s "$src/$file" -t "$dir"
        else
            [ ! -d "$dir" ] && mkdir -p "$dir"
            ln -s "$src/$file" -t "$dir"
        fi
    fi
done < symlinks.txt

echo Creating xsync
echo -e "#!/bin/sh\nxbps-install -S" > /usr/local/bin/xsync
chmod +x /usr/local/bin/xsync

echo Editing sudoers file
echo "%wheel ALL=(ALL) NOPASSWD: /bin/init, /usr/local/bin/xsync" >> /etc/sudoers

echo Caching font information
sudo -u "$USER" fc-cache
