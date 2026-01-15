# Sway window manager module: Wayland compositor with supporting tools
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.desktop.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        swaybg
        wmenu
        wofi
      ];
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
      kanshi
      pavucontrol
      networkmanagerapplet
      brightnessctl
    ];

    security.polkit.enable = true;
  };
}
