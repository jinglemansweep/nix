# Proxmox VM: headless dev server
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "dev";
    firewall.allowedTCPPorts = [ 1883 4096 8000 8080 9090 9093 ];
  };

  services.qemuGuest.enable = true;
}
