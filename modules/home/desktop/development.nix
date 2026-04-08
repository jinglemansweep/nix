# Development editors: Zed configuration
{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;

    extensions = [ "nix" "toml" "dockerfile" "make" "html" ];
    extraPackages = [ pkgs.nixd ];

    userSettings = {
      theme = "One Dark";
      ui_font_size = 16;
      buffer_font_size = 14;
      title_bar.show_menus = false;
      telemetry = { diagnostics = false; metrics = false; };
      vim_mode = false;
      format_on_save = "off";
      # Fix flickering on Sway
      gpu = {
        backend = "gl";
      };
    };
  };
}
