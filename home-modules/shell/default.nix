{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./tmux.nix
    ./claude.nix
  ];

  # Shell packages
  home.packages = with pkgs; [
    # Core utilities
    bat
    fzf
    htop
    ripgrep
    rsync
    screen
    vim

    # Compression tools
    zip
    unzip
    gnutar
    xz
    gzip
    p7zip

    # Cloud/sync tools
    rclone
    restic

    # GitHub CLI
    gh

    # Pre-commit hooks
    pre-commit

    # Infrastructure tools (using binary releases)
    opentofu      # Open source Terraform fork (binary)
    terragrunt

    # SSH key management
    keychain

    # Database clients
    postgresql      # psql
    mariadb         # mysql client (compatible)
    redis           # redis-cli
    mongosh         # MongoDB shell
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
      # Initialize keychain for SSH key management (all private keys, excluding .pub)
      eval $(keychain --eval --quiet $(find ~/.ssh -maxdepth 1 -name "id_*" ! -name "*.pub" 2>/dev/null))
    '';
  };

  # fzf integration
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
