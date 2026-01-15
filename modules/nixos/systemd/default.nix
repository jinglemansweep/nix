# Custom systemd units: import individual unit modules as needed
{ config, lib, pkgs, ... }:

{
  imports = [
    ./nix-gc.nix
    ./docker-backup.nix
  ];
}
