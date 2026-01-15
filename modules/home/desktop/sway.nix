# Sway window manager: keybindings, gaps, gruvbox theme, i3status-rust, mako, and wofi
{ pkgs, lib, config, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      # Fix Zed constant redraw issue when floating
      for_window [app_id="dev.zed.Zed"] floating disable
    '';
    config = {
      modifier = "Mod4";
      focus.followMouse = false;
      terminal = "alacritty";

      gaps = {
        inner = 10;
        outer = 2;
      };

      window = {
        titlebar = false;
        border = 4;
      };
      floating.titlebar = false;

      # Gruvbox theme
      colors = {
        focused = {
          border = "#802040";
          background = "#802040";
          text = "#ebdbb2";
          indicator = "#993355";
          childBorder = "#802040";
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
          inherit (config.wayland.windowManager.sway.config) modifier;
        in
        lib.mkOptionDefault {
          "${modifier}+b" = "exec firefox";
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi --show drun";
          "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "XF86AudioMicMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          "Print" = "exec ${pkgs.grim}/bin/grim $XDG_PICTURES_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png";
          "Shift+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" $XDG_PICTURES_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png";
          "Ctrl+Print" = "exec ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy";
          "Ctrl+Shift+Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";
          "${modifier}+Escape" = "exec ${pkgs.swaylock}/bin/swaylock -c 282828";
          "${modifier}+Tab" = "workspace back_and_forth";
          "${modifier}+u" = "[urgent=latest] focus";
          "${modifier}+grave" = "scratchpad show";
          "${modifier}+Shift+grave" = "move scratchpad";
          "${modifier}+Shift+e" = "exec ${pkgs.writeShellScript "sway-power-menu" ''
            choice=$(echo -e "Lock\nLogout\nSuspend\nReboot\nShutdown" | ${pkgs.wofi}/bin/wofi --show dmenu --prompt "Power")
            case "$choice" in
              "Lock") ${pkgs.swaylock}/bin/swaylock -c 282828 ;;
              "Logout") swaymsg exit ;;
              "Suspend") systemctl suspend ;;
              "Reboot") systemctl reboot ;;
              "Shutdown") systemctl poweroff ;;
            esac
          ''}";
        };

      defaultWorkspace = "workspace number 1";

      input = {
        "*" = {
          natural_scroll = "disabled";
          xkb_layout = "gb";
        };
        "type:touchpad" = {
          tap = "enabled";
          dwt = "enabled";
        };
      };

      output = {
        "*" = {
          bg = "${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-d.jxl fill";
        };
      };

      startup = [
        { command = "nm-applet --indicator"; }
        { command = "${pkgs.mako}/bin/mako"; }
      ];

      bars = lib.mkForce [
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
          theme.overrides = {
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
        blocks = [
          { block = "cpu"; interval = 5; format = " $icon $utilization "; }
          { block = "memory"; format = " $icon $mem_used_percents "; interval = 5; }
          { block = "disk_space"; path = "/"; format = " $icon $available "; interval = 60; warning = 20.0; alert = 10.0; }
          { block = "net"; format = " $icon $ip "; interval = 5; }
          { block = "battery"; format = " $icon $percentage ($time) "; full_format = " $icon Full "; charging_format = " $icon $percentage ($time) "; not_charging_format = " $icon $percentage "; missing_format = ""; warning = 20.0; critical = 10.0; }
          { block = "sound"; driver = "pulseaudio"; }
          { block = "time"; format = " $icon $timestamp.datetime(f:'%a %d %b %H:%M') "; interval = 60; }
        ];
      };
    };
  };

  home.packages = [
    pkgs.font-awesome
    pkgs.playerctl
  ];

  programs.wofi = {
    enable = true;
    settings = {
      width = 400;
      height = 300;
      show = "drun";
      prompt = "Search...";
      allow_images = true;
    };
    style = ''
      window {
        background-color: #282828;
        border: 2px solid #458588;
        border-radius: 8px;
      }
      #input {
        background-color: #3c3836;
        color: #ebdbb2;
        border: none;
        border-radius: 4px;
        margin: 8px;
        padding: 8px;
      }
      #outer-box {
        margin: 8px;
      }
      #entry {
        padding: 8px;
      }
      #entry:selected {
        background-color: #458588;
        border-radius: 4px;
      }
      #text {
        color: #ebdbb2;
      }
    '';
  };

  services.mako = {
    enable = true;
    settings = {
      background-color = "#282828";
      text-color = "#ebdbb2";
      border-color = "#458588";
      border-radius = 8;
      border-size = 2;
      default-timeout = 5000;
      font = "DejaVu Sans 10";
    };
  };
}
