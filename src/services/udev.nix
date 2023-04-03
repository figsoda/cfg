{
  extraRules = ''
    KERNEL=="rfkill", SUBSYSTEM=="misc", TAG+="uaccess"
  '';
}
