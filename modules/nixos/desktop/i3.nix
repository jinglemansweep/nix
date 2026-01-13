{ config, pkgs, lib, ... }:

{
  options.desktop.i3.enable = lib.mkEnableOption "i3 window manager";

  config = lib.mkIf config.desktop.i3.enable {
    # Disable natural scrolling for mouse
    services.libinput = {
      enable = true;
      mouse.naturalScrolling = false;
    };

    # i3 window manager as an alternative session
    services.xserver.windowManager.i3 = {
      enable = true;
      extraPackages = [
        pkgs.i3status
        pkgs.i3lock
        pkgs.dmenu
        pkgs.rofi
      ];
    };

    # Disable system SSH agent (let keychain handle it)
    programs.ssh.startAgent = false;

    # Additional packages useful with i3
    environment.systemPackages = [
      pkgs.rxvt-unicode
      pkgs.feh # Wallpaper setter
      pkgs.picom # Compositor
      pkgs.dunst # Notification daemon
      pkgs.arandr # Display configuration
      pkgs.pavucontrol # Audio control
      pkgs.networkmanagerapplet # Network tray icon
      pkgs.xclip # Clipboard
      pkgs.maim # Screenshots
    ];
  };
}
