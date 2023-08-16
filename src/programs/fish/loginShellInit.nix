{ config, pkgs, root }:

with pkgs;

''
  if not set -q DISPLAY && [ (${coreutils}/bin/tty) = /dev/tty1 ]
    exec ${
      sx.override {
        xorg = xorg // {
          xorgserver = writers.writeDashBin "Xorg" ''
            exec ${xorg.xorgserver}/bin/Xorg -ardelay 320 -arinterval 32 "$@"
          '';
        };
      }
    }/bin/sx ${
      writers.writeDash "sxrc" ''
        CM_MAX_CLIPS=100 CM_SELECTIONS=clipboard ${clipmenu}/bin/clipmenud &
        ${element-desktop}/bin/element-desktop --hidden &
        ${config.i18n.inputMethod.package}/bin/fcitx5 &
        ${mpd}/bin/mpd ${writeText "mpd.conf" ''
          music_directory "~/music"
          db_file "~/.local/share/mpd/mpd.db"
          pid_file "~/.local/share/mpd/mpd.pid"
          state_file "~/.local/share/mpd/mpdstate"
          bind_to_address "127.0.0.1"
          restore_paused "yes"
          audio_output {
              type "pipewire"
              name "mpd"
          }
        ''} &
        ${networkmanagerapplet}/bin/nm-applet &
        ${picom}/bin/picom &
        ${spaceFM}/bin/spacefm -d &
        ${unclutter-xfixes}/bin/unclutter --timeout 3 &
        ${volctl}/bin/volctl &
        ${xdg-user-dirs}/bin/xdg-user-dirs-update &
        ${xss-lock}/bin/xss-lock --ignore-sleep ${root.pkgs.lockscreen}/bin/lockscreen &
        exec ${config.services.xserver.windowManager.awesome.package}/bin/awesome
      ''
    }
  end
''
