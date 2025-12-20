{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-latitude-7420
  ];

  networking = {
    hostName = "latitude";
    firewall = {
      allowedTCPPorts = [ 22 80 443 3000 8000 8080 8081 8443 ];
    };
  };

  # Enable desktop environments
  desktop.gnome.enable = true;
  desktop.i3.enable = true;

  # Services
  services = {
    # Power management for laptop (disable power-profiles-daemon which conflicts with TLP)
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
    # Thermald for Intel CPUs
    thermald.enable = true;
    # Laptop-specific services
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
    };
    # Bluetooth
    blueman.enable = true;
    # Firmware updates
    fwupd.enable = true;
  };

  # Intel graphics
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
}
