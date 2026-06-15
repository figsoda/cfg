{ inputs, pkgs }:

let
  inherit (pkgs.stdenv.hostPlatform)
    system
    ;
in

inputs.fenix.packages.${system}.complete.withComponents [
  "cargo"
  "clippy"
  "llvm-tools"
  "rust-src"
  "rustc"
  "rustfmt"
]
