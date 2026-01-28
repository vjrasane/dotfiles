{
  config,
  pkgs,
  lib,
  agenix-cli,
  dotfiles,
  homeDir,
  ...
}:
let
  # Auto-detect from environment (requires --impure flag)
  username = builtins.getEnv "USER";

  procVersion = builtins.readFile /proc/version;

  keys = import "${dotfiles}/keys.nix";
in
{
  home.username = username;
  home.homeDirectory = homeDir;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

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
    agenix-cli
    sops
    bitwarden-cli

    # Browser
    brave

    # Development - languages
    nodejs_22
    bun
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
    devenv
    stow

    # Cloud & DevOps
    opentofu
    awscli2
    restic

    # Containers
    lazydocker
    dive

    # Database
    postgresql
    pgcli

    # System info
    neofetch

    # Fonts
    nerd-fonts.meslo-lg
  ];
  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Disable news notifications
  news.display = "silent";

  age.identityPaths = [
    (keys.currentMachine.privateKeyPath homeDir)
  ];

  # Enable fontconfig to discover fonts installed via home.packages
  fonts.fontconfig.enable = true;

  # FZF integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zoxide integration (replaces cd command)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  # Direnv with nix support
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Keychain - SSH key management
  programs.keychain = {
    enable = true;
    enableZshIntegration = true;
    keys = [
      "id_ed25519"
      "id_rsa"
    ];
    extraFlags = [
      "--quiet"
      "--ignore-missing"
    ];
  };

  # Bat - better cat
  programs.bat = {
    enable = true;
    config.theme = "OneHalfDark";
  };

  # Eza - better ls
  programs.eza = {
    enable = true;
    icons = "auto";
    enableZshIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--git"
    ];
  };

  # Htop
  programs.htop.enable = true;

  # Ripgrep
  programs.ripgrep = {
    enable = true;
    arguments = [ "--smart-case" ];
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

  services.tailscale-systray.enable = true;

  # Session environment variables
  home.sessionVariables = {
    DOTFILES = dotfiles;
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
  };

  # Session PATH
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  xdg.configFile = {
    "pgcli/config".text = ''
      [main]
      keyring = False
    '';
  };

  home.file.".local/bin/jj-push" = {
    source = "${dotfiles}/scripts/jj-push";
    executable = true;
  };

  age.secrets.shell-secrets = {
    file = "${dotfiles}/secrets/secrets.zsh.age";
    path = "${homeDir}/.secrets.zsh";
  };

  age.secrets.ansible-inventory = {
    file = "${dotfiles}/secrets/ansible-inventory.yml.age";
    path = "${homeDir}/.config/ansible/inventory.yml";
  };

  xdg.configFile."ansible/.keep".text = "";

  # Nix is configured system-wide via ~/.config/nix/nix.conf
}
