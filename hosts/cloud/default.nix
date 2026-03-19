# Cloud Root server: Docker runner for Swarm/Compose workloads
{ config, pkgs, lib, inputs, userConfig, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Cloud VMs use BIOS boot, not UEFI — override systemd-boot from common config
  boot.loader = {
    systemd-boot.enable = lib.mkForce false;
    efi.canTouchEfiVariables = lib.mkForce false;
    grub = {
      enable = true;
      device = "/dev/sda";
    };
  };

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
