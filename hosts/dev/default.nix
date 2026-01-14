# Proxmox VM: headless dev server with nix-ld for VS Code Remote SSH
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
  programs.nix-ld.enable = true;
}
