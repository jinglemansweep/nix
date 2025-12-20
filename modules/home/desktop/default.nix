{ config, pkgs, lib, ... }:

{
  imports = [
    ./browsers.nix
    ./vscode.nix
    ./gnome.nix
  ];

  home.packages = [
    # 3D printing
    pkgs.cura-appimage

    # Office suite
    pkgs.libreoffice

    # Graphics editors
    pkgs.mtpaint
    pkgs.gimp

    # Terminal emulators (additional to gnome-terminal)
    pkgs.rxvt-unicode
  ];
}
