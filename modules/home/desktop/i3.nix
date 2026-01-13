{ pkgs, lib, config, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4"; # Super key
      focus.followMouse = false;

      # Window gaps
      gaps = {
        inner = 10;
        outer = 5;
      };

      # Remove title bars, use pixel borders
      window = {
        titlebar = false;
        border = 2;
      };
      floating.titlebar = false;

      # Window border colors (gruvbox theme)
      colors = {
        focused = {
          border = "#458588";
          background = "#458588";
          text = "#ebdbb2";
          indicator = "#83a598";
          childBorder = "#458588";
        };
        unfocused = {
          border = "#282828";
          background = "#282828";
          text = "#928374";
          indicator = "#282828";
          childBorder = "#282828";
        };
        focusedInactive = {
          border = "#3c3836";
          background = "#3c3836";
          text = "#928374";
          indicator = "#3c3836";
          childBorder = "#3c3836";
        };
        urgent = {
          border = "#cc241d";
          background = "#cc241d";
          text = "#ebdbb2";
          indicator = "#cc241d";
          childBorder = "#cc241d";
        };
      };

      keybindings =
        let
          inherit (config.xsession.windowManager.i3.config) modifier;
        in
        lib.mkOptionDefault {
          # Application launchers
          "${modifier}+b" = "exec firefox";
          "${modifier}+Return" = "exec alacritty";

          # Rofi instead of dmenu
          "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";

          # Volume controls
          "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

          # Brightness controls
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

          # Screenshots (maim)
          "Print" = "exec ${pkgs.maim}/bin/maim $XDG_PICTURES_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png";
          "Shift+Print" = "exec ${pkgs.maim}/bin/maim -s $XDG_PICTURES_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png";
          "Ctrl+Print" = "exec ${pkgs.maim}/bin/maim | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
          "Ctrl+Shift+Print" = "exec ${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
        };

      defaultWorkspace = "workspace number 1";

      startup = [
        {
          command = "${pkgs.feh}/bin/feh --bg-fill ${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-d.jxl";
          always = false;
          notification = false;
        }
        {
          command = "xinput list --name-only | while read -r device; do xinput list-props \"$device\" 2>/dev/null | grep -q 'libinput Natural Scrolling Enabled' && xinput set-prop \"$device\" 'libinput Natural Scrolling Enabled' 0; done";
          always = true;
          notification = false;
        }
        {
          command = "nm-applet";
          always = false;
          notification = false;
        }
      ];

      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
          fonts = {
            names = [ "DejaVu Sans Mono" "Font Awesome 6 Free" ];
            size = 10.0;
          };
          colors = {
            background = "#282828";
            statusline = "#ebdbb2";
            separator = "#666666";
            focusedWorkspace = {
              border = "#458588";
              background = "#458588";
              text = "#ebdbb2";
            };
            activeWorkspace = {
              border = "#83a598";
              background = "#83a598";
              text = "#282828";
            };
            inactiveWorkspace = {
              border = "#282828";
              background = "#282828";
              text = "#ebdbb2";
            };
            urgentWorkspace = {
              border = "#cc241d";
              background = "#cc241d";
              text = "#ebdbb2";
            };
          };
        }
      ];
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        theme = "plain";
        icons = "awesome6";
        settings = {
          theme = {
            overrides = {
              idle_bg = "#282828";
              idle_fg = "#ebdbb2";
              good_bg = "#282828";
              good_fg = "#ebdbb2";
              warning_bg = "#d79921";
              warning_fg = "#282828";
              critical_bg = "#cc241d";
              critical_fg = "#ebdbb2";
              separator = "";
            };
          };
        };
        blocks = [
          {
            block = "cpu";
            interval = 5;
            format = " $icon $utilization ";
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
            interval = 5;
          }
          {
            block = "disk_space";
            path = "/";
            format = " $icon $available ";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "net";
            format = " $icon $ip ";
            interval = 5;
          }
          {
            block = "battery";
            format = " $icon $percentage ($time) ";
            full_format = " $icon Full ";
            charging_format = " $icon $percentage ($time) ";
            not_charging_format = " $icon $percentage ";
            missing_format = "";
            warning = 20.0;
            critical = 10.0;
          }
          {
            block = "sound";
            driver = "pulseaudio";
          }
          {
            block = "time";
            format = " $icon $timestamp.datetime(f:'%a %d %b %H:%M') ";
            interval = 60;
          }
        ];
      };
    };
  };

  # Font Awesome for status bar icons
  home.packages = [
    pkgs.font-awesome
  ];

  # Compositor for shadows, transparency, and smooth transitions
  services.picom = {
    enable = true;
    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.6;
    fade = true;
    fadeDelta = 4;
    fadeSteps = [ 0.03 0.03 ];
    settings = {
      shadow-radius = 12;
      corner-radius = 8;
      rounded-corners-exclude = [
        "class_g = 'i3bar'"
      ];
    };
  };
}
