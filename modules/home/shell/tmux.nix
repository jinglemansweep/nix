{ config, pkgs, lib, ... }:

{
  programs.tmux = {
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

      # Don't rename windows automatically
      set-option -g allow-rename off

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
}
