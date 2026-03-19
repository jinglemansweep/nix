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

  fileSystems."/mnt/nfs/temp" = {
    device = "${userConfig.nfsHost}:/volume1/temp";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "_netdev"
      "x-systemd.device-timeout=10s"
      "x-systemd.mount-timeout=10s"
      "x-systemd.idle-timeout=300"
      "soft"
      "timeo=100"
      "retrans=1"
    ];
  };
}
