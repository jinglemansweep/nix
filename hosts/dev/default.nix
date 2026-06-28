# Proxmox VM: headless dev server
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "dev";

  services.qemuGuest.enable = true;
}
