# Development environment variables: systemd user session vars from SOPS secrets
{ config, pkgs, lib, ... }:
{
  sops.templates."50-dev.conf" = {
    content = ''
      CONTEXT7_API_KEY=${config.sops.placeholder.context7_api_key}
      ZAI_API_KEY=${config.sops.placeholder.zai_api_key}
    '';
    path = "${config.home.homeDirectory}/.config/environment.d/50-dev.conf";
  };
}
