{ pkgs }:

pkgs.writers.writeBashBin "session-menu" ''
  set -e

  option=$(rofi -dmenu -sep , -p session -format i -no-custom -select 5 \
    <<< "1 ⏼  sleep,2 ⏻  poweroff,3   reboot,4   quit,5 󰌾  lock")

  case "$option" in
    0) systemctl suspend;;
    1) poweroff;;
    2) reboot;;
    3) niri msg action quit -s;;
    4) hyprlock;;
  esac
''
