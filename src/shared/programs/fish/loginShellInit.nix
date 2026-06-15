{
  config,
  pkgs,
}:

/* fish */ ''
  if [ (${pkgs.coreutils}/bin/tty) = /dev/tty1 ]
    exec ${config.programs.niri.package}/bin/niri-session -l
  end
''
