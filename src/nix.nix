{ config, pkgs, ... }:

let inherit (config.passthru) inputs; in

{
  nix = {
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