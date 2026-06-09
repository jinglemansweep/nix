# SOPS secrets: age-encrypted secrets with sops-nix
{ config, pkgs, lib, userConfig, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/common.yaml;
    age.keyFile = "/var/lib/sops-nix/host-age-key";
    secrets = { };
  };

  home.packages = [
    pkgs.sops
    pkgs.age
  ];
}
