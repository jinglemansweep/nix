# Docker host directory setup: persistent paths for volumes and stacks
{ ... }:

{
  systemd.tmpfiles.rules = [
    "d /mnt/docker/volumes 0777 root root -"
    "d /mnt/docker/stacks 0755 root root -"
  ];
}
