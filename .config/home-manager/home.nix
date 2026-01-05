{ config, pkgs, lib, local, ... }:

let
  # Default to ~/dotfiles, can override in local.nix
  dotfiles = local.dotfilesPath or "${local.homeDirectory}/dotfiles";
in
{
  home.username = local.username;
  home.homeDirectory = local.homeDirectory;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = with pkgs; [
    # Shell & terminal
    zsh
    tmux

    # CLI essentials
    ripgrep
    fd
    fzf
    eza
    bat
    delta
    jq
    yq-go
    just
    curl
    wget
    unzip
    gnupg

    # Directory & environment
    zoxide
    direnv

    # SSH & security
    keychain
    age
    sops

    # Editor
    neovim

    # Git & VCS
    git
    lazygit
    jujutsu

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
    htop
  ];

  # Zsh - minimal config, sources existing modular files in order
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # Source modular configuration in the same order as .zshrc
    initExtra = ''
      source ~/zshrc/init.sh
      source ~/zshrc/antidote.sh
      source ~/zshrc/python.sh
      source ~/zshrc/js.sh
      source ~/zshrc/path.sh
      source ~/zshrc/functions.sh
      source ~/zshrc/jujitsu.sh
      source ~/zshrc/fzf.sh
      source ~/zshrc/alias.sh
      source ~/zshrc/kubernetes.sh
      source ~/zshrc/zoxide.sh
      source ~/zshrc/direnv.sh
      source ~/zshrc/keychain.sh
    '';
  };

  # Git - machine-specific settings here, shared config included
  programs.git = {
    enable = true;
    userName = local.gitUser;
    userEmail = local.gitEmail;

    signing = {
      key = local.gitSigningKey;
      signByDefault = true;
    };

    extraConfig = {
      gpg.format = "ssh";
      "gpg \"ssh\"".allowedSignersFile = "~/.ssh/allowed_signers";
    };

    includes = [
      { path = "${dotfiles}/.config/git/config.shared"; }
    ];
  };

  # FZF integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zoxide integration
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Direnv with nix support
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Session PATH
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "/snap/bin"
    "/opt/nvim/bin"
  ] ++ lib.optionals (local.isWsl or false) [
    "/mnt/c/Windows/System32"
    "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
  ];

  # Symlink dotfiles from repo to home directory
  # Note: .gitconfig is managed by programs.git, not symlinked
  home.file = {
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.tmux.conf";
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.p10k.zsh";
    ".zsh_plugins.txt".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.zsh_plugins.txt";
    "zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zshrc";
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
    "jj".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/jj";
    "tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/tmux";
    "home-manager".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/home-manager";
  };

  # Nix configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://cache.nixos.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      download-buffer-size = 4294967296;
    };
  };
}
