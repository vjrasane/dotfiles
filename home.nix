{
  config,
  pkgs,
  lib,
  agenix-cli,
  dotfiles,
  homeDir,
  ...
}: let
  # Auto-detect from environment (requires --impure flag)
  username = builtins.getEnv "USER";

  # Detect WSL
  procVersion = builtins.readFile /proc/version;
  isWsl = builtins.match ".*[Mm]icrosoft.*" procVersion != null;

  # Shared SSH configuration
  ssh = import ./ssh.nix;
  keys = import "${dotfiles}/keys.nix";

  # Optional work configuration (gitignored)
  workNixPath = "${dotfiles}/work.nix";
  hasWork = builtins.pathExists workNixPath;
  work =
    if hasWork
    then import workNixPath
    else {};
in {
  home.username = username;
  home.homeDirectory = homeDir;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Disable news notifications
  news.display = "silent";

  age.identityPaths = [
    (keys.currentMachine.privateKeyPath homeDir)
    "${homeDir}/.config/age/key.txt"
  ];
  age.secrets.ssh_private_key = {
    file = ./secrets/ssh_private_key.age;
    path = ssh.rsa.privateKeyPath;
    mode = "0600";
  };
  age.secrets.restic_env = {
    file = ./secrets/restic.env.age;
    path = "${homeDir}/restic.env";
    mode = "0600";
  };

  # Packages to install
  home.packages = with pkgs; [

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
    ssh-askpass-fullscreen
    bitwarden-cli

    # Browser
    brave

    # Development - languages
    nodejs_22
    python3
    go

    # Rust
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt

    # Development - tools
    gcc
    gnumake

    # Cloud & DevOps
    kubectl
    kubernetes-helm
    kubectx
    opentofu
    awscli2
    restic

    # Containers
    docker-compose

    # Database
    postgresql
    lazysql
    pgcli

    # System info
    neofetch

    # Fonts
    nerd-fonts.meslo-lg
  ] ++ [
    agenix-cli
  ];

  # Enable fontconfig to discover fonts installed via home.packages
  fonts.fontconfig.enable = true;

  # Zsh - sources config directly from dotfiles
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      hms = "home-manager switch --impure --flake ${dotfiles}";
      psql = "pgcli";
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
    KUBECONFIG = "${homeDir}/.kube/config";
    SSH_ASKPASS = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  # Session PATH
  home.sessionPath =
    [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "/snap/bin"
    ]
    ++ lib.optionals isWsl [
      "/mnt/c/Windows/System32"
      "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
    ];

  # Symlink dotfiles from repo to home directory
  # Note: .gitconfig is managed by programs.git, .zshrc is managed by programs.zsh
  # zshrc/, .p10k.zsh, .zsh_plugins.txt are sourced directly via $DOTFILES
  home.file = {
    ".ssh/id_rsa.pub".source = ssh.rsa.publicKeyFile;
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
    "pgcli/config".text = ''
      [main]
      keyring = False
    '';
  };

  # Auto-switch home-manager on login
  systemd.user.services.home-manager-switch = {
    Unit = {
      Description = "Home Manager switch on login";
      # Wait for age identity file to be accessible before running
      ConditionPathExists = "${homeDir}/.config/age/key.txt";
    };
    Service = {
      Type = "oneshot";
      Environment = "PATH=${pkgs.nix}/bin:${pkgs.git}/bin";
      ExecStart = "${pkgs.home-manager}/bin/home-manager switch --impure --flake ${dotfiles}";
    };
    Install.WantedBy = ["default.target"];
  };

  # Nix is configured system-wide via ~/.config/nix/nix.conf
}
