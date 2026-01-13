{ config, pkgs, lib, ... }:

{
  # Shared desktop configuration applied when any desktop environment is enabled
  config = lib.mkIf (config.desktop.gnome.enable || config.desktop.i3.enable) {
    # Input device settings (mouse/touchpad)
    services.libinput = {
      enable = true;
      mouse.naturalScrolling = false;
      touchpad.naturalScrolling = false;
    };

    # Disable system SSH agent (desktop environments handle this themselves:
    # GNOME uses gnome-keyring, i3 uses keychain via bash initExtra)
    programs.ssh.startAgent = false;

    # Desktop applications (system-wide for all users)
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
