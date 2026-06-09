# Global environment variables: systemd user session vars from SOPS secrets
{ config, pkgs, lib, ... }:

{
  # Ensure environment.d directory exists for SOPS templates
  xdg.configFile."environment.d/.keep".text = "";
}
