# SOPS secrets: age-encrypted secrets with sops-nix
{ config, pkgs, lib, userConfig, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      "home_lab_nfs_host" = { };
      "home_lab_nfs_root" = { };
      "home_lab_traefik_domain" = { };
      "infisical_project_id" = { };
      "infisical_env" = { };
      "context7_api_key" = { };
      "zai_api_key" = { };
    };
  };

  home.packages = [
    pkgs.sops
    pkgs.age
  ];
}
