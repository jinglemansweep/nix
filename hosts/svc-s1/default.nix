# Local Proxmox VM (svc-s1): Docker/Podman runner for container workloads
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "svc-s1";

  services.qemuGuest.enable = true;

  custom.docker-stacks.enable = true;
}
