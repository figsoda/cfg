{ pkgs }:

let
  inherit (pkgs) coreutils exa;
in

{
  cp = "${coreutils}/bin/cp -ir";
  ls = "${exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
  mv = "${coreutils}/bin/mv -i";
  rm = "${coreutils}/bin/rm -I";
}
