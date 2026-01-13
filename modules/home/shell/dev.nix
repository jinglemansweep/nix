# Development tools: Python, Node.js, Go, language servers, build tools, and AI CLI
{ config, pkgs, lib, ... }:

{
  home = {
    packages = [
      pkgs.python3
      pkgs.python3Packages.pip
      pkgs.python3Packages.virtualenv
      pkgs.python3Packages.pipx
      pkgs.nodejs
      pkgs.go
      pkgs.gopls
      pkgs.gotools
      pkgs.nil
      pkgs.pyright
      pkgs.typescript-language-server
      pkgs.yaml-language-server
      pkgs.terraform-ls
      pkgs.dockerfile-language-server
      pkgs.bash-language-server
      pkgs.vscode-langservers-extracted
      pkgs.eslint
      pkgs.gnumake
      pkgs.gcc
      pkgs.pkg-config
      pkgs.cmake
      pkgs.autoconf
      pkgs.automake
      pkgs.libtool
      pkgs.sqlite
      pkgs.claude-code
      pkgs.codex
      pkgs.gemini-cli
      pkgs.opencode
      pkgs.mosquitto
      pkgs.picocom
      pkgs.esptool
      pkgs.picotool
      pkgs.mpremote
      pkgs.playwright-driver.browsers
    ];

    sessionVariables = {
      GOPATH = "$HOME/go";
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
}
