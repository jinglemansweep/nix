{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "hp-elitedesk-800g2";

  # Desktop-optimized power settings (no power saving needed)
  powerManagement.cpuFreqGovernor = "performance";

  # Intel graphics (HP EliteDesk 800 G2 has Intel HD Graphics 530)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Bluetooth (if present)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Firmware updates
  services.fwupd.enable = true;
}
