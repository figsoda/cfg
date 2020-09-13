default: update clean

alias c := clean
clean:
    sudo vkpurge rm all
    sudo xbps-remove -Ooy
    flatpak uninstall --unused -y

sv service:
    sudo ln -s /etc/sv/{{service}} /var/service/

alias u := update
update:
    sudo xbps-install -Suy
    flatpak update -y
    rustup update
    cargo install-update -a
