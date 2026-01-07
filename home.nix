{
  config,
  pkgs,
  lib,
  local,
  ...
}: let
  # Default to ~/dotfiles, can override in local.nix
  dotfiles = local.dotfilesPath or "${local.homeDirectory}/dotfiles";
in {
  home.username = local.username;
  home.homeDirectory = local.homeDirectory;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Sops secrets management
  sops = {
    age.keyFile = "${local.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets.ssh_private_key = {
      path = "${config.home.homeDirectory}/.ssh/id_rsa";
      mode = "0600";
    };
  };

  # Packages to install
  home.packages = with pkgs; [
    # Shell & terminal
    tmux

    # CLI essentials
    fd
    jq
    yq-go
    just
    curl
    wget
    unzip
    gnupg

    # SSH & security
    age
    sops

    # Development - languages
    nodejs_22
    python3
    rustup
    go

    # Development - tools
    gcc
    gnumake

    # Cloud & DevOps
    kubectl
    kubernetes-helm
    kubectx
    opentofu
    awscli2

    # Containers
    docker-compose

    # Database
    postgresql

    # System info
    neofetch
  ];

  # Zsh - sources config directly from dotfiles
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      hms = "home-manager switch --impure --flake ${dotfiles}";
    };

    # Source modular configuration from dotfiles
    initContent = ''
      source $DOTFILES/zshrc/init.sh
      source $DOTFILES/zshrc/antidote.sh
      source $DOTFILES/zshrc/python.sh
      source $DOTFILES/zshrc/js.sh
      source $DOTFILES/zshrc/path.sh
      source $DOTFILES/zshrc/functions.sh
      source $DOTFILES/zshrc/fzf.sh
      source $DOTFILES/zshrc/alias.sh
    '';
  };

  # Git - machine-specific settings here, shared config included
  programs.git = {
    enable = true;

    signing = {
      key = local.gitSigningKey;
      signByDefault = true;
    };

    settings = {
      gpg.format = "ssh";
      "gpg \"ssh\"".allowedSignersFile = "~/.ssh/allowed_signers";
      core.excludesFile = "${dotfiles}/gitignore";

      user = {
        name = local.gitUser;
        email = local.gitEmail;
      };
    };

    includes = [
      {path = "${dotfiles}/gitconfig";}
    ];
  };

  # Jujutsu integration
  programs.jujutsu = {
    enable = true;
    settings =
      lib.recursiveUpdate
      (builtins.fromTOML (builtins.readFile "${dotfiles}/jj.toml"))
      {
        user = {
          name = local.gitUser;
          email = local.gitEmail;
        };
        signing.key = local.gitSigningKey;
      };
  };

  # FZF integration (zsh integration sourced manually in zshrc/fzf.sh)
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  # Zoxide integration (replaces cd command)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  # Direnv with nix support
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Keychain - SSH key management
  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = ["id_rsa"];
  };

  # Bat - better cat
  programs.bat = {
    enable = true;
  };

  # Eza - better ls
  programs.eza = {
    enable = true;
    icons = "auto";
  };

  # Htop
  programs.htop.enable = true;

  # Ripgrep
  programs.ripgrep = {
    enable = true;
    arguments = ["--smart-case"];
  };

  # Delta - better diff
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };

  # Session environment variables
  home.sessionVariables = {
    DOTFILES = dotfiles;
    KUBECONFIG = "${local.homeDirectory}/.kube/config";
  };

  # Session PATH
  home.sessionPath =
    [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "/snap/bin"
    ]
    ++ lib.optionals (local.isWsl or false) [
      "/mnt/c/Windows/System32"
      "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
    ];

  # Symlink dotfiles from repo to home directory
  # Note: .gitconfig is managed by programs.git, .zshrc is managed by programs.zsh
  # zshrc/, .p10k.zsh, .zsh_plugins.txt are sourced directly via $DOTFILES
  home.file = {
    ".ssh/id_rsa.pub".source = ./ssh_id_rsa.pub;
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
    "tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/tmux";
  };

  # Nix is configured system-wide via ~/.config/nix/nix.conf
}
