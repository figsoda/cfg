{
  buildMachines = [
    {
      hostName = "aarch64.nixos.community";
      maxJobs = 64;
      sshKey = "/root/.ssh/aarch64-build-box";
      sshUser = "figsoda";
      system = "aarch64-linux";
      supportedFeatures = [ "big-parallel" ];
    }
    {
      hostName = "darwin-build-box.nix-community.org";
      maxJobs = 64;
      sshKey = "/root/.ssh/darwin-build-box";
      sshUser = "figsoda";
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      supportedFeatures = [ "big-parallel" ];
    }
  ];
  distributedBuilds = true;
  gc = {
    automatic = true;
    dates = "Sat, 04:30";
    options = "--delete-older-than 7d";
  };
  settings = {
    substituters = [
      "https://fenix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "fenix.cachix.org-1:ecJhr+RdYEdcVgUkjruiYhjbBloIEGov7bos90cZi0Q="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
