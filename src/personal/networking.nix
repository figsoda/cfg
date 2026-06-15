{
  useNetworkd = true;
  nameservers = [
    "2620:fe::fe"
    "2620:fe::9"
    "9.9.9.9"
    "149.112.112.122"
  ];
  networkmanager = {
    enable = true;
    ethernet.macAddress = "random";
    unmanaged = [ "type:ethernet" ];
    wifi.macAddress = "random";
  };
  useDHCP = false;
}
