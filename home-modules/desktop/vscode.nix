{ config, pkgs, lib, ... }:

{
  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/dev/dotfiles/nix/config/settings.json";

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
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
  };
}
