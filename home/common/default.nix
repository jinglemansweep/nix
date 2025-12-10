{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../home-modules/shell
    ../../home-modules/dev
    ../../home-modules/tools
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = userConfig.username;
  home.homeDirectory = "/home/${userConfig.username}";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile
  home.packages = with pkgs; [
    # Additional utilities
    tree
    jq
    yq
    ncdu
    neofetch
  ];

  # This value determines the Home Manager release
  home.stateVersion = "24.05";
}
