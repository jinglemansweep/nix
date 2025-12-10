{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../modules/docker.nix
    ../../modules/desktop/gnome.nix
    ../../modules/desktop/i3.nix
  ];

  # Nix settings
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Locale settings
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

  # Timezone
  time.timeZone = "Europe/London";

  # Console keymap
  console.keyMap = "uk";

  # X11 keymap
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # User account
  users.users.${userConfig.username} = {
    isNormalUser = true;
    description = userConfig.fullName;
    extraGroups = [ "networkmanager" "wheel" "docker" "podman" ];
    shell = pkgs.bash;
  };

  # OpenSSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Podman (alternative container runtime)
  virtualisation.podman = {
    enable = true;
    dockerCompat = false; # Don't alias docker to podman (Docker is default)
    defaultNetwork.settings.dns_enabled = true;
  };

  # VPN and networking
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # WireGuard support
  networking.wireguard.enable = true;

  # OpenVPN
  services.openvpn.servers = {
    # Placeholder - users can add their own configs
    # myVPN = {
    #   config = "config /path/to/config.ovpn";
    #   autoStart = false;
    # };
  };

  # Sound with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      source-code-pro
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Mono" ];
      };
    };
  };

  # System packages (minimal - most go in Home Manager)
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    openvpn
    wireguard-tools
  ];

  # This value determines the NixOS release
  system.stateVersion = "24.05";
}
