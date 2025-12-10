{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
    ../home-modules/desktop
  ];

  # NixOS-specific home configuration
  # Desktop applications are included via home-modules/desktop
}
