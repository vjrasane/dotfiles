{
  config,
  pkgs,
  lib,
  dotfiles,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Oh-my-zsh integration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "command-not-found"
        "extract"
      ];
    };

    # Plugins from nixpkgs and GitHub
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "jq-zsh-plugin";
        src = pkgs.fetchFromGitHub {
          owner = "reegnz";
          repo = "jq-zsh-plugin";
          rev = "master";
          sha256 = "0vvhs65vc6ka6l4i3d40rabc8c7yllvjch7adwszkq8953w12m9m";
        };
        file = "jq.plugin.zsh";
      }
      {
        name = "zsh-bitwarden-secrets-manager";
        src = pkgs.fetchFromGitHub {
          owner = "vjrasane";
          repo = "zsh-bitwarden-secrets-manager";
          rev = "main";
          sha256 = "156hixzj825d14bc2ldi1cgxlalrymxcgzlhnkgdg90c3l4v1vq6";
        };
        file = "zsh-bitwarden-secrets-manager.plugin.zsh";
      }
    ];

    # Shell aliases
    shellAliases = {
      hms = "home-manager switch --impure --flake ${dotfiles}";
      psql = "pgcli";

      # File listing
      tree = "eza --icons=always --tree";

      # Tools
      cat = "bat";
      tf = "tofu";
      j = "just";
      hm = "home-manager";
      kb = "kubectl";
      kn = "kubens";
      lzd = "lazydocker";

      # Navigation
      home = "cd ~";
      "cd.." = "cd ..";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # Permissions
      mx = "chmod a+x";
      "000" = "chmod -R 000";
      "644" = "chmod -R 644";
      "666" = "chmod -R 666";
      "755" = "chmod -R 755";
      "777" = "chmod -R 777";

      # System
      countfiles = "for t in files links directories; do echo `find . -type \${t:0:1} | wc -l` $t; done 2> /dev/null";
      checkcommand = "type -t";
      openports = "netstat -nape --inet";
      rebootsafe = "sudo shutdown -r now";
      rebootforce = "sudo shutdown -r -n now";
      diskspace = "du -S | sort -n -r | more";
      folders = "du -h --max-depth=1";
      mountedinfo = "df -hT";
      cdtmp = "cd $(mktemp -d)";
    };

    # Source modular configuration from dotfiles
    initContent = ''
      source $DOTFILES/zshrc/init.sh
      source $DOTFILES/zshrc/functions.sh
      source $DOTFILES/zshrc/fzf.sh
      source $DOTFILES/.p10k.zsh
    '';
  };
}
