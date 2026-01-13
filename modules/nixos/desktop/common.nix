# Shared desktop config: input devices, system packages (applied when any DE is enabled)
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (config.desktop.gnome.enable || config.desktop.i3.enable) {
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
      pkgs.evince
      pkgs.baobab
      pkgs.cura-appimage
      pkgs.thonny
      pkgs.tiled
      pkgs.rxvt-unicode
    ];
  };
}
