{ config, pkgs, lib, ... }:

{
  home.packages = [
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
  home.sessionVariables = {
    GOPATH = "$HOME/go";
  };

  # PATH additions
  home.sessionPath = [
    "$HOME/.local/bin"      # pipx
    "$HOME/.npm-global/bin" # npm global
    "$HOME/go/bin"          # go
  ];

  # npm global config
  home.file.".npmrc".text = ''
    prefix=~/.npm-global
  '';
}
