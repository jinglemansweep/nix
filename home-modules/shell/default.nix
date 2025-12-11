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

    # Infrastructure tools (using binary releases)
    opentofu      # Open source Terraform fork (binary)
    terragrunt

    # SSH key management
    keychain
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
      terraform = "tofu";
    };
    initExtra = ''
      # Initialize keychain for SSH key management (all private keys)
      eval $(keychain --eval --quiet ~/.ssh/id_*)
    '';
  };

  # fzf integration
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
}
