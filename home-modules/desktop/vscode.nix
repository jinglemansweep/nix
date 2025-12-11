{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Remote
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
        {
          name = "claude-code";
          publisher = "anthropic";
          version = "2.0.65";
          sha256 = "07xjzf7691l067bbaw77595w88bpnmh3h4v2wsb4ax18ds063rwa";
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
        "terminal.integrated.suggest.enabled" = false;
        "workbench.colorTheme" = "Default Dark+";
        "git.autofetch" = true;
        "claudeCode.preferredLocation" = "panel";
        "claudeCode.claudeProcessWrapper" = "/etc/profiles/per-user/${config.home.username}/bin/claude";
      };
    };
  };
}
