{ config, pkgs, lib, ... }:

{
  # Enable X11 and Gnome
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Gnome-specific packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany # Web browser (we use Firefox)
    geary # Email client
  ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-terminal
    dconf-editor
  ];

  # Enable dconf for Gnome settings
  programs.dconf.enable = true;
}
