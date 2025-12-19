{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
    ../modules/home/desktop
  ];

  # NixOS-specific home configuration
  # Desktop applications are included via modules/home/desktop
}
