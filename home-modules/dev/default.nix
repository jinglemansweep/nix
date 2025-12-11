{ config, pkgs, lib, ... }:

{
  imports = [
    ./python.nix
    ./node.nix
    ./go.nix
  ];

  # Build tools
  home.packages = with pkgs; [
    gnumake
    gcc
    pkg-config
    cmake
    autoconf
    automake
    libtool

    # AI Coding Assistants (CLI)
    claude-code
    gemini-cli
    opencode

    # MQTT
    mosquitto
  ];
}
