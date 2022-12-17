{ config, pkgs, ... }:

let inherit (config.passthru) inputs; in

{
  nix = {
    buildMachines = [
      {
        hostName = "darwin-build-box.winter.cafe";
        maxJobs = 4;
        sshKey = "/root/.ssh/darwin-build-box";
        sshUser = "figsoda";
        systems = [ "aarch64-darwin" "x86_64-darwin" ];
      }
    ];
    distributedBuilds = true;
    gc = {
      automatic = true;
      dates = "04:30";
      options = "--delete-older-than 7d";
    };
    nixPath = [
      "nixos=${inputs.nixpkgs}"
      "nixpkgs=${inputs.nixpkgs}"
    ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "flakes" "nix-command" ];
      log-lines = 50;
      substituters = [
        "https://figsoda.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "figsoda.cachix.org-1:mJfTEL4qLCqymqynJlaTxxi5APlaM0DfWg+h+CRGa20="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = with inputs; [
      fenix.overlays.default
      figsoda-pkgs.overlays.default
      nixpkgs-hammering.overlays.default
    ];
  };
}
