{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.python3Packages.virtualenv
    pkgs.python3Packages.pipx
  ];

  # Add pipx bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];
}
