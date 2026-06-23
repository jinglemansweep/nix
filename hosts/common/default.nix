# Shared NixOS base: bootloader, networking, locale, SSH, and user setup
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../modules/nixos/secrets.nix
    ../../modules/nixos/systemd
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      download-buffer-size = 128 * 1024 * 1024; # 128MB
      warn-dirty = false;
      extra-substituters = [
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  custom.systemd.nix-gc.enable = true;

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
    wireguard.enable = true;
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

  programs.nano.enable = false;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib # numpy
      libgcc # sqlalchemy
    ];
  };

  environment.variables.EDITOR = "nvim";

  services = {
    openssh = {
      enable = true;
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
          permissions = "0600";
        }
      ];
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    tailscale.enable = true;
  };

  # Serial devices: make USB/ACM serial ports world-accessible on all hosts
  services.udev.extraRules = ''
    KERNEL=="ttyUSB[0-9]*", MODE="0666"
    KERNEL=="ttyACM[0-9]*", MODE="0666"
  '';

  systemd.services.docker = lib.mkIf config.virtualisation.docker.enable {
    wantedBy = [ "multi-user.target" ];
  };

  hardware.bluetooth.settings = {
    General = {
      Class = "0x002540";
    };
  };

  # Disable bluetooth HID input plugin (prevents conflicts with other input methods)
  systemd.services.bluetooth = lib.mkIf config.hardware.bluetooth.enable {
    serviceConfig.ExecStart = [
      ""
      "${pkgs.bluez}/libexec/bluetooth/bluetoothd -P input"
    ];
  };

  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.bash;
    hashedPasswordFile = config.sops.secrets.user_password_hash.path;
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
    pkgs.bubblewrap
    pkgs.openvpn
    pkgs.wireguard-tools
    pkgs.cifs-utils
    pkgs.nfs-utils
  ];

  system.stateVersion = "24.05";
}
