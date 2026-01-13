# NixOS desktop Home Manager entry: includes common config and desktop modules
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
    ../modules/home/desktop
  ];
}
