# Zed editor with format-on-save disabled (conflicts with Claude Code edits)
{ config, pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [ "nix" "toml" "dockerfile" "make" "html" ];
    extraPackages = [ pkgs.nixd ];

    userSettings = {
      theme = "One Dark";
      ui_font_size = 10;
      buffer_font_size = 10;
      buffer_font_family = "JetBrainsMono Nerd Font";
      title_bar.show_menus = false;
      telemetry = { diagnostics = false; metrics = false; };
      vim_mode = false;
      format_on_save = "off";
    };
  };
}
