# Proxmox VM: headless dev server with nix-ld for VS Code Remote SSH
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "dev";
    firewall.allowedTCPPorts = [ 22 80 443 3000 5173 8000 8080 8081 8443 ];
  };

  services.qemuGuest.enable = true;
  programs.nix-ld.enable = true;
}
