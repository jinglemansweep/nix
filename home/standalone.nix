# Standalone Home Manager entry for ChromeOS/WSL: shell tools only
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
  ];

  targets.genericLinux.enable = true;
  xdg.enable = true;
}
