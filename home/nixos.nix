# NixOS desktop Home Manager entry: base + docker + development + desktop
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
    ../modules/home/shell/base.nix
    ../modules/home/shell/docker.nix
    ../modules/home/shell/dev.nix
    ../modules/home/desktop
  ];
}
