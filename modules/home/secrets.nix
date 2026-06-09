# SOPS secrets: age-encrypted secrets with sops-nix
{ config, pkgs, lib, userConfig, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/shared.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "home_lab_nfs_host" = { };
      "home_lab_nfs_root" = { };
      "home_lab_traefik_domain" = { };
      "context7_api_key" = { };
      "zai_api_key" = { };
    };
  };

  home.packages = [
    pkgs.sops
    pkgs.age
  ];
}
