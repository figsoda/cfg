{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
      };
    };
  };

  environment = {
    etc = {
      gitconfig.text = ''
        [user]
        name = figsoda
        email = figsoda@pm.me
      '';
      "resolv.conf".text = ''
        nameserver 1.1.1.1
        nameserver 1.0.0.1
      '';
    };
    systemPackages = with pkgs; [
      (writeTextFile {
        name = "default-icon-theme";
        destination = "/share/icons/default/index.theme";
        text = ''
          [icon theme]
          Inherits=Qogir
        '';
      })
      alacritty
      bat
      bottom
      cargo-edit
      clipmenu
      exa
      fd
      firefox
      gcc
      gimp
      git
      i3lock-color
      libreoffice-fresh
      luaformatter
      maim
      micro
      mmtc
      mpc_cli
      mpd
      (mpv.override { scripts = with mpvScripts; [ autoload sponsorblock ]; })
      networkmanagerapplet
      nixfmt
      pamixer
      papirus-icon-theme
      pavucontrol
      psmisc
      python3
      qalculate-gtk
      qogir-icon-theme
      qogir-theme
      ripgrep
      (rofi.override { plugins = [ rofi-calc rofi-emoji ]; })
      rustup
      sd
      starship
      sxiv
      udiskie
      unclutter-xfixes
      volctl
      (vscode-with-extensions.override {
        vscode = vscodium.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ jq moreutils ];
          installPhase = ''
            jq -e 'setpath(["extensionsGallery"]; {
              "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
              "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
              "itemUrl": "https://marketplace.visualstudio.com/items"
            })' resources/app/product.json | sponge resources/app/product.json
          '' + old.installPhase;
        });
        vscodeExtensions = with vscode-extensions; [
          (vscode-utils.extensionFromVscodeMarketplace {
            name = "color-highlight";
            publisher = "naumovs";
            version = "2.3.0";
            sha256 = "1syzf43ws343z911fnhrlbzbx70gdn930q67yqkf6g0mj8lf2za2";
          })
          a5huynh.vscode-ron
          bbenoist.Nix
          matklad.rust-analyzer
          mskelton.one-dark-theme
          pkief.material-icon-theme
          redhat.vscode-yaml
          serayuzgur.crates
          skyapps.fish-vscode
          tamasfe.even-better-toml
        ];
      })
      xfce.thunar
      xsel
      xss-lock
      xtrt
    ];
    variables = {
      EDITOR = "micro";
      LESSHISTFILE = "-";
      PATH = "$HOME/.cargo/bin";
    };
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Cascadia Code" ];
        sansSerif = [ "Arimo Nerd Font" ];
        serif = [ "Arimo Nerd Font" ];
      };
      includeUserConf = false;
    };
    fonts = with pkgs; [
      cascadia-code
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "Arimo" "JetBrainsMono" ]; })
      source-han-sans
    ];
  };

  gtk.iconCache.enable = true;

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    pulseaudio.enable = true;
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  networking = {
    firewall.enable = false;
    hostName = "nixos";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager = {
      enable = true;
      dns = "none";
      ethernet.macAddress = "random";
      wifi = {
        backend = "iwd";
        macAddress = "random";
      };
    };
    useDHCP = false;
  };

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "Fri, 03:00";
      options = "--delete-older-than 3d";
    };
    package = pkgs.nixUnstable;
  };

  nixpkgs = {
    config.allowUnfreePredicate = pkg: lib.hasPrefix "steam" (lib.getName pkg);
    overlays = [
      (import (fetchTarball
        "https://github.com/figsoda/nix-packages/archive/main.tar.gz"))
    ];
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_color_autosuggestion 005f5f
        set fish_color_cancel normal
        set fish_color_command 00afff
        set fish_color_comment 626262
        set fish_color_cwd 008000
        set fish_color_cwd_root 800000
        set fish_color_end d75fff
        set fish_color_error ff0000
        set fish_color_escape 00a6b2
        set fish_color_history_current normal
        set fish_color_host normal
        set fish_color_match normal
        set fish_color_normal normal
        set fish_color_operator 00a6b2
        set fish_color_param 87d7d7
        set fish_color_quote 5fd700
        set fish_color_redirection ff8700
        set fish_color_search_match ffff00
        set fish_color_selection c0c0c0
        set fish_color_user 00ff00
        set fish_color_valid_path normal
        set fish_greeting
        set fish_pager_color_completion normal
        set fish_pager_color_description B3A06D yellow
        set fish_pager_color_prefix white --bold --underline
        set fish_pager_color_progress brwhite --background=cyan

        abbr -ag nb nix-build
        abbr -ag ni nix-env -iA
        abbr -ag npu nix-prefetch-url
        abbr -ag nr nix-env -e
        abbr -ag ns nix-shell
        abbr -ag nsf nix-shell --run fish -p

        function gen -a template name
          string length -q -- $template $name
          ~/rust-templates/gen.sh ~/rust-templates/$template \
            $name $name '["figsoda <figsoda@pm.me>"]' figsoda/$name
        end

        ${pkgs.starship}/bin/starship init fish | .
      '';
      loginShellInit = ''
        if not set -q DISPLAY && [ (${pkgs.coreutils}/bin/tty) = /dev/tty1 ]
          exec ${pkgs.xorg.xinit}/bin/startx -- -ardelay 400 -arinterval 32
        end
      '';
      shellAliases = {
        ls =
          "${pkgs.exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
        redo = "eval /run/wrappers/bin/sudo $history[1]";
        rm = "${pkgs.coreutils}/bin/rm -I";
      };
    };
    ssh.askPassword = "";
    steam.enable = true;
  };

  services = {
    blueman.enable = true;
    gnome3.at-spi2-core.enable = true;
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      inputClassSections = [''
        Identifier "pointer configuration"
        MatchIsPointer "true"
        Option "TransformationMatrix" "1 0 0 0 1 0 0 0 0.3"
      ''];
      libinput = {
        enable = true;
        accelProfile = "flat";
        accelSpeed = "0";
        tapping = false;
      };
      windowManager.awesome = {
        enable = true;
        noArgb = true;
      };
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "03:30";
    };
    stateVersion = "21.03";
  };

  time.timeZone = "America/New_York";

  users.users.figsoda = {
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
  };
}
