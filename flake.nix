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
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ haumea, nix-index-database, nixos-hardware, nixpkgs, ... }:
    let
      inherit (nixpkgs.lib) genAttrs nixosSystem systems;

      module = { pkgs, ... }@args: haumea.lib.load {
        src = ./src;
        inputs = args // {
          inherit inputs;
        };
        transformer = haumea.lib.transformers.liftDefault;
      };
    in
    {
      formatter = genAttrs systems.flakeExposed
        (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      nixosConfigurations.nixos = nixosSystem {
        system = "x86_64-linux";
        modules = [
          module
          nix-index-database.nixosModules.nix-index
          nixos-hardware.nixosModules.asus-zephyrus-ga402
          ./hardware-configuration.nix
        ];
      };

      packages = genAttrs systems.flakeExposed (system: {
        neovim = (nixosSystem {
          inherit system;
          modules = [ module ];
        }).config.programs.neovim.finalPackage;
      });
    };
}
