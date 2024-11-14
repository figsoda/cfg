{ config, lib, pkgs, root }:

let
  inherit (lib) getExe;
in

with pkgs;

/* fish */ ''
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
        ${config.services.asusd.package}/bin/asusctl profile -P Performance &
        CM_MAX_CLIPS=100 CM_SELECTIONS=clipboard ${clipmenu}/bin/clipmenud &
        ${getExe element-desktop} --hidden &
        ${getExe config.i18n.inputMethod.package} &
        ${getExe mpd} ${writeText "mpd.conf" ''
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
        ${getExe networkmanagerapplet} &
        ${getExe picom} --backend glx &
        ${spaceFM}/bin/spacefm -d &
        ${getExe unclutter-xfixes} --timeout 3 &
        ${getExe volctl} &
        ${getExe xdg-user-dirs} &
        ${getExe xss-lock} --ignore-sleep ${root.pkgs.lockscreen}/bin/lockscreen &
        exec ${config.services.xserver.windowManager.awesome.package}/bin/awesome
      ''
    }
  end
''
