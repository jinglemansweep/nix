{ config, pkgs, lib, ... }:

{
  options.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.desktop.gnome.enable {
    # Enable X11 and Gnome
    services = {
      xserver.enable = true;
      displayManager.gdm = {
        enable = true;
        settings = {
          greeter.IncludeAll = false;
        };
      };
      desktopManager.gnome.enable = true;
      libinput = {
        enable = true;
        mouse.naturalScrolling = true;
        touchpad.naturalScrolling = true;
      };
      gnome.gnome-keyring.enable = true;
    };

    # Gnome-specific packages
    environment = {
      gnome.excludePackages = [
        pkgs.gnome-tour
        pkgs.epiphany # Web browser (we use Firefox)
        pkgs.geary # Email client
      ];
      systemPackages = [
        pkgs.gnome-tweaks
        pkgs.gnome-terminal
        pkgs.dconf-editor
      ];
    };

    # Enable dconf for Gnome settings
    programs = {
      dconf.enable = true;
      ssh.startAgent = false; # Let gnome-keyring handle it
    };
  };
}
