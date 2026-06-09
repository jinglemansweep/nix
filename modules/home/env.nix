# Global environment variables: systemd user session vars from SOPS secrets
{ config, pkgs, lib, ... }:

{
  # Create environment.d conf file from SOPS secrets
  sops.templates."50-nix.conf" = {
    content = ''
      CONTEXT7_API_KEY=${config.sops.placeholder.context7_api_key}
      ZAI_API_KEY=${config.sops.placeholder.zai_api_key}
    '';
    path = "${config.home.homeDirectory}/.config/environment.d/50-nix.conf";
  };

  # Ensure environment.d directory exists
  xdg.configFile."environment.d/.keep".text = "";
}
