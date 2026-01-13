{ config, pkgs, lib, ... }:

{
  # Install GNOME extensions
  home.packages = with pkgs.gnomeExtensions; [
    no-overview # Skip Activities view at startup, go straight to desktop
  ];

  # Enable GNOME Keyring SSH agent for GNOME sessions
  # Note: This is used when running GNOME on NixOS
  # For i3 or standalone Home Manager, keychain is used instead (see modules/home/shell/default.nix)
  services.gnome-keyring = {
    enable = true;
    components = [ "ssh" "secrets" "pkcs11" ];
  };

  # Enable GTK settings management (ensures icon cache is updated)
  gtk.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    # Screen blanking after 30 minutes, no automatic suspend
    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 1800;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      idle-dim = false;
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-l.jxl";
      picture-uri-dark = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-d.jxl";
      picture-options = "zoom";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "code.desktop"
        "Alacritty.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      enabled-extensions = [
        "no-overview@fthx"
      ];
    };

    # Window/app switching - use window-based switching instead of app grouping
    "org/gnome/desktop/wm/keybindings" = {
      # Alt+Tab switches between all windows (not grouped by app)
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      # Disable the default app-based switcher
      switch-applications = [ ];
      switch-applications-backward = [ ];
    };

    # Custom keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Firefox";
      command = "firefox";
      binding = "<Super>b";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Terminal";
      command = "alacritty";
      binding = "<Super>Return";
    };

    # Default terminal application
    "org/gnome/desktop/applications/terminal" = {
      exec = "alacritty";
    };
  };
}
