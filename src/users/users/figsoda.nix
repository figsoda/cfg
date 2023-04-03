{ pkgs }:

{
  extraGroups = [ "audio" "networkmanager" "podman" "video" "wheel" ];
  isNormalUser = true;
  shell = pkgs.fish;
}
