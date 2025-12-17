{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./tmux.nix
    ./claude.nix
  ];

  # Shell packages
  home.packages = [
    # Core utilities
    pkgs.bat
    pkgs.fzf
    pkgs.htop
    pkgs.ripgrep
    pkgs.rsync
    pkgs.screen
    pkgs.vim

    # Compression tools
    pkgs.zip
    pkgs.unzip
    pkgs.gnutar
    pkgs.xz
    pkgs.gzip
    pkgs.p7zip

    # Cloud/sync tools
    pkgs.rclone
    pkgs.restic

    # GitHub CLI
    pkgs.gh

    # Pre-commit hooks
    pkgs.pre-commit

    # Infrastructure tools (using binary releases)
    pkgs.opentofu      # Open source Terraform fork (binary)
    pkgs.terragrunt

    # SSH key management
    pkgs.keychain

    # Database clients
    pkgs.postgresql      # psql
    pkgs.mariadb         # mysql client (compatible)
    pkgs.redis           # redis-cli
    pkgs.mongosh         # MongoDB shell
  ];

  # Starship prompt (Minimal style)
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = "$directory$git_branch$git_status$character";
      add_newline = false;

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };

      directory = {
        style = "cyan";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      git_branch = {
        style = "purple";
        format = "[$branch]($style) ";
      };

      git_status = {
        style = "red";
        format = "[$all_status$ahead_behind]($style)";
      };
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      terraform = "tofu";
    };
    initExtra = ''
      # Initialize keychain for SSH key management
      # Used in: i3 sessions on NixOS, standalone Home Manager (WSL/ChromeOS)
      # NOT used in: GNOME sessions (gnome-keyring handles SSH agent instead)
      if [[ "$XDG_CURRENT_DESKTOP" != "GNOME" ]]; then
        eval $(keychain --eval --quiet $(find ~/.ssh -maxdepth 1 -name "id_*" ! -name "*.pub" 2>/dev/null))
      fi
    '';
  };

  # fzf integration
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
