# Global environment variables: systemd user session vars from SOPS secrets
{ config, pkgs, lib, ... }:

{
  # Create environment.d conf file from SOPS secrets
  sops.templates."50-nix.conf" = {
    content = ''
      LAB_NFS_HOST=${config.sops.placeholder.home_lab_nfs_host}
      LAB_NFS_ROOT=${config.sops.placeholder.home_lab_nfs_root}
      LAB_TRAEFIK_DOMAIN=${config.sops.placeholder.home_lab_traefik_domain}
      INFISICAL_PROJECT_ID=${config.sops.placeholder.infisical_project_id}
      INFISICAL_ENV=${config.sops.placeholder.infisical_env}
    '';
    path = "${config.home.homeDirectory}/.config/environment.d/50-nix.conf";
  };

  # Ensure environment.d directory exists
  xdg.configFile."environment.d/.keep".text = "";
}
