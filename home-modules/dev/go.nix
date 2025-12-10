{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    go
    gopls # Go language server
    gotools # Additional Go tools
  ];

  # Go environment variables
  home.sessionVariables = {
    GOPATH = "$HOME/go";
  };

  # Add Go bin to PATH
  home.sessionPath = [ "$HOME/go/bin" ];
}
