# Standalone Home Manager entry for ChromeOS/WSL: base + docker + development
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
    ../modules/home/shell/base.nix
    ../modules/home/shell/docker.nix
    ../modules/home/shell/development.nix
    ../modules/home/shell/secrets.nix
    ../modules/home/shell/env.nix
  ];

  targets.genericLinux.enable = true;
  xdg.enable = true;
}
