{ lib, root }:

variant:

let
  inherit (lib)
    concatStrings
    mapAttrsToList
    ;

  alpha =
    {
      gtk3 = color: alpha: "alpha(${color}, 0.${alpha})";
      gtk4 = color: alpha: "color-mix(in srgb, ${color} ${alpha}%, transparent)";
    }
    .${variant};

  colors = with root.colors; {
    accent_blue = blue;
    accent_teal = cyan;
    accent_green = green;
    accent_yellow = yellow;
    accent_orange = orange;
    accent_red = red;
    accent_pink = red;
    accent_purple = magenta;
    accent_slate = lightgray;

    accent_bg_color = blue;
    accent_fg_color = black;
    accent_color = blue;

    destructive_bg_color = red;
    destructive_fg_color = black;
    destructive_color = red;

    success_bg_color = green;
    success_fg_color = black;
    success_color = green;

    warning_bg_color = yellow;
    warning_fg_color = black;
    warning_color = yellow;

    error_bg_color = red;
    error_fg_color = black;
    error_color = red;

    window_bg_color = black;
    window_fg_color = white;

    view_bg_color = black;
    view_fg_color = white;

    headerbar_bg_color = black;
    headerbar_fg_color = white;
    headerbar_border_color = black;
    headerbar_backdrop_color = black;
    headerbar_shade_color = alpha darker "20";
    headerbar_darker_shade_color = alpha darker "20";

    sidebar_bg_color = black;
    sidebar_fg_color = white;
    sidebar_backdrop_color = black;
    sidebar_border_color = black;
    sidebar_shade_color = alpha darker "20";

    secondary_sidebar_bg_color = black;
    secondary_sidebar_fg_color = white;
    secondary_sidebar_backdrop_color = black;
    secondary_sidebar_border_color = black;
    secondary_sidebar_shade_color = alpha darker "20";

    card_bg_color = alpha black "85";
    card_fg_color = white;
    card_shade_color = alpha darker "20";

    dialog_bg_color = alpha black "85";
    dialog_fg_color = white;

    popover_bg_color = alpha black "85";
    popover_fg_color = white;
    popover_shade_color = alpha darker "20";

    thumbnail_bg_color = black;
    thumbnail_fg_color = white;

    shade_color = alpha darker "20";
    scrollbar_outline_color = black;

    active_toggle_bg_color = blue;
    active_toggle_fg_color = black;

    overview_bg_color = black;
    overview_fg_color = white;
  };

  extraColors = with root.colors; /* css */ ''
    switch:checked {
      background-color: ${blue};
    }

    switch > slider {
      background-color: ${white};
    }

    switch:checked > slider {
      background-color: ${gray};
    }

    toast {
      background-color: ${alpha dimgray "85"};
      color: ${white};
    }

    tooltip.background {
      background-color: ${alpha dimgray "85"};
      color: ${white};
    }
  '';

  extraStyles =
    {
      gtk3 = "";
      gtk4 = /* css */ ''
        :root {
          --border-opacity: 0;
          --window-radius: 0;
        }
      '';
    }
    .${variant};

in

concatStrings (mapAttrsToList (k: v: "@define-color ${k} ${v};\n") colors)
+ extraColors
+ extraStyles
