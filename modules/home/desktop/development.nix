# Development editors: VSCode and Zed configuration
{ config, pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
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
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "claude-code";
          publisher = "anthropic";
          version = "2.0.65";
          sha256 = "17g3r715p80jqdh0ifvifb3ly0sg5i21cjrs0dqig0448l844xlw";
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
        "workbench.startupEditor" = "none";
        "git.autofetch" = true;
        "claudeCode.preferredLocation" = "panel";
        "claudeCode.claudeProcessWrapper" = "/etc/profiles/per-user/${config.home.username}/bin/claude";
        "nix.serverPath" = "nil";
      };
    };
  };

  programs.zed-editor = {
    enable = true;

    extensions = [ "nix" "toml" "dockerfile" "make" "html" ];
    extraPackages = [ pkgs.nixd ];

    userSettings = {
      theme = "One Dark";
      ui_font_size = 16;
      buffer_font_size = 14;
      title_bar.show_menus = false;
      telemetry = { diagnostics = false; metrics = false; };
      vim_mode = false;
      format_on_save = "off";
      # Fix flickering on Sway
      gpu = {
        backend = "gl";
      };
    };
  };
}
