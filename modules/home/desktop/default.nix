{ pkgs, ... }:

{
  imports = [
    ./browsers.nix
    ./gnome.nix
    ./i3.nix
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
    pkgs.pinta
    pkgs.gimp

    # System utilities
    pkgs.baobab

    # PDF viewer
    pkgs.evince

    # Terminal emulators (additional to gnome-terminal)
    pkgs.rxvt-unicode
  ];

  # Automount removable media
  services.udiskie.enable = true;

  # Terminal emulator
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        WINIT_X11_SCALE_FACTOR = "1";
      };
      window = {
        padding = {
          x = 8;
          y = 8;
        };
      };
      font = {
        size = 12.0;
      };
      mouse = {
        bindings = [
          # Disable natural/reverse scrolling
          { mouse = "Middle"; action = "PasteSelection"; }
        ];
      };
      scrolling = {
        multiplier = 3;
      };
    };
  };
}
