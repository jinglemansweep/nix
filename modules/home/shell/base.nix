# Base shell environment: core CLI tools, git, tmux, bash, neovim, GPG, and SSH
{ config, pkgs, lib, userConfig, ... }:

{
  xdg.configFile."direnv/direnvrc".source = ../../../dotfiles/direnv/direnvrc;

  home.packages = [
    # File utilities
    pkgs.bat
    pkgs.eza
    pkgs.fd
    pkgs.ripgrep
    pkgs.tree
    pkgs.ncdu
    pkgs.lsof
    pkgs.rsync

    # Interactive tools
    pkgs.fzf
    pkgs.htop
    pkgs.btop
    pkgs.vim
    pkgs.screen

    # Data processing
    pkgs.jq
    pkgs.yq
    pkgs.delta

    # Compression
    pkgs.zip
    pkgs.unzip
    pkgs.gnutar
    pkgs.xz
    pkgs.bzip2
    pkgs.gzip
    pkgs.p7zip

    # Backup tools
    pkgs.borgbackup
    pkgs.rclone
    pkgs.restic

    # Misc
    pkgs.imagemagick
    pkgs.neofetch
    pkgs.usbutils
    pkgs.psmisc
    pkgs.keychain
  ];

  programs = {
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

    tmux = {
      enable = true;
      prefix = "C-a";
      terminal = "screen-256color";
      historyLimit = 10000;
      escapeTime = 0;
      baseIndex = 1;
      keyMode = "vi";
      extraConfig = ''
        unbind C-b
        bind C-a send-prefix

        # Split panes with | and -
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        bind r source-file ~/.tmux.conf \; display "Config reloaded!"

        # Alt-arrow to switch panes without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        set -g mouse on
        set-option -g allow-rename on
        set-option -g aggressive-resize on

        # Status bar styling
        set -g status-position bottom
        set -g status-style 'bg=colour234 fg=colour137'
        set -g status-left ""
        set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
        set -g status-right-length 50
        set -g status-left-length 20
        setw -g window-status-current-style 'fg=colour1 bg=colour238 bold'
        setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '
        setw -g window-status-style 'fg=colour9 bg=colour236'
        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      '';
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        format = "\${custom.terminal_title}$hostname$directory$git_branch$git_status$character";
        add_newline = false;

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
        tmain = "tmux attach -t main";
        ssh = "TERM=xterm-256color ssh";
      };
      initExtra = ''
        # Source global environment variables
        [ -f ~/.config/environment.d/50-nix.conf ] && set -a && source ~/.config/environment.d/50-nix.conf && set +a

        # Keychain for SSH keys (skip in GNOME which uses gnome-keyring)
        if [[ "$XDG_CURRENT_DESKTOP" != "GNOME" ]]; then
          eval $(keychain --eval --quiet $(find ~/.ssh -maxdepth 1 -name "id_*" ! -name "*.pub" 2>/dev/null))
        fi

        # Create detached tmux session (skip in tmux, non-interactive, VSCode, or SSH)
        if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -n "$PS1" ] && [ -z "$VSCODE_INJECTION" ] && [ -z "$SSH_TTY" ]; then
          tmux has-session -t main 2>/dev/null || tmux new-session -d -s main
        fi

        nix-inst-prune() {
          echo "Collecting garbage and removing generations older than 7 days..."
          if [ -d /run/current-system ]; then
            sudo nix-collect-garbage --delete-older-than 7d && sudo nix-store --optimise
          else
            nix-collect-garbage --delete-older-than 7d && nix-store --optimise
          fi
        }

        nix-inst-rebuild() {
          if [ -d /run/current-system ]; then
            sudo nixos-rebuild switch --flake .#$(hostname)
          else
            home-manager switch --flake .#${userConfig.username}
          fi
        }
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
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.termguicolors = true
        vim.opt.signcolumn = "yes"
        vim.opt.cursorline = true
      '';
    };

    gpg = {
      enable = true;
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        keyid-format = "long";
        with-fingerprint = true;
        no-emit-version = true;
        no-comments = true;
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          identitiesOnly = true;
          extraOptions.AddKeysToAgent = "yes";
        };
        "pvm?" = { user = "root"; };
        "*.svc.ptre.es" = { user = "user"; };
        "*.ptre.*" = { forwardAgent = true; };
        "*.ipnt.uk" = { forwardAgent = true; };
        "ds920p.*" = { user = "NASAdmin"; port = 50051; };
        "dev" = { forwardAgent = true; };
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 7200;
    maxCacheTtl = 28800;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}
