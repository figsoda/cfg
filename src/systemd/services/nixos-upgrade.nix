{ config, lib, pkgs }:

{
  serviceConfig.WorkingDirectory = "/home/figsoda/cfg";
  script = lib.mkForce /* bash */ ''
    ${pkgs.coreutils}/bin/sleep 5
    /run/wrappers/bin/sudo -u figsoda \
      ${config.nix.package}/bin/nix flake update --commit-lock-file
    ${pkgs.coreutils}/bin/cp flake.lock /etc/nixos
    ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch
  '';
}
