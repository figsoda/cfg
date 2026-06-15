{ pkgs }:

{
  enable = true;
  package = pkgs.steam.override {
    extraProfile = ''
      unset TZ
      (set --; source nvidia-offload)
    '';
  };
}
