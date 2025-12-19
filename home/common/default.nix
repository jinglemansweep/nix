{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../modules/home/shell
    ../../modules/home/tools
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile
  home.packages = [
    # Additional utilities
    pkgs.tree
    pkgs.jq
    pkgs.yq
    pkgs.ncdu
    pkgs.neofetch
  ];

  # XDG user directories (lowercase, consolidated)
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/data/documents";
      download = "${config.home.homeDirectory}/tmp/downloads";
      music = "${config.home.homeDirectory}/data/media/music";
      pictures = "${config.home.homeDirectory}/data/media/pictures";
      videos = "${config.home.homeDirectory}/data/media/videos";
      templates = null;  # Disabled
      publicShare = null;  # Disabled
    };
  };

  # This value determines the Home Manager release
  home.stateVersion = "24.05";
}
