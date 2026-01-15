# Proxmox VM: minimal Docker runner for Swarm/Compose workloads
{ config, pkgs, lib, inputs, userConfig, ... }:

{
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

  networking.firewall = {
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

  services = {
    qemuGuest.enable = true;
    cloud-init = {
      enable = true;
      network.enable = lib.mkForce false;
      settings = {
        users = [ ]; # Don't manage users
        disable_root = true;
        ssh_pwauth = false;
      };
    };
  };
}
