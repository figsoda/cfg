{ pkgs }:

pkgs.writers.writeBashBin "session-menu" ''
  set -e

  option=$(echo -n "1 ⏼  sleep,2 ⏻  poweroff,3   reboot,4   quit,5 󰌾  lock" \
    | rofi -dmenu -sep , -p session -format i -no-custom -select 5)

  case "$option" in
    0) systemctl suspend;;
    1) poweroff;;
    2) reboot;;
    3) niri msg action quit -s;;
    4) hyprlock;;
  esac
''
