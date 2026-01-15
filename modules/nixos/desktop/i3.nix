# i3 window manager module: i3 session with supporting tools
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.desktop.enable {
    services.xserver.windowManager.i3 = {
      enable = true;
      extraPackages = [
        pkgs.i3status
        pkgs.i3lock
        pkgs.dmenu
        pkgs.rofi
      ];
    };

    environment.systemPackages = [
      pkgs.rxvt-unicode
      pkgs.feh
      pkgs.picom
      pkgs.dunst
      pkgs.arandr
      pkgs.pavucontrol
      pkgs.networkmanagerapplet
      pkgs.xclip
      pkgs.maim
    ];
  };
}
