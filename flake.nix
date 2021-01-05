{
  inputs = {
    fenix = {
      url = "github:figsoda/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    figsoda-pkgs = {
      url = "github:figsoda/nix-packages";
      inputs = {
        fenix.follows = "fenix";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, fenix, figsoda-pkgs, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nix = {
            autoOptimiseStore = true;
            binaryCachePublicKeys = [
              "fenix.cachix.org-1:SVfCRUmFZ8kdAjJKShEYoyWHb/M0pxVkCjGXsFDHLk4="
              "figsoda.cachix.org-1:mJfTEL4qLCqymqynJlaTxxi5APlaM0DfWg+h+CRGa20="
            ];
            binaryCaches =
              [ "https://fenix.cachix.org" "https://figsoda.cachix.org" ];
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
            overlays = [ fenix.overlay figsoda-pkgs.overlay ];
          };
        })

        /etc/nixos/hardware-configuration.nix
        ./lib/config.nix
        ./lib/env.nix
        ./lib/fish.nix
      ];
    };
  };
}
