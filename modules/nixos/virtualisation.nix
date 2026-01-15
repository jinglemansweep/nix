# Virtualisation: Docker and Podman with Compose, Buildx, and weekly auto-prune
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

  # Ensure docker starts on boot (workaround for proxmox image)
  systemd.services.docker.wantedBy = [ "multi-user.target" ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.docker-buildx
  ];
}
