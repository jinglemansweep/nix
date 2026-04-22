# Development tools: languages, LSPs, build tools, DevOps, AI CLI, and embedded
{ pkgs, projectLib, ... }:

{
  home = {
    packages = [
      # Languages
      pkgs.python3
      pkgs.python3Packages.pip
      pkgs.python3Packages.virtualenv
      pkgs.python3Packages.pipx
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
      pkgs.infisical

      # Database Clients
      pkgs.postgresql
      pkgs.mariadb
      pkgs.redis
      pkgs.sqlite
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
      ".claude/CLAUDE.md".source = ../../../dotfiles/claude/CLAUDE.md;
      ".claude/settings.json".source = ../../../dotfiles/claude/settings.json;
      ".claude/mcp_settings.json".source = ../../../dotfiles/claude/mcp_settings.json;
    }
    // projectLib.files.mkFileMappings ../../../dotfiles/claude/commands ".claude/commands"
    // projectLib.files.mkFileMappings ../../../dotfiles/claude/agents ".claude/agents"
    // projectLib.files.mkFileMappings ../../../dotfiles/claude/skills ".claude/skills";
  };

  xdg.configFile = {
    "opencode/opencode.json".source = ../../../dotfiles/opencode/opencode.json;
  }
  // projectLib.files.mkFileMappings ../../../dotfiles/opencode/commands "opencode/commands"
  // projectLib.files.mkFileMappings ../../../dotfiles/opencode/agents "opencode/agents"
  // projectLib.files.mkFileMappings ../../../dotfiles/opencode/skills "opencode/skills";

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
