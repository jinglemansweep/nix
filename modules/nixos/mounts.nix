# NFS mounts: automounted Synology NAS shares
{ config, pkgs, lib, userConfig, ... }:

let
  nfsOpts = [
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
in
{
  fileSystems = {
    "/mnt/nfs/lab" = {
      device = "${userConfig.nfsHost}:/volume1/lab";
      fsType = "nfs";
      options = nfsOpts;
    };

    "/mnt/nfs/media" = {
      device = "${userConfig.nfsHost}:/volume1/media";
      fsType = "nfs";
      options = nfsOpts ++ [ "ro" ];
    };

    "/mnt/nfs/data" = {
      device = "${userConfig.nfsHost}:/volume1/data";
      fsType = "nfs";
      options = nfsOpts;
    };

    "/mnt/nfs/backup" = {
      device = "${userConfig.nfsHost}:/volume1/backup";
      fsType = "nfs";
      options = nfsOpts;
    };

    "/mnt/nfs/temp" = {
      device = "${userConfig.nfsHost}:/volume1/temp";
      fsType = "nfs";
      options = nfsOpts;
    };
  };
}
