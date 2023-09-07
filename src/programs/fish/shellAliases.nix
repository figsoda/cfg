{ pkgs }:

let
  inherit (pkgs) coreutils eza;
in

{
  cp = "${coreutils}/bin/cp -ir";
  ls = "${eza}/bin/eza -bl --git --icons --time-style long-iso --group-directories-first";
  mv = "${coreutils}/bin/mv -i";
  rm = "${coreutils}/bin/rm -I";
}
