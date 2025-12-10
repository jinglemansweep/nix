# Hardware configuration for HP EliteDesk 800 G2 Mini
# NOTE: This is a template. Generate the actual configuration on the target
# hardware using: nixos-generate-config --show-hardware-config

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Filesystem configuration - UPDATE THESE UUIDs after installation
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-BOOT-UUID";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [
    # { device = "/dev/disk/by-uuid/REPLACE-WITH-SWAP-UUID"; }
  ];

  # Intel CPU
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Networking interface (may vary)
  networking.useDHCP = lib.mkDefault true;
}
