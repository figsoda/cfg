{ pkgs }:
{
  command-not-found.enable = false;

  dconf.enable = true;

  steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        unset TZ
        source nvidia-offload
      '';
    };
  };
}
