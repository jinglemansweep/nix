{ config, pkgs, lib, ... }:

{
  # Firefox with extensions
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
      ];
      settings = {
        # Privacy settings
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.send_pings" = false;

        # Disable telemetry
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;

        # Homepage
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
      };
    };
  };

  # Google Chrome
  home.packages = with pkgs; [
    google-chrome
  ];

  # Set Firefox as default browser
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
