# Desktop environment: imports desktop modules and configures alacritty terminal
{ pkgs, ... }:

{
  imports = [
    ./browsers.nix
    ./gnome.nix
    ./sway.nix
    ./media.nix
    ./development.nix
    ./emulators.nix
  ];

  # TODO: mtpaint broken in nixpkgs (incompatible with libpng 1.6.52)

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  services.udiskie.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      env.WINIT_X11_SCALE_FACTOR = "1";
      window.padding = { x = 8; y = 8; };
      font.size = 11.0;
      mouse.bindings = [
        { mouse = "Middle"; action = "PasteSelection"; }
      ];
      keyboard.bindings = [
        { key = "Return"; mods = "Shift"; chars = "\n"; }
      ];
      scrolling.multiplier = 3;
    };
  };
}
