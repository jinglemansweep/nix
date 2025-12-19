{ config, pkgs, lib, ... }:

{
  # Docker with Compose and Buildx
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Docker CLI tools
  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.docker-buildx
  ];
}
