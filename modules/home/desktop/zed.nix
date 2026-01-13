# Zed editor: temporarily disabled, config preserved
{ config, pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = false;

    extensions = [ "nix" "toml" "dockerfile" "make" "html" ];
    extraPackages = [ pkgs.nixd ];

    userSettings = {
      theme = "One Dark";
      ui_font_size = 16;
      buffer_font_size = 14;
      buffer_font_family = "JetBrainsMono Nerd Font";
      title_bar.show_menus = true;
      telemetry = { diagnostics = false; metrics = false; };
      vim_mode = false;
    };
  };
}
