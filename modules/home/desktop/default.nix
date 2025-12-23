{ config, pkgs, lib, hostName ? "unknown", ... }:

{
  imports = [
    ./browsers.nix
    ./gnome.nix
    ./media.nix
    ./vscode.nix
  ];

  home.packages = [
    # 3D printing
    pkgs.cura-appimage

    # Game dev
    pkgs.tiled

    # Office suite
    pkgs.libreoffice

    # Graphics editors
    pkgs.mtpaint
    pkgs.gimp

    # Terminal emulators (additional to gnome-terminal)
    pkgs.rxvt-unicode

    # Screensaver
    pkgs.xscreensaver
  ];

  # Automount removable media
  services.udiskie.enable = true;

  # XScreenSaver (lounge only - laptop uses GNOME power management)
  services.xscreensaver = lib.mkIf (hostName == "lounge") {
    enable = true;
    settings = {
      timeout = "0:05:00";
      cycle = "0:01:00";
      lock = false;
      fade = true;
      unfade = true;
      fadeSeconds = "0:00:03";
      mode = "random";
      dpmsEnabled = true;
      dpmsStandby = "0:30:00";
      dpmsSuspend = "0:30:00";
      dpmsOff = "0:30:00";
    };
  };
}
