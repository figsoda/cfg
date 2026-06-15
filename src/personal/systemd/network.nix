{
  wait-online.enable = false;
  networks.ethernet = {
    matchConfig = {
      Type = "ether";
      Kind = "!*";
    };
    DHCP = "yes";
  };
}
