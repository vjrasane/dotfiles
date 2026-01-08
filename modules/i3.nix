{
  config,
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4"; # Super key
in {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;

    config = {
      modifier = mod;
      terminal = "alacritty";

      fonts = {
        names = ["MesloLGS Nerd Font"];
        size = 10.0;
      };

      gaps = {
        inner = 10;
        outer = 5;
        smartGaps = true;
        smartBorders = "on";
      };

      window = {
        border = 2;
        titlebar = false;
      };

      floating = {
        border = 2;
        titlebar = false;
      };

      # Catppuccin Mocha colors
      colors = {
        focused = {
          border = "#cba6f7";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#f5e0dc";
          childBorder = "#cba6f7";
        };
        focusedInactive = {
          border = "#45475a";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#45475a";
          childBorder = "#45475a";
        };
        unfocused = {
          border = "#313244";
          background = "#1e1e2e";
          text = "#a6adc8";
          indicator = "#313244";
          childBorder = "#313244";
        };
        urgent = {
          border = "#f38ba8";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#f38ba8";
          childBorder = "#f38ba8";
        };
      };

      keybindings = lib.mkOptionDefault {
        # Launch
        "${mod}+Return" = "exec alacritty";
        "${mod}+d" = "exec --no-startup-id rofi -show drun";
        "${mod}+Shift+d" = "exec --no-startup-id rofi -show run";

        # Window management
        "${mod}+q" = "kill";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";

        # Focus (vim-like)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move (vim-like)
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Splits
        "${mod}+v" = "split v";
        "${mod}+b" = "split h";

        # Layout
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";

        # Resize mode
        "${mod}+r" = "mode resize";

        # Restart/reload
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";

        # Screenshots
        "Print" = "exec --no-startup-id flameshot gui";
      };

      modes = {
        resize = {
          h = "resize shrink width 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";
          Escape = "mode default";
          Return = "mode default";
        };
      };

      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = {
            names = ["MesloLGS Nerd Font"];
            size = 10.0;
          };
          colors = {
            background = "#1e1e2e";
            statusline = "#cdd6f4";
            separator = "#45475a";
            focusedWorkspace = {
              border = "#cba6f7";
              background = "#cba6f7";
              text = "#1e1e2e";
            };
            activeWorkspace = {
              border = "#45475a";
              background = "#45475a";
              text = "#cdd6f4";
            };
            inactiveWorkspace = {
              border = "#1e1e2e";
              background = "#1e1e2e";
              text = "#a6adc8";
            };
            urgentWorkspace = {
              border = "#f38ba8";
              background = "#f38ba8";
              text = "#1e1e2e";
            };
          };
        }
      ];

      startup = [
        {command = "nm-applet"; notification = false;}
      ];
    };
  };

  # i3status config
  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      color_good = "#a6e3a1";
      color_degraded = "#f9e2af";
      color_bad = "#f38ba8";
      interval = 5;
    };
    modules = {
      "wireless _first_" = {
        position = 1;
        settings = {
          format_up = "  %essid %quality";
          format_down = "  down";
        };
      };
      "ethernet _first_" = {
        position = 2;
        settings = {
          format_up = "󰈀 %ip";
          format_down = "";
        };
      };
      "battery all" = {
        position = 3;
        settings = {
          format = "%status %percentage %remaining";
          status_chr = "󰂄";
          status_bat = "󰁿";
          status_full = "󰁹";
          low_threshold = 20;
        };
      };
      "disk /" = {
        position = 4;
        settings = {
          format = "󰋊 %avail";
        };
      };
      "memory" = {
        position = 5;
        settings = {
          format = "󰍛 %percentage_used";
          threshold_degraded = "20%";
        };
      };
      "cpu_usage" = {
        position = 6;
        settings = {
          format = "󰻠 %usage";
        };
      };
      "tztime local" = {
        position = 7;
        settings = {
          format = "󰥔 %Y-%m-%d %H:%M";
        };
      };
    };
  };

  # Supporting packages
  home.packages = with pkgs; [
    rofi
    flameshot
    feh
    picom
    alacritty
    networkmanagerapplet
  ];
}
