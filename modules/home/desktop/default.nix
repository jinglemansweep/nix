# Desktop environment: imports desktop modules and configures alacritty terminal
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

  # TODO: mtpaint broken in nixpkgs (incompatible with libpng 1.6.52)

  services.udiskie.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      env.WINIT_X11_SCALE_FACTOR = "1";
      window.padding = { x = 8; y = 8; };
      font.size = 12.0;
      mouse.bindings = [
        { mouse = "Middle"; action = "PasteSelection"; }
      ];
      scrolling.multiplier = 3;
    };
  };
}
