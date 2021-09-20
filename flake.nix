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
        ({ passthru = { inherit inputs; }; })
        nixos-hardware.nixosModules.asus-zephyrus-ga401
        ./lib/fish.nix
        ./lib/misc.nix
        ./lib/nix.nix
        ./lib/nvim
        ./lib/pkgs.nix
        ./lib/programs.nix
        ./lib/services.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
