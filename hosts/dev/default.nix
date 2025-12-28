{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "dev";
    firewall = {
      allowedTCPPorts = [ 22 80 443 3000 5173 8000 8080 8081 8443 ];
    };
  };

  # Proxmox/QEMU guest support
  services.qemuGuest.enable = true;

  # Enable nix-ld for VS Code Remote SSH support
  programs.nix-ld.enable = true;

  # No desktop environments - headless server
  # desktop.gnome.enable and desktop.i3.enable default to false
}
