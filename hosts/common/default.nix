# Shared NixOS base: bootloader, networking, locale, SSH, and user setup
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../modules/nixos/systemd
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      download-buffer-size = 128 * 1024 * 1024; # 128MB
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  time.timeZone = "Europe/London";
  console.keyMap = "uk";

  programs.nix-ld.enable = true;

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    tailscale.enable = true;
  };

  hardware.bluetooth.settings = {
    General = {
      Class = "0x002540";
    };
  };

  # Disable bluetooth HID input plugin (prevents conflicts with other input methods)
  systemd.services.bluetooth.serviceConfig.ExecStart = [
    "" # Clear existing ExecStart
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd -P input"
  ];

  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.bash;
    hashedPassword = "$6$/ZGKJRex3fGzQF7r$u/wtRd8LWjlpsSSSt1NcpNQCzI2Y0oLaVCgqUHCZY2HBTpnQrProXQo8ueiMHA/Nv8bdCmg2Ftp0AUaxHuvFA1";
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/${userConfig.githubUsername}.keys";
        sha256 = "02bsbcicl1745zvb4asqm197s23i76i31xgiba65ziq7skdy24m7";
      })
    ];
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.wget
    pkgs.curl
    pkgs.dnsutils
  ];

  system.stateVersion = "24.05";
}
