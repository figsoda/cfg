{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    figsoda-pkgs = {
      url = "github:figsoda/nix-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-hammering = {
      url = "github:jtojnar/nixpkgs-hammering";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixos-hardware, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nix = {
            autoOptimiseStore = true;
            binaryCachePublicKeys = [
              "figsoda.cachix.org-1:mJfTEL4qLCqymqynJlaTxxi5APlaM0DfWg+h+CRGa20="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
            binaryCaches = [
              "https://figsoda.cachix.org"
              "https://nix-community.cachix.org"
            ];
            extraOptions = "experimental-features = flakes nix-command";
            gc = {
              automatic = true;
              dates = "Sat, 00:30";
              options = "--delete-older-than 3d";
            };
            nixPath = [ "nixos=${nixpkgs}" "nixpkgs=${nixpkgs}" ];
            package = pkgs.nixUnstable;
            registry.nixpkgs.flake = nixpkgs;
          };

          nixpkgs = {
            config.allowUnfree = true;
            overlays = with inputs; [
              fenix.overlay
              figsoda-pkgs.overlay
              nixpkgs-hammering.overlay
            ];
          };
        })

        nixos-hardware.nixosModules.asus-zephyrus-ga401

        ./lib/cfg.nix
        ./lib/env.nix
        ./lib/fish.nix
        ./lib/nvim
        ./lib/pkgs.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
