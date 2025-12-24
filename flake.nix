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
      url = "https://flakehub.com/f/nix-community/haumea/0.2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ haumea, nixos-hardware, nixpkgs, ... }:
    let
      inherit (nixpkgs.lib) genAttrs nixosSystem;

      eachSystem = genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      module = { pkgs, ... }@args: haumea.lib.load {
        src = ./src;
        inputs = args // {
          inherit inputs;
        };
        transformer = haumea.lib.transformers.liftDefault;
      };
    in
    {
      formatter = eachSystem (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      nixosConfigurations.nixos = nixosSystem {
        system = "x86_64-linux";
        modules = [
          module
          nixos-hardware.nixosModules.framework-16-amd-ai-300-series-nvidia
          ./hardware-configuration.nix
        ];
      };

      packages = eachSystem (system: {
        neovim = (nixosSystem {
          inherit system;
          modules = [ module ];
        }).config.programs.neovim.finalPackage;
      });
    };
}
