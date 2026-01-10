{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
  ];

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    terminal = "tmux-256color";
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'rounded'

          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_user}"
          set -ag status-right "#{E:@catppuccin_status_host}"
        '';
      }
      resurrect
      continuum
    ];

    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      bind-key h select-pane -L
      bind-key l select-pane -R
      bind-key j select-pane -D
      bind-key k select-pane -U

      bind-key -r -T prefix Up    resize-pane -U 5
      bind-key -r -T prefix Down  resize-pane -D 5
      bind-key -r -T prefix Left  resize-pane -L 5
      bind-key -r -T prefix Right resize-pane -R 5

      bind-key -r Up resize-pane -U 20
      bind-key -r Down resize-pane -D 20
      bind-key -r Left resize-pane -L 20
      bind-key -r Right resize-pane -R 20

      bind-key x kill-pane

      # Splits (vim-like)
      bind-key v split-window -h -c "#{pane_current_path}"
      bind-key s split-window -v -c "#{pane_current_path}"
      bind-key S choose-session
      bind-key w new-window -c "#{pane_current_path}"
      bind-key W choose-tree -Zw

      bind-key m choose-window -F "#{window_index}: #{window_name}" "join-pane -h -t %%"
      bind-key M choose-window -F "#{window_index}: #{window_name}" "join-pane -v -t %%"

      set-option -g status-position top
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -ag terminal-overrides ",xterm-256color:RGB"

      set -g renumber-windows on
      set -g set-clipboard on
      set -g detach-on-destroy off
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      set -g @continuum-restore 'on'
      set -g @resurrect-strategy-nvim 'session'

      # Copy mode
      bind-key Escape copy-mode
      bind-key -T copy-mode-vi Escape send-keys -X cancel
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Vim-like selection in copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

      # Paste from system clipboard
      bind-key p run-shell "wl-paste | tmux load-buffer - && tmux paste-buffer"
      bind-key P paste-buffer
    '';
  };
}
