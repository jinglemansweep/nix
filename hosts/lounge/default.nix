{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "lounge";

  # Enable desktop environments
  desktop.gnome.enable = true;
  desktop.i3.enable = true;

  # Desktop-optimized power settings (no power saving needed)
  powerManagement.cpuFreqGovernor = "performance";

  # Intel graphics (HP EliteDesk 800 G2 has Intel HD Graphics 530)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
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
