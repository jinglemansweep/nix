# NixOS server Home Manager entry: base + docker + development, no desktop
{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./common
    ../modules/home/shell/base.nix
    ../modules/home/shell/docker.nix
    ../modules/home/shell/development.nix
  ];

  home.packages = [ pkgs.vscode ];

  systemd.user.services.code-tunnel = {
    Unit.Description = "VS Code Tunnel";
    Service = {
      ExecStart = "${pkgs.vscode}/bin/code tunnel --accept-server-license-terms";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
