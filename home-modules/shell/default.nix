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

  # Starship prompt (Powerline style)
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_status$python$nodejs$golang$rust$terraform$docker_context$cmd_duration$line_break$character";

      character = {
        success_symbol = "[](bold green)";
        error_symbol = "[](bold red)";
      };

      username = {
        style_user = "bg:blue fg:black";
        style_root = "bg:red fg:white";
        format = "[ $user ]($style)[](bg:purple fg:blue)";
        show_always = true;
      };

      hostname = {
        ssh_only = false;
        style = "bg:purple fg:black";
        format = "[ $hostname ]($style)[](bg:cyan fg:purple)";
      };

      directory = {
        style = "bg:cyan fg:black";
        format = "[ $path ]($style)[](fg:cyan)";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        style = "bg:green fg:black";
        format = "[](fg:green)[ $symbol$branch ]($style)";
        symbol = " ";
      };

      git_status = {
        style = "bg:green fg:black";
        format = "[$all_status$ahead_behind]($style)[](fg:green)";
      };

      cmd_duration = {
        min_time = 2000;
        style = "bg:yellow fg:black";
        format = "[](fg:yellow)[ $duration ]($style)[](fg:yellow)";
      };

      python = {
        style = "bg:yellow fg:black";
        format = "[](fg:yellow)[ $symbol$version ]($style)[](fg:yellow)";
        symbol = " ";
      };

      nodejs = {
        style = "bg:green fg:black";
        format = "[](fg:green)[ $symbol$version ]($style)[](fg:green)";
        symbol = " ";
      };

      golang = {
        style = "bg:cyan fg:black";
        format = "[](fg:cyan)[ $symbol$version ]($style)[](fg:cyan)";
        symbol = " ";
      };

      rust = {
        style = "bg:red fg:white";
        format = "[](fg:red)[ $symbol$version ]($style)[](fg:red)";
        symbol = " ";
      };

      terraform = {
        style = "bg:purple fg:white";
        format = "[](fg:purple)[ $symbol$version ]($style)[](fg:purple)";
        symbol = "󱁢 ";
      };

      docker_context = {
        style = "bg:blue fg:white";
        format = "[](fg:blue)[ $symbol$context ]($style)[](fg:blue)";
        symbol = " ";
        only_with_files = true;
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
