{ config, pkgs, lib, ... }:

{
  imports = [
    ./browsers.nix
    ./gnome.nix
    ./media.nix
    ./vscode.nix
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
