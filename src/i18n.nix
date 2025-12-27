{ pkgs }:

{
  inputMethod = {
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = [ pkgs.fcitx5-rime ];
      settings = {
        addons = {
          classicui.globalSection = {
            Font = "sans 14";
            MenuFont = "sans 14";
            Theme = "dark";
            TrayFont = "sans 10";
          };
          clipboard.globalSection.TriggerKey = "";
          quickphrase.globalSection.TriggerKey = "";
          unicode.globalSection = {
            DirectUnicodeMode = "";
            TriggerKey = "";
          };
        };
        globalOptions = {
          Behavior.ShareInputState = "All";
          Hotkey = {
            ActivateKeys = "";
            AltTriggerKeys = "";
            DeactivateKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
            EnumerateGroupForwardKeys = "";
            TogglePreedit = "";
          };
          "Hotkey/TriggerKeys"."0" = "Super+I";
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            "Default Layout" = "us";
            DefaultIm = "rime";
            Name = "Default";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
        };
      };
    };
    type = "fcitx5";
  };
  supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}
