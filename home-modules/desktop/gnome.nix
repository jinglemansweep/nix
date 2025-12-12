{ config, pkgs, lib, ... }:

{
  # Disable GNOME Keyring SSH agent (using keychain instead)
  services.gnome-keyring.enable = false;

  # Disable GCR SSH agent socket/service
  systemd.user.services.gcr-ssh-agent = {
    Unit.Description = "Disabled GCR SSH Agent";
    Service.ExecStart = "${pkgs.coreutils}/bin/true";
  };
  systemd.user.sockets.gcr-ssh-agent = {
    Install.WantedBy = lib.mkForce [];
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
