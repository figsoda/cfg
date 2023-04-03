{ root }:

{
  wantedBy = [ "sleep.target" ];
  before = [ "sleep.target" ];
  environment = {
    DISPLAY = ":1";
    XAUTHORITY = "/home/figsoda/.local/share/sx/xauthority";
  };
  serviceConfig = {
    Type = "forking";
    User = "figsoda";
    ExecStart = "${root.pkgs.lockscreen}/bin/lockscreen";
  };
}
