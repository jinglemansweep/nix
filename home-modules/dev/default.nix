{ config, pkgs, lib, ... }:

{
  imports = [
    ./python.nix
    ./node.nix
    ./go.nix
  ];

  # Build tools
  home.packages = [
    pkgs.gnumake
    pkgs.gcc
    pkgs.pkg-config
    pkgs.cmake
    pkgs.autoconf
    pkgs.automake
    pkgs.libtool

    # AI Coding Assistants (CLI)
    pkgs.claude-code
    pkgs.codex
    pkgs.gemini-cli
    pkgs.github-copilot-cli
    pkgs.opencode

    # MQTT
    pkgs.mosquitto
  ];
}
