# Global environment variables: systemd user session vars from SOPS secrets
{ config, pkgs, lib, ... }:

{
  # Overwrite old unified template — dev env vars moved to modules/home/shell/env.nix
  sops.templates."50-nix.conf" = {
    content = '''';
    path = "${config.home.homeDirectory}/.config/environment.d/50-nix.conf";
  };
}
