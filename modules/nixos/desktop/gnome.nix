# GNOME desktop module: GDM, Plymouth, gnome-keyring, and excluded apps
{ config, pkgs, lib, ... }:

{
  options.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.desktop.gnome.enable {
    boot = {
      plymouth.enable = true;
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };

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
