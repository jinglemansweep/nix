{ config
, pkgs
, lib
, ...
}:

{
  home = {
    packages = [
      # Python (use nix-shell for other versions)
      pkgs.python3
      pkgs.python3Packages.pip
      pkgs.python3Packages.virtualenv
      pkgs.python3Packages.pipx

      # Node.js (npm and npx included)
      pkgs.nodejs

      # Go
      pkgs.go
      pkgs.gopls
      pkgs.gotools

      # Nix
      pkgs.nil

      # Language servers
      pkgs.pyright # Python
      pkgs.typescript-language-server # TypeScript/JavaScript
      pkgs.yaml-language-server # YAML
      pkgs.terraform-ls # Terraform
      pkgs.dockerfile-language-server # Docker
      pkgs.bash-language-server # Bash/Shell
      pkgs.vscode-langservers-extracted # ESLint, HTML, CSS, JSON

      # Linters
      pkgs.eslint

      # Build tools
      pkgs.gnumake
      pkgs.gcc
      pkgs.pkg-config
      pkgs.cmake
      pkgs.autoconf
      pkgs.automake
      pkgs.libtool

      # AI CLI tools
      pkgs.claude-code
      pkgs.codex
      pkgs.gemini-cli
      pkgs.opencode

      # MQTT
      pkgs.mosquitto

      # Testing
      pkgs.playwright-driver.browsers
    ];

    # Environment variables
    sessionVariables = {
      GOPATH = "$HOME/go";
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_NODEJS_PATH = "${pkgs.nodejs}/bin/node";
    };

    # PATH additions
    sessionPath = [
      "$HOME/.local/bin" # pipx
      "$HOME/.npm-global/bin" # npm global
      "$HOME/go/bin" # go
    ];

    # Config files
    file = {
      # npm global config
      ".npmrc".text = ''
        prefix=~/.npm-global
      '';

      # Claude Code dotfiles
      ".claude/commands" = {
        source = ../../../dotfiles/claude/commands;
        recursive = true;
      };
      ".claude/agents" = {
        source = ../../../dotfiles/claude/agents;
        recursive = true;
      };
      ".claude/skills" = {
        source = ../../../dotfiles/claude/skills;
        recursive = true;
      };
      ".claude/CLAUDE.md".source = ../../../dotfiles/claude/CLAUDE.md;
      ".claude/settings.json".source = ../../../dotfiles/claude/settings.json;
      ".claude/mcp_settings.json".source = ../../../dotfiles/claude/mcp_settings.json;
    };
  };
}
