{ pkgs }:

let
  inherit (pkgs) awesome luajit;
in

{
  enable = true;
  displayManager.sx.enable = true;
  windowManager.awesome = {
    enable = true;
    noArgb = true;
    package = awesome.override {
      lua = luajit;
    };
  };
  xkb.options = "ctrl:nocaps";
}
