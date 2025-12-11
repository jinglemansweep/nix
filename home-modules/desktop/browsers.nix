{ config, pkgs, lib, ... }:

{
  # Firefox with extensions
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
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
              { name = "Home Assistant"; url = "https://hass.ptre.uk"; }
              { name = "NAS"; url = "https://nas.ptre.uk"; }
              {
                name = "Proxmox";
                bookmarks = [
                  { name = "PVM1"; url = "https://pvm1.ptre.uk"; }
                  { name = "PVM2"; url = "https://pvm2.ptre.uk"; }
                  { name = "PVM3"; url = "https://pvm3.ptre.uk"; }
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
