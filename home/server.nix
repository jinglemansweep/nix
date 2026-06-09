# NixOS server Home Manager entry: base + docker + development, no desktop
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
}
