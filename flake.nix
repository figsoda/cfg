{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    figsoda-pkgs = {
      url = "github:figsoda/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixos-hardware, nixpkgs, ... }:
    let
      inherit (nixpkgs.lib) genAttrs nixosSystem systems;
    in
    {
      formatter = genAttrs systems.flakeExposed
        (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      nixosConfigurations.nixos = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          nixos-hardware.nixosModules.asus-zephyrus-ga402
          ./src/etc.nix
          ./src/fish.nix
          ./src/misc.nix
          ./src/nix.nix
          ./src/nvim
          ./src/passthru.nix
          ./src/pkgs.nix
          ./src/programs.nix
          ./src/services.nix
        ];
      };

      packages = genAttrs systems.flakeExposed (system: {
        neovim = (nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./src/nix.nix
            ./src/nvim
            ./src/passthru.nix
          ];
        }).config.programs.neovim.finalPackage;
      });
    };
}
