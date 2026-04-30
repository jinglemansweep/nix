# Browsers: Firefox and Chromium with extensions and privacy settings
{ config, pkgs, lib, ... }:

{
  programs.chromium = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    package = null; # System Firefox used
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    profiles.default = {
      isDefault = true;
      extensions.packages = [
        pkgs.nur.repos.rycee.firefox-addons.ublock-origin
        pkgs.nur.repos.rycee.firefox-addons.bitwarden
      ];
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "Cloud";
                bookmarks = [
                  { name = "GitHub"; url = "https://github.com"; }
                  { name = "Infisical"; url = "https://app.infisical.com"; }
                  { name = "Backblaze"; url = "https://secure.backblaze.com/b2_buckets.htm"; }
                ];
              }
              { name = "Home Assistant"; url = "https://hass.apps.ptre.es"; }
              { name = "NAS"; url = "https://nas.apps.ptre.es"; }
              {
                name = "Proxmox";
                bookmarks = [
                  { name = "PVM1"; url = "https://pvm1.apps.ptre.es"; }
                  { name = "PVM2"; url = "https://pvm2.apps.ptre.es"; }
                  { name = "PVM3"; url = "https://pvm3.apps.ptre.es"; }
                ];
              }
              {
                name = "IPNet";
                bookmarks = [
                  { name = "GitHub"; url = "https://github.com/ipnet-mesh"; }
                  { name = "Website"; url = "https://ipnt.uk"; }
                  { name = "Beta"; url = "https://beta.ipnt.uk"; }
                ];
              }
            ];
          }
        ];
      };
      settings = {
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.send_pings" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
      };
    };
  };

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
