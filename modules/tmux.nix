{pkgs, ...}: {
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
      yank
      resurrect
      continuum
      vim-tmux-navigator
      {
        plugin = tmux-nova;
        extraConfig = ''
          set -g @nova-nerdfonts true
          set -g @nova-nerdfonts-left
          set -g @nova-nerdfonts-right

          set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
          set -g @nova-segment-mode-colors "#50fa7b #282a36"

          set -g @nova-segment-whoami "#(whoami)@#h"
          set -g @nova-segment-whoami-colors "#50fa7b #282a36"

          set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

          set -g @nova-rows 0
          set -g @nova-segments-0-left "mode"
          set -g @nova-segments-0-right "whoami"
        '';
      }
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

      bind-key x kill-pane

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
    '';
  };
}
