{ pkgs }:

{
  fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "JetBrainsMono Nerd Font"
        "Cascadia Code"
        "Sarasa Mono SC"
      ];
      sansSerif = [
        "Arimo Nerd Font"
        "Sarasa Gothic SC"
      ];
      serif = [
        "Arimo Nerd Font"
        "Sarasa Gothic SC"
      ];
    };
    includeUserConf = false;
  };
  packages = with pkgs; [
    cascadia-code
    nerd-fonts.arimo
    nerd-fonts.jetbrains-mono
    sarasa-gothic
  ];
}
