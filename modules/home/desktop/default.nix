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

  # Desktop packages now installed at NixOS level for all users:
  # cura-appimage, thonny, tiled, libreoffice, pinta, gimp, baobab, evince, rxvt-unicode
  # mtpaint: TODO: Broken in nixpkgs - incompatible with libpng 1.6.52

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
