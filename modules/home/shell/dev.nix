# Development tools: languages, LSPs, build tools, DevOps, AI CLI, embedded, and dev secrets
{ config, pkgs, projectLib, ... }:

{
  sops.secrets = {
    "context7_api_key" = {
      sopsFile = ../../../secrets/dev.yaml;
    };
    "zai_api_key" = {
      sopsFile = ../../../secrets/dev.yaml;
    };
  };

  sops.templates."50-dev.conf" = {
    content = ''
      CONTEXT7_API_KEY=${config.sops.placeholder.context7_api_key}
      ZAI_API_KEY=${config.sops.placeholder.zai_api_key}
    '';
    path = "${config.home.homeDirectory}/.config/environment.d/50-dev.conf";
  };

  home = {
    packages = [
      # Languages
      pkgs.python3
      pkgs.python3Packages.pip
      pkgs.python3Packages.virtualenv

      pkgs.python3Packages.pyyaml
      pkgs.poetry
      pkgs.uv
      pkgs.ruff
      pkgs.nodejs
      pkgs.rustc
      pkgs.cargo
      pkgs.go

      # Language Servers
      pkgs.gopls
      pkgs.nil
      pkgs.nixd
      pkgs.pyright
      pkgs.typescript-language-server
      pkgs.yaml-language-server
      pkgs.terraform-ls
      pkgs.dockerfile-language-server
      pkgs.bash-language-server
      pkgs.vscode-langservers-extracted

      # Build Tools
      pkgs.gnumake
      pkgs.gcc
      pkgs.pkg-config
      pkgs.cmake
      pkgs.autoconf
      pkgs.automake
      pkgs.libtool
      pkgs.eslint
      pkgs.shellcheck
      pkgs.yamllint
      pkgs.markdownlint-cli

      # DevOps / Infrastructure
      pkgs.opentofu
      pkgs.terragrunt
      pkgs.pre-commit
      pkgs.gh
      pkgs.github-copilot-cli
      pkgs.lazygit
      pkgs.awscli2
      pkgs.kubectl
      pkgs.kubernetes-helm
      pkgs.k9s

      # Database Clients
      pkgs.postgresql
      pkgs.mariadb
      pkgs.redis
      pkgs.sqlite
      pkgs.supabase-cli
      # pkgs.mongosh  # TODO: Broken in nixpkgs - npm cache out of sync

      # AI CLI Tools
      pkgs.claude-code
      pkgs.codex
      pkgs.gemini-cli
      pkgs.opencode

      # MicroPython / Embedded
      pkgs.picocom
      pkgs.esptool
      pkgs.picotool
      pkgs.mpremote
      pkgs.mosquitto
      pkgs.esphome

      # Other
      pkgs.playwright-driver.browsers
    ];

    sessionVariables = {
      GOPATH = "$HOME/go";
      OPENCODE_DISABLE_CLAUDE_CODE = "1";
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_NODEJS_PATH = "${pkgs.nodejs}/bin/node";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.npm-global/bin"
      "$HOME/go/bin"
    ];

    file = {
      ".npmrc".text = "prefix=~/.npm-global\n";
    };

  };

  programs.bash = {
    shellAliases = {
      terraform = "tofu";
      k = "kubectl";
    };
    initExtra = ''
      # Kubectl completion
      source <(kubectl completion bash)
      complete -o default -F __start_kubectl k

    '';
  };
}
