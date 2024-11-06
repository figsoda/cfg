{
  nameservers = [
    "2620:fe:11"
    "2620:fe::fe:11"
    "9.9.9.9"
    "149.112.112.122"
  ];
  networkmanager = {
    enable = true;
    dns = "none";
    ethernet.macAddress = "random";
    wifi.macAddress = "random";
  };
  useDHCP = false;
}
