{ config, pkgs, lib, userConfig, ... }:

{
  fileSystems = {
    "/mnt/nfs/media" = {
      device = "${userConfig.nfsHost}:/volume1/media";
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
        "ro"
      ];
    };

    "/mnt/nfs/data" = {
      device = "${userConfig.nfsHost}:/volume1/data";
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

    "/mnt/nfs/backup" = {
      device = "${userConfig.nfsHost}:/volume1/backup";
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

    "/mnt/nfs/temp" = {
      device = "${userConfig.nfsHost}:/volume1/temp";
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
  };
}
