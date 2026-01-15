# Docker tools: container management CLI
{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.lazydocker
  ];
}
