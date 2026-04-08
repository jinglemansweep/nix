# Development tools: languages, LSPs, build tools, DevOps, AI CLI, and embedded
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
        "update.showReleaseNotes" = false;
        "claudeCode.preferredLocation" = "panel";
        "claudeCode.claudeProcessWrapper" = "/etc/profiles/per-user/${config.home.username}/bin/claude";
        "nix.serverPath" = "nixd";
      };
    };
  };
  home = {
    packages = [
      # Languages
      pkgs.python3
      pkgs.python3Packages.pip
      pkgs.python3Packages.virtualenv
      pkgs.python3Packages.pipx
      pkgs.python3Packages.pyyaml
      pkgs.poetry
      pkgs.uv
      pkgs.ruff
      pkgs.nodejs
      pkgs.rustc
      pkgs.cargo
      pkgs.go
      pkgs.gotools

      # Language Servers
      pkgs.gopls
      pkgs.nil
      pkgs.nixd
      pkgs.pyright
      pkgs.typescript-language-server
      pkgs.yaml-language-server
      pkgs.terraform-ls
      pkgs.dockerfile-language-server
      pkgs.bash-language-server
      pkgs.vscode-langservers-extracted

      # Build Tools
      pkgs.gnumake
      pkgs.gcc
      pkgs.pkg-config
      pkgs.cmake
      pkgs.autoconf
      pkgs.automake
      pkgs.libtool
      pkgs.eslint
      pkgs.shellcheck
      pkgs.yamllint
      pkgs.markdownlint-cli

      # DevOps / Infrastructure
      pkgs.opentofu
      pkgs.terragrunt
      pkgs.pre-commit
      pkgs.gh
      pkgs.github-copilot-cli
      pkgs.lazygit
      pkgs.awscli2
      pkgs.kubectl
      pkgs.kubernetes-helm
      pkgs.k9s
      pkgs.infisical

      # Database Clients
      pkgs.postgresql
      pkgs.mariadb
      pkgs.redis
      pkgs.sqlite
      # pkgs.mongosh  # TODO: Broken in nixpkgs - npm cache out of sync

      # AI CLI Tools
      pkgs.claude-code
      pkgs.codex
      pkgs.gemini-cli
      pkgs.opencode

      # MicroPython / Embedded
      pkgs.picocom
      pkgs.esptool
      pkgs.picotool
      pkgs.mpremote
      pkgs.mosquitto
      pkgs.esphome

      # Other
      pkgs.playwright-driver.browsers
    ];

    sessionVariables = {
      GOPATH = "$HOME/go";
      OPENCODE_DISABLE_CLAUDE_CODE = "1";
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_NODEJS_PATH = "${pkgs.nodejs}/bin/node";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
      "$HOME/go/bin"
    ];

    file = {
      ".npmrc".text = "prefix=~/.npm-global\n";
      ".claude/commands" = { source = ../../../dotfiles/claude/commands; recursive = true; };
      ".claude/agents" = { source = ../../../dotfiles/claude/agents; recursive = true; };
      ".claude/skills" = { source = ../../../dotfiles/claude/skills; recursive = true; };
      ".claude/CLAUDE.md".source = ../../../dotfiles/claude/CLAUDE.md;
      ".claude/settings.json".source = ../../../dotfiles/claude/settings.json;
      ".claude/mcp_settings.json".source = ../../../dotfiles/claude/mcp_settings.json;
    };
  };

  xdg.configFile = {
    "opencode/opencode.json".source = ../../../dotfiles/opencode/opencode.json;
    "opencode/commands" = { source = ../../../dotfiles/opencode/commands; recursive = true; };
    "opencode/agents" = { source = ../../../dotfiles/opencode/agents; recursive = true; };
    "opencode/skills" = { source = ../../../dotfiles/opencode/skills; recursive = true; };
  };

  programs.bash = {
    shellAliases = {
      terraform = "tofu";
      k = "kubectl";
    };
    initExtra = ''
      # Kubectl completion
      source <(kubectl completion bash)
      complete -o default -F __start_kubectl k

      # Infisical alias
      alias secrets-infisical='infisical --silent --projectId ''${INFISICAL_PROJECT_ID} --env ''${INFISICAL_ENV}'
    '';
  };
}
