# Virtualisation: Docker and Podman with Compose, Buildx, and weekly auto-prune
{ config, pkgs, lib, userConfig, ... }:

{
  custom.systemd.docker-backup.enable = true;

  fileSystems."/mnt/nfs/lab" = {
    device = "${userConfig.nfsHost}:/volume1/lab";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "_netdev"
      "x-systemd.device-timeout=10s"
      "x-systemd.mount-timeout=10s"
      "x-systemd.idle-timeout=300"
      "soft"
      "timeo=100"
      "retrans=1"
    ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Ensure docker starts on boot (workaround for proxmox image)
  systemd.services.docker.wantedBy = [ "multi-user.target" ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.docker-buildx
  ];
}
