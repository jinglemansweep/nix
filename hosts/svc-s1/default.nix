# Local Proxmox VM (svc-s1): Docker/Podman runner for container workloads
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "svc-s1";
    firewall = {
      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ 51820 ];
    };
  };

  services.qemuGuest.enable = true;
}
