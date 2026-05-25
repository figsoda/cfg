# dummy hardware-configuration.nix to fix eval
{
  fileSystems."/" = {
    fsType = "ext4";
    label = "nixos";
  };
}
