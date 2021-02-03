{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs = {
        naersk.follows = "naersk";
        nixpkgs.follows = "nixpkgs";
      };
    };
    figsoda-pkgs = {
      url = "github:figsoda/nix-packages";
      inputs = {
        fenix.follows = "fenix";
        flake-utils.follows = "flake-utils";
        naersk.follows = "naersk";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }: {
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
          };

          nixpkgs = {
            config.allowUnfree = true;
            overlays = with inputs; [
              fenix.overlay
              figsoda-pkgs.overlay
              neovim-nightly-overlay.overlay
            ];
          };
        })

        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e470
        ./lib/config.nix
        ./lib/env.nix
        ./lib/fish.nix
        ./lib/nvim.nix
        ./lib/pkgs.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
