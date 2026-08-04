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
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "claude-code" ];

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
    curl
    wget
    unzip
    gnupg
    pdsh

    # SSH & security
    age
    agenix-cli
    sops
    restic
    (resticprofile.overrideAttrs { doCheck = false; })

    # Development - languages
    nodejs_22
    bun
    python3
    uv
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

    # Containers
    lazydocker
    dive

    # Database
    postgresql
    pgcli

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
    enableZshIntegration = false;
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

  services.tailscale-systray.enable = true;

  # Session environment variables
  home.sessionVariables = {
    DOTFILES = dotfiles;
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
    PDSH_RCMD_TYPE = "ssh";
    PDSH_SSH_ARGS = "-o ForwardAgent=True";
    OCI_CLI_SUPPRESS_FILE_PERMISSIONS_WARNING = "True";
    _ZO_DOCTOR = "0"; # AI agents' shells drop zoxide's chpwd hook, tripping its doctor warning
  };

  # Session PATH
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.claude/toolbox"
  ];

  xdg.configFile = {
    "ghostty/config".text = ''
      font-size = 11
    '';
    "pgcli/config".text = ''
      [main]
      keyring = False
    '';
  };

  home.file.".local/bin/jj-push" = {
    source = "${dotfiles}/scripts/jj-push";
    executable = true;
  };

  home.file.".local/bin/genpass" = {
    source = "${dotfiles}/scripts/genpass";
    executable = true;
  };

  home.file.".local/bin/genhex" = {
    source = "${dotfiles}/scripts/genhex";
    executable = true;
  };

  home.file.".oci/config".text = ''
    [DEFAULT]
    user=ocid1.user.oc1..aaaaaaaabkrntaizikwuj6imrsaqpt2bu2dqj4yhrrl73ylyjxpqq6xp3nra
    fingerprint=04:95:47:c8:8b:36:50:fb:8c:22:db:65:ba:9d:99:22
    key_file=${homeDir}/.oci/oci_api_key.pem
    tenancy=ocid1.tenancy.oc1..aaaaaaaamk6vlzuo63wjckkep53yasj5e5dwomnrdvvieodt63ksyutypjta
    region=eu-frankfurt-1
  '';

  home.file.".config/age/recipients".text =
    let
      keys = import "${dotfiles}/keys.nix";
    in
    lib.concatStringsSep "\n" keys.encryptionKeys + "\n";

  # Nix is configured system-wide via ~/.config/nix/nix.conf
}
