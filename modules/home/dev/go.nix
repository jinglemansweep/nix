{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.go
    pkgs.gopls # Go language server
    pkgs.gotools # Additional Go tools
  ];

  # Go environment variables
  home.sessionVariables = {
    GOPATH = "$HOME/go";
  };

  # Add Go bin to PATH
  home.sessionPath = [ "$HOME/go/bin" ];
}
