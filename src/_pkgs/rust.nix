{ pkgs }:

pkgs.fenix.complete.withComponents [
  "cargo"
  "clippy"
  "llvm-tools"
  "rust-src"
  "rustc"
  "rustfmt"
]
