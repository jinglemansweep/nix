{ config, pkgs, lib, ... }:

{
  # Enable GNOME Keyring SSH agent for GNOME sessions
  # Note: This is used when running GNOME on NixOS
  # For i3 or standalone Home Manager, keychain is used instead (see modules/home/shell/default.nix)
  services.gnome-keyring = {
    enable = true;
    components = [ "ssh" "secrets" "pkcs11" ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    # Wallpaper (uncomment and set path when ready)
    # "org/gnome/desktop/background" = {
    #   picture-uri = "file://${config.home.homeDirectory}/.wallpapers/wallpaper.jpg";
    #   picture-uri-dark = "file://${config.home.homeDirectory}/.wallpapers/wallpaper.jpg";
    #   picture-options = "zoom";
    # };

    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "code.desktop"
        "org.gnome.Terminal.desktop"
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
      command = "gnome-terminal";
      binding = "<Super>Return";
    };
  };
}
