{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    nodejs
    # npm and npx are included with nodejs
  ];

  # Add npm global bin to PATH
  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  # Configure npm to use a local directory for global packages
  home.file.".npmrc".text = ''
    prefix=~/.npm-global
  '';
}
