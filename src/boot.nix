{ pkgs }:

{
  loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
    };
  };
  tmp.cleanOnBoot = true;
}
