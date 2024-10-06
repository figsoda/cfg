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
  xrandrHeads = [
    {
      output = "eDP-2";
      monitorConfig = ''
        DisplaySize 302 189
      '';
    }
  ];
}
