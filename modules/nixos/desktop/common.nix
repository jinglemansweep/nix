# Shared desktop config: input devices, system packages, Plymouth boot
{ config, pkgs, lib, ... }:

{
  options.desktop.enable = lib.mkEnableOption "desktop environment";

  config = lib.mkIf config.desktop.enable {
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
    services.libinput = {
      enable = true;
      mouse.naturalScrolling = false;
      touchpad.naturalScrolling = false;
    };

    # DEs handle SSH agent (gnome-keyring or keychain)
    programs.ssh.startAgent = false;

    environment.systemPackages = [
      pkgs.firefox
      pkgs.libreoffice
      pkgs.google-chrome
      pkgs.vlc
      pkgs.mpv
      pkgs.ffmpeg
      pkgs.gimp
      pkgs.pinta
      pkgs.shotcut
      pkgs.evince
      pkgs.baobab
      pkgs.cura-appimage
      pkgs.thonny
      pkgs.tiled
      pkgs.rxvt-unicode
      pkgs.rpi-imager
    ];
  };
}
