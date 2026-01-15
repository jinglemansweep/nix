# Shared Home Manager configuration: secrets and XDG directories
{ config, pkgs, lib, inputs, userConfig, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../modules/home/secrets.nix
    ../../modules/home/env.nix
  ];

  home = {
    inherit (userConfig) username;
    homeDirectory = "/home/${userConfig.username}";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

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
      templates = null;
      publicShare = null;
    };
  };
}
