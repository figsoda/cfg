{ lib, pkgs }:

let
  inherit (lib) getExe;
  inherit (pkgs) writeText writers mpd;
in

writers.writeDashBin "mpd" ''
  mkdir -p ~/.local/share/mpd
  touch ~/.local/share/mpd/mpd.db
  exec ${getExe mpd} ${writeText "mpd.conf" ''
    auto_update "yes"
    bind_to_address "127.0.0.1"
    db_file "~/.local/share/mpd/mpd.db"
    music_directory "~/music"
    pid_file "~/.local/share/mpd/mpd.pid"
    restore_paused "yes"
    state_file "~/.local/share/mpd/mpdstate"
    audio_output {
      type "pipewire"
      name "mpd"
    }
  ''}
''
