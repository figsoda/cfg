{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        spectrum.follows = "";
      };
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{
      self,
      haumea,
      nixos-hardware,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs.lib) genAttrs nixosSystem;

      eachSystem = genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      importModule =
        src:
        { pkgs, ... }@args:
        haumea.lib.load {
          inherit src;
          inputs = args // {
            inherit inputs;
          };
          transformer = haumea.lib.transformers.liftDefault;
        };
    in
    {
      formatter = eachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt);

      nixosConfigurations.nixos = nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.personal
          self.nixosModules.shared
          nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia
          ./hardware-configuration.nix
        ];
      };

      nixosModules = {
        personal = importModule ./src/personal;
        shared = importModule ./src/shared;
      };

      packages = eachSystem (system: {
        neovim =
          (nixosSystem {
            inherit system;
            modules = [ self.nixosModules.shared ];
          }).config.programs.neovim.finalPackage;
      });
    };
}
