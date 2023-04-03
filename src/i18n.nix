{ pkgs }:

{
  inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-rime ];
  };
  supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}
