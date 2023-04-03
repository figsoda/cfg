{ pkgs }:

{
  cleanTmpDir = true;
  kernelPackages = pkgs.linuxPackages_latest;
  loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
    };
  };
}
