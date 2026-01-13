{ pkgs, lib, config, ... }:

{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4"; # Super key

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
        theme = "gruvbox-dark";
        icons = "awesome6";
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
            format = " $icon $percentage $time ";
            missing_format = "";
          }
          {
            block = "sound";
            format = " $icon $volume ";
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
}
