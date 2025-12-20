{ config, pkgs, lib, ... }:

{
  home = {
    packages = [
      # Python
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
    ];

    # Environment variables
    sessionVariables = {
      GOPATH = "$HOME/go";
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
    };
  };
}
