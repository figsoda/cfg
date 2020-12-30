{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    figsoda-pkgs = {
      url = "github:figsoda/nix-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, figsoda-pkgs, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ lib, pkgs, ... }: {
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

                [credential "https://github.com"]
                username = figsoda
                helper = ${
                  pkgs.writeShellScript "credential-helper-github" ''
                    if [ "$1" = get ]; then
                      echo "password=$(${pkgs.libressl}/bin/openssl \
                        aes-256-cbc -d -in ~/.config/secrets/github)"
                    fi
                  ''
                }
              '';
              "resolv.conf".text = ''
                nameserver 1.1.1.1
                nameserver 1.0.0.1
              '';
              "xdg/mimeapps.list".text = ''
                [Default Applications]
                application/pdf=firefox.desktop
                image/bmp=sxiv.desktop
                image/gif=sxiv.desktop
                image/jpeg=sxiv.desktop
                image/jpg=sxiv.desktop
                image/png=sxiv.desktop
                image/tiff=sxiv.desktop
                image/x-bmp=sxiv.desktop
                image/x-portable-anymap=sxiv.desktop
                image/x-portable-bitmap=sxiv.desktop
                image/x-portable-graymap=sxiv.desktop
                image/x-tga=sxiv.desktop
                image/x-xpixmap=sxiv.desktop
                inode/directory=spacefm.desktop
              '';
            };
            systemPackages = with pkgs; [
              (writeTextDir "/share/icons/default/index.theme" ''
                [icon theme]
                Inherits=Qogir
              '')
              alacritty
              bat
              bottom
              cargo-edit
              clipmenu
              fd
              firefox
              gcc
              gimp
              git
              libreoffice-fresh
              libressl
              luaformatter
              maim
              micro
              mmtc
              mpc_cli
              (mpv.override {
                scripts = with mpvScripts; [ autoload sponsorblock ];
              })
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
              spaceFM
              sxiv
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
                  a5huynh.vscode-ron
                  bbenoist.Nix
                  matklad.rust-analyzer
                  mskelton.one-dark-theme
                  naumovs.color-highlight
                  pkief.material-icon-theme
                  redhat.vscode-yaml
                  serayuzgur.crates
                  skyapps.fish-vscode
                  tamasfe.even-better-toml
                ];
              })
              xsel
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
            extraOptions = "experimental-features = flakes nix-command";
            gc = {
              automatic = true;
              dates = "Sat, 03:00";
              options = "--delete-older-than 3d";
            };
            package = pkgs.nixUnstable;
          };

          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ figsoda-pkgs.overlay.x86_64-linux ];
          };

          programs = {
            dconf.enable = true;
            fish = {
              enable = true;
              interactiveShellInit = let fd = "${pkgs.fd}/bin/fd";
              in ''
                set -g fish_color_autosuggestion 005f5f
                set -g fish_color_cancel normal
                set -g fish_color_command 00afff
                set -g fish_color_comment 626262
                set -g fish_color_cwd 008000
                set -g fish_color_cwd_root 800000
                set -g fish_color_end d75fff
                set -g fish_color_error ff0000
                set -g fish_color_escape 00a6b2
                set -g fish_color_history_current normal
                set -g fish_color_host normal
                set -g fish_color_match normal
                set -g fish_color_normal normal
                set -g fish_color_operator 00a6b2
                set -g fish_color_param 87d7d7
                set -g fish_color_quote 5fd700
                set -g fish_color_redirection ff8700
                set -g fish_color_search_match ffff00
                set -g fish_color_selection c0c0c0
                set -g fish_color_user 00ff00
                set -g fish_color_valid_path normal
                set -g fish_greeting
                set -g fish_pager_color_completion normal
                set -g fish_pager_color_description B3A06D yellow
                set -g fish_pager_color_prefix white --bold --underline
                set -g fish_pager_color_progress brwhite --background=cyan

                abbr -ag nb nix-build
                abbr -ag nd nix develop
                abbr -ag ne nix-env
                abbr -ag nei nix-env -f '"<nixos>"' -iA
                abbr -ag ner nix-env -e
                abbr -ag nf nix flake
                abbr -ag npu nix-prefetch-url
                abbr -ag ns nix-shell
                abbr -ag nsf nix-shell --run fish -p

                function f -a lang
                  switch $lang
                    case lua
                      ${fd} -H '\.lua$' -x ${pkgs.luaformatter}/bin/lua-format -i
                    case nix
                      ${fd} -H '\.nix$' -x ${pkgs.nixfmt}/bin/nixfmt
                    case "*"
                      echo "unexpected language: $lang"
                  end
                end

                function gen -a template name
                  string length -q -- $template $name
                  ~/rust-templates/gen.sh ~/rust-templates/$template \
                    $name $name '["figsoda <figsoda@pm.me>"]' figsoda/$name
                end

                ${pkgs.starship}/bin/starship init fish | source
              '';
              loginShellInit = ''
                if not set -q DISPLAY && [ (${pkgs.coreutils}/bin/tty) = /dev/tty1 ]
                  exec ${pkgs.xorg.xinit}/bin/startx ${
                    pkgs.writeText "xinitrc" ''
                      CM_MAX_CLIPS=20 CM_SELECTIONS=clipboard ${pkgs.clipmenu}/bin/clipmenud &
                      ${pkgs.mpd}/bin/mpd &
                      ${pkgs.networkmanagerapplet}/bin/nm-applet &
                      ${pkgs.spaceFM}/bin/spacefm -d &
                      ${pkgs.unclutter-xfixes}/bin/unclutter --timeout 3 &
                      ${pkgs.volctl}/bin/volctl &
                      ${pkgs.xss-lock}/bin/xss-lock -l -- \
                          ${pkgs.i3lock-color}/bin/i3lock-color -i ~/.config/wallpaper.png -k \
                          --{inside{ver,wrong,},ring,line,separator}color=00000000 \
                          --ringvercolor=98c040 --ringwrongcolor=d02828 \
                          --keyhlcolor=2060a0 --bshlcolor=d06020 \
                          --verifcolor=b8f080 --wrongcolor=ff8080 \
                          --indpos=x+w/7:y+h-w/8 \
                          --{time,date}-font=monospace --{layout,verif,wrong,greeter}size=32 \
                          --timecolor=60b8ff --timesize=36 \
                          --datepos=ix:iy+36 --datecolor=e0a878 --datestr=%F --datesize=28 \
                          --veriftext=Verifying... --wrongtext="Try again!" --noinputtext="No input" \
                          --locktext=Locking... --lockfailedtext="Lock failed!" \
                          --radius 108 --ring-width 8 &
                      exec ${pkgs.awesome}/bin/awesome
                    ''
                  } -- -ardelay 400 -arinterval 32
                end
              '';
              shellAliases = {
                ls =
                  "${pkgs.exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
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
              enableCtrlAltBackspace = true;
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
              flake = "/etc/nixos";
            };
            stateVersion = "21.03";
          };

          time.timeZone = "America/New_York";

          users.users.figsoda = {
            extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
            isNormalUser = true;
            shell = "${pkgs.fish}/bin/fish";
          };
        })
      ];
    };
  };
}
