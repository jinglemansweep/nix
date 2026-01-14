# Shared NixOS configuration: bootloader, networking, locale, services, and user setup
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../modules/nixos/docker.nix
    ../../modules/nixos/desktop/common.nix
    ../../modules/nixos/desktop/gnome.nix
    ../../modules/nixos/desktop/i3.nix
    ../../modules/nixos/mounts.nix
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
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
    wireguard.enable = true;
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

  services = {
    xserver.xkb = {
      layout = "gb";
      variant = "";
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    tailscale.enable = true;
    udisks2.enable = true;
    openvpn.servers = { };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = [
        pkgs.brlaser
        pkgs.brgenml1lpr
        pkgs.brgenml1cupswrapper
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  hardware.sane = {
    enable = true;
    brscan4.enable = true;
  };

  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [ "networkmanager" "wheel" "docker" "podman" "dialout" "scanner" "lp" ];
    shell = pkgs.bash;
    initialHashedPassword = "$6$/ZGKJRex3fGzQF7r$u/wtRd8LWjlpsSSSt1NcpNQCzI2Y0oLaVCgqUHCZY2HBTpnQrProXQo8ueiMHA/Nv8bdCmg2Ftp0AUaxHuvFA1";
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/${userConfig.githubUsername}.keys";
        sha256 = "0qv6mxw3jpakcvmvgn39yzpfzgs41hvpwv00k0z6pvybmfwb3sqp";
      })
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  security.rtkit.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
      pkgs.liberation_ttf
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.jetbrains-mono
      pkgs.source-code-pro
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrains Mono" ];
    };
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.wget
    pkgs.curl
    pkgs.openvpn
    pkgs.wireguard-tools
    pkgs.cifs-utils
    pkgs.nfs-utils
  ];

  system.stateVersion = "24.05";
}
