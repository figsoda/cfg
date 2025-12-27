{ config, inputs }:

inputs.nix-index-database.packages.${config.nixpkgs.system}.default
