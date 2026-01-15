# GNOME desktop: extensions, keyring, dark theme, keybindings, and power settings
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    no-overview
  ];

  # SSH agent for GNOME sessions (keychain used for i3/standalone)
  services.gnome-keyring = {
    enable = true;
    components = [ "ssh" "secrets" "pkcs11" ];
  };

  gtk.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

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
        "dev.zed.Zed.desktop"
        "Alacritty.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      enabled-extensions = [
        "no-overview@fthx"
      ];
    };

    # Window-based Alt+Tab (not grouped by app)
    "org/gnome/desktop/wm/keybindings" = {
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
    };

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

    "org/gnome/desktop/applications/terminal" = {
      exec = "alacritty";
    };
  };
}
