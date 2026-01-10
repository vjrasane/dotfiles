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

  # Optional work configuration (gitignored)
  workNixPath = "${dotfiles}/work.nix";
  hasWork = builtins.pathExists workNixPath;
  work = if hasWork then import workNixPath else { };
in
{
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
    (keys.age.privateKeyPath homeDir)
  ];
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
    keys = [ "id_ed25519" ];
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

  # Session environment variables
  home.sessionVariables = {
    DOTFILES = dotfiles;
    KUBECONFIG = "${homeDir}/.kube/config";
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

  # Nix is configured system-wide via ~/.config/nix/nix.conf
}
