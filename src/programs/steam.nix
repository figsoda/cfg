{ pkgs }:

{
  enable = true;
  package = pkgs.steam.override {
    extraProfile = ''
      unset TZ
      source nvidia-offload
    '';
  };
}
