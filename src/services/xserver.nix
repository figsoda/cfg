{ pkgs }:

let
  inherit (pkgs) awesome luajit;
in

{
  enable = true;
  displayManager.sx.enable = true;
  libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
      middleEmulation = false;
    };
    touchpad = {
      accelProfile = "flat";
      accelSpeed = "0";
    };
  };
  windowManager.awesome = {
    enable = true;
    noArgb = true;
    package = awesome.override {
      lua = luajit;
    };
  };
  xkbOptions = "ctrl:nocaps";
}
