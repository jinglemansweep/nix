# Proxmox VM: headless dev server
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "dev";
    firewall.enable = lib.mkForce false;
  };

  services.qemuGuest.enable = true;
}
