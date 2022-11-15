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
    nixpkgs-hammering = {
      url = "github:jtojnar/nixpkgs-hammering";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixos-hardware, nixpkgs, ... }:
    let
      inherit (nixpkgs.lib) genAttrs nixosSystem systems;
    in
    {
      nixosConfigurations.nixos = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ passthru = { inherit inputs; }; })
          nixos-hardware.nixosModules.asus-zephyrus-ga401
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
          modules = [
            ({ passthru = { inherit inputs; }; })
            ./src/nix.nix
            ./src/nvim
            ./src/passthru.nix
          ];
        }).config.programs.neovim.finalPackage;
      });
    };
}
