{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.pipx
  ];

  # Add pipx bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];
}
