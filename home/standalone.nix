{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
  ];

  # Standalone Home Manager configuration for ChromeOS/WSL
  # Does NOT include desktop applications (no GUI)

  # Target generic Linux
  targets.genericLinux.enable = true;

  # Enable XDG base directories
  xdg.enable = true;
}
