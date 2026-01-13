# Docker: daemon with Compose and Buildx, weekly auto-prune
{ config, pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.docker-buildx
  ];
}
