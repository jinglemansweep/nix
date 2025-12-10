{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    extensions = with pkgs.vscode-extensions; [
      # Remote Development
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit

      # Docker
      ms-azuretools.vscode-docker

      # Terraform
      hashicorp.terraform

      # YAML
      redhat.vscode-yaml
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Claude Code (from marketplace)
      {
        name = "claude-dev";
        publisher = "saoudrizwan";
        version = "3.2.2";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      }
      # Remote Server
      {
        name = "remote-server";
        publisher = "ms-vscode";
        version = "1.5.2024051409";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      }
    ];

    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";
      "editor.fontLigatures" = true;
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.minimap.enabled" = false;
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "terminal.integrated.fontSize" = 13;
      "workbench.colorTheme" = "Default Dark+";
      "git.autofetch" = true;
    };
  };
}
