{ pkgs, ... }:

{
  imports = [
    ./browsers.nix
    ./gnome.nix
    ./media.nix
    ./vscode.nix
    ./zed.nix
  ];

  home.packages = [
    # 3D printing
    pkgs.cura-appimage

    # Dev
    pkgs.thonny
    pkgs.tiled

    # Office suite
    pkgs.libreoffice

    # Graphics editors
    # pkgs.mtpaint  # TODO: Broken in nixpkgs - incompatible with libpng 1.6.52
    pkgs.gimp

    # Terminal emulators (additional to gnome-terminal)
    pkgs.ghostty
    pkgs.rxvt-unicode
  ];

  # Automount removable media
  services.udiskie.enable = true;
}
