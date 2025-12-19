{ config, pkgs, lib, ... }:

{
  imports = [
    ./browsers.nix
    ./vscode.nix
    ./gnome.nix
  ];

  home.packages = [
    # Office suite
    pkgs.libreoffice

    # Graphics editors
    pkgs.mtpaint
    pkgs.gimp

    # Terminal emulators (additional to gnome-terminal)
    pkgs.rxvt-unicode
  ];
}
