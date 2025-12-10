{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Office suite
    libreoffice

    # Graphics editors
    mtpaint
    gimp

    # Terminal emulators (additional to gnome-terminal)
    rxvt-unicode
  ];
}
