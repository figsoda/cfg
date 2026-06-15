{ inputs }:

{
  channel.enable = false;
  registry.nixpkgs.flake = inputs.nixpkgs;
  settings = {
    auto-optimise-store = true;
    experimental-features = [
      "ca-derivations"
      "dynamic-derivations"
      "flakes"
      "nix-command"
      "recursive-nix"
    ];
    flake-registry = "${inputs.flake-registry}/flake-registry.json";
    keep-outputs = true;
    log-lines = 50;
    nix-path = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
