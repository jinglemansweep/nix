# Cloud Root server: Docker runner for Swarm/Compose workloads
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking = {
    hostName = "ipnet-s1";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 51820 ];
    };
  };

  services.qemuGuest.enable = true;
}
