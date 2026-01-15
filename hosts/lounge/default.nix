# HP EliteDesk 800 G2 Mini: desktop HTPC with Intel graphics and Bluetooth
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "lounge";
    firewall.enable = lib.mkForce false;
  };

  desktop.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  hardware = {
    graphics = {
      enable = true;
      extraPackages = [
        pkgs.intel-media-driver
        pkgs.intel-vaapi-driver
        pkgs.libva-vdpau-driver
        pkgs.libvdpau-va-gl
      ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    blueman.enable = true;
    fwupd.enable = true;
  };
}
