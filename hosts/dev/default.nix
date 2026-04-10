# Proxmox VM: headless dev server
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "dev";
    firewall.allowedTCPPorts = [ 8000 8080 9090 9093 ];
  };

  services.qemuGuest.enable = true;
}
