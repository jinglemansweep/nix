{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./tmux.nix
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

    # GitHub CLI
    gh

    # Pre-commit hooks
    pre-commit

    # Infrastructure tools
    terraform
    terragrunt
  ];

  # Starship prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
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
      cat = "bat --paging=never";
      grep = "rg";
    };
  };

  # fzf integration
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
