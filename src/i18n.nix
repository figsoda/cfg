{ pkgs }:

{
  inputMethod = {
    enable = true;
    fcitx5.addons = [ pkgs.fcitx5-rime ];
    type = "fcitx5";
  };
  supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}
