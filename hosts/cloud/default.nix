# Cloud Root server: Docker runner for Swarm/Compose workloads
{ config, pkgs, lib, inputs, userConfig, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "cloud";
    firewall = {
      # Docker Swarm ports
      allowedTCPPorts = [
        2377 # Swarm management
        7946 # Container network discovery
      ];
      allowedUDPPorts = [
        7946 # Container network discovery
        4789 # Overlay network traffic
      ];
    };
  };

  services.qemuGuest.enable = true;
}
