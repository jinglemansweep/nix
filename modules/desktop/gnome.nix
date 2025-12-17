{ config, pkgs, lib, ... }:

{
  options.desktop.gnome.enable = lib.mkEnableOption "GNOME desktop environment";

  config = lib.mkIf config.desktop.gnome.enable {
    # Enable X11 and Gnome
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Disable the user list in GDM (requires typing username)
    services.displayManager.gdm.settings = {
      greeter.IncludeAll = false;
    };

    # Gnome-specific packages
    environment.gnome.excludePackages = [
      pkgs.gnome-tour
      pkgs.epiphany # Web browser (we use Firefox)
      pkgs.geary # Email client
    ];

    environment.systemPackages = [
      pkgs.gnome-tweaks
      pkgs.gnome-terminal
      pkgs.dconf-editor
    ];

    # Enable dconf for Gnome settings
    programs.dconf.enable = true;

    # Natural scrolling for mouse and touchpad
    services.libinput = {
      enable = true;
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
    };

    # Enable GNOME's SSH agent via gnome-keyring
    programs.ssh.startAgent = false;  # Let gnome-keyring handle it
    services.gnome.gnome-keyring.enable = true;
  };
}
