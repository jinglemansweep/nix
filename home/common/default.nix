{ config, pkgs, lib, inputs, userConfig, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home/shell
    ../../modules/home/secrets.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    inherit (userConfig) username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "24.05";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

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
      templates = null; # Disabled
      publicShare = null; # Disabled
    };
  };
}
