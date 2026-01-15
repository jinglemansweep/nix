# GNOME desktop module: GDM, gnome-keyring, and excluded apps
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.desktop.enable {
    services = {
      xserver.enable = true;
      displayManager.gdm = {
        enable = true;
        settings.greeter.IncludeAll = false;
      };
      desktopManager.gnome.enable = true;
      gnome.gnome-keyring.enable = true;
    };

    environment = {
      gnome.excludePackages = [
        pkgs.gnome-tour
        pkgs.epiphany
        pkgs.geary
      ];
      systemPackages = [
        pkgs.gnome-tweaks
        pkgs.gnome-terminal
        pkgs.dconf-editor
      ];
    };

    programs.dconf.enable = true;
  };
}
