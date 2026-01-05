{ config, pkgs, lib, userConfig, ... }:

{
  imports = [
    ./dev.nix
    ./devops.nix
  ];

  # Direnv custom functions
  xdg.configFile."direnv/direnvrc".source = ../../../dotfiles/direnv/direnvrc;

  # Shell packages
  home.packages = [
    # Core utilities
    pkgs.bat
    pkgs.delta
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.htop
    pkgs.jq
    pkgs.ncdu
    pkgs.neofetch
    pkgs.ripgrep
    pkgs.rsync
    pkgs.screen
    pkgs.tree
    pkgs.vim
    pkgs.yq

    # Hardware
    pkgs.usbutils

    # Compression tools
    pkgs.zip
    pkgs.unzip
    pkgs.gnutar
    pkgs.xz
    pkgs.bzip2
    pkgs.gzip
    pkgs.p7zip

    # Cloud/sync tools
    pkgs.borgbackup
    pkgs.rclone
    pkgs.restic

    # Dev
    pkgs.gh
    pkgs.github-copilot-cli
    pkgs.pre-commit

    # Infrastructure tools (using binary releases)
    pkgs.opentofu # Open source Terraform fork (binary)
    pkgs.terragrunt

    # SSH key management
    pkgs.keychain

    # Database clients
    pkgs.postgresql # psql
    pkgs.mariadb # mysql client (compatible)
    pkgs.redis # redis-cli
    # pkgs.mongosh  # TODO: Broken in nixpkgs - npm cache out of sync
  ];

  programs = {
    # Git configuration
    git = {
      enable = true;
      settings = {
        user = {
          name = userConfig.fullName;
          inherit (userConfig) email;
        };
        init.defaultBranch = "main";
        pull.rebase = false;
        core = {
          editor = "vim";
          autocrlf = "input";
        };
        push.autoSetupRemote = true;
        color.ui = "auto";
        alias = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          lg = "log --oneline --graph --decorate";
        };
      };
    };

    # Tmux configuration
    tmux = {
      enable = true;
      prefix = "C-a";
      terminal = "screen-256color";
      historyLimit = 10000;
      escapeTime = 0;
      baseIndex = 1;
      keyMode = "vi";
      extraConfig = ''
        # Unbind the default prefix
        unbind C-b

        # Use Ctrl+a as prefix
        bind C-a send-prefix

        # Split panes using | and -
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # Reload config
        bind r source-file ~/.tmux.conf \; display "Config reloaded!"

        # Switch panes using Alt-arrow without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Enable mouse mode
        set -g mouse on

        # Allow windows to be renamed (shows SSH hostname, etc.)
        set-option -g allow-rename on

        # Resize windows based on smallest client viewing that window (not session)
        set-option -g aggressive-resize on

        # Status bar
        set -g status-position bottom
        set -g status-style 'bg=colour234 fg=colour137'
        set -g status-left ""
        set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
        set -g status-right-length 50
        set -g status-left-length 20

        # Window status
        setw -g window-status-current-style 'fg=colour1 bg=colour238 bold'
        setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '
        setw -g window-status-style 'fg=colour9 bg=colour236'
        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      '';
    };

    # Starship prompt (Minimal style)
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        format = "\${custom.terminal_title}$hostname$directory$git_branch$git_status$character";
        add_newline = false;

        # Set terminal title to user@host:directory
        custom.terminal_title = {
          command = "printf '\\033]0;%s@%s:%s\\007' \"$USER\" \"$HOSTNAME\" \"$PWD\"";
          when = "true";
          format = "[$output]()";
          shell = [ "bash" "--noprofile" "--norc" "-c" ];
        };

        character = {
          success_symbol = "[❯](green)";
          error_symbol = "[❯](red)";
        };

        hostname = {
          ssh_only = false;
          format = "[$hostname](yellow) ";
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
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "eza";
        ll = "eza -la";
        grep = "rg";
        find = "fd";
        vim = "nvim";
        ".." = "cd ..";
        "..." = "cd ../..";
        terraform = "tofu";
        tmain = "tmux attach -t main";
      };
      initExtra = ''
        # Initialize keychain for SSH key management
        # Used in: i3 sessions on NixOS, standalone Home Manager (WSL/ChromeOS)
        # NOT used in: GNOME sessions (gnome-keyring handles SSH agent instead)
        if [[ "$XDG_CURRENT_DESKTOP" != "GNOME" ]]; then
          eval $(keychain --eval --quiet $(find ~/.ssh -maxdepth 1 -name "id_*" ! -name "*.pub" 2>/dev/null))
        fi

        # Create tmux session on startup (detached, doesn't auto-attach)
        # Skip if: already in tmux, non-interactive shell, VSCode terminal, or SSH session
        if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -n "$PS1" ] && [ -z "$VSCODE_INJECTION" ] && [ -z "$SSH_TTY" ]; then
          tmux has-session -t main 2>/dev/null || tmux new-session -d -s main
        fi
      '';
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
      config.global = {
        load_dotenv = true;
        hide_env_diff = true;
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      extraLuaConfig = ''
        --- Line numbers
        vim.opt.number = true
        vim.opt.relativenumber = true
        --- Indentation
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
        --- Search
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        --- UI
        vim.opt.termguicolors = true
        vim.opt.signcolumn = "yes"
        vim.opt.cursorline = true
      '';
    };
  };
}
