{ config, lib, pkgs, root }:

let
  inherit (lib) getExe;
in

with pkgs;

/* fish */ ''
  if [ (${coreutils}/bin/tty) = /dev/tty1 ]
    exec ${config.programs.niri.package}/bin/niri-session -l
  end
''
