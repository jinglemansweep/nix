{ config, pkgs, lib, ... }:

{
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

    "org/gnome/desktop/background" = {
      picture-uri = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-l.jxl";
      picture-uri-dark = "file://${pkgs.gnome-backgrounds}/share/backgrounds/gnome/adwaita-d.jxl";
      picture-options = "zoom";
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "code.desktop"
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Nautilus.desktop"
      ];
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
      command = "ghostty";
      binding = "<Super>Return";
    };

    # Default terminal application
    "org/gnome/desktop/applications/terminal" = {
      exec = "ghostty";
    };
  };
}
