# Hardware configuration for Cloud Root server (replace after nixos-generate-config)
{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ ];

  # Placeholder filesystem layout - regenerate on target with nixos-generate-config
  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/sda1";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
