{ config, pkgs, lib, ... }:

{
  # i3 window manager as an alternative session
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3status
      i3lock
      dmenu
      rofi
    ];
  };

  # Additional packages useful with i3
  environment.systemPackages = with pkgs; [
    rxvt-unicode
    feh # Wallpaper setter
    picom # Compositor
    dunst # Notification daemon
    arandr # Display configuration
    pavucontrol # Audio control
    networkmanagerapplet # Network tray icon
    xclip # Clipboard
    maim # Screenshots
  ];
}
