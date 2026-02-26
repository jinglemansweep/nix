# Desktop additions: GUI, audio, printing, scanning, fonts, and mounts
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ../../modules/nixos/virtualisation.nix
    ../../modules/nixos/desktop/common.nix
    ../../modules/nixos/desktop/gnome.nix
    ../../modules/nixos/desktop/sway.nix
    ../../modules/nixos/mounts.nix
  ];

  networking.wireguard.enable = true;

  services = {
    xserver.xkb = {
      layout = "gb";
      variant = "";
    };
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

  users.users.${userConfig.username}.extraGroups = [ "podman" "dialout" "scanner" "lp" "disk" ];

  security.rtkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id.indexOf("org.freedesktop.udisks2.") == 0) && subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
      pkgs.liberation_ttf
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.source-code-pro
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Fira Code" ];
    };
  };

  environment.systemPackages = [
    pkgs.openvpn
    pkgs.wireguard-tools
    pkgs.cifs-utils
    pkgs.nfs-utils
  ];
}
