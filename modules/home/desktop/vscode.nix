# VSCode editor with extensions and settings
{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          ms-vscode-remote.remote-containers
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode-remote.remote-wsl
          redhat.ansible
          ms-azuretools.vscode-docker
          github.vscode-github-actions
          bbenoist.nix
          ms-python.python
          ms-python.black-formatter
          hashicorp.terraform
          redhat.vscode-yaml

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
        "workbench.startupEditor" = "none";
        "git.autofetch" = true;
        "update.showReleaseNotes" = false;
        "claudeCode.preferredLocation" = "panel";
        "claudeCode.claudeProcessWrapper" = "${config.home.profileDirectory}/bin/claude";
        "nix.serverPath" = "nixd";
      };
    };
  };
}
