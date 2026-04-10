# Sway window manager module: Wayland compositor with supporting tools
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.desktop.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [
        pkgs.swaylock
        pkgs.swayidle
        pkgs.swaybg
        pkgs.wmenu
        pkgs.wofi
      ];
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.sessionVariables = {
      WLR_RENDER_NO_EXPLICIT_SYNC = "1";
    };

    environment.systemPackages = [
      pkgs.grim
      pkgs.slurp
      pkgs.wl-clipboard
      pkgs.mako
      pkgs.kanshi
      pkgs.pavucontrol
      pkgs.networkmanagerapplet
      pkgs.brightnessctl
    ];

    security.polkit.enable = true;
  };
}
