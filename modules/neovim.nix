{
  config,
  pkgs,
  dotfiles,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # External dependencies for neovim plugins
  home.packages = with pkgs; [
    # Telescope dependencies
    ripgrep
    fd

    # Language servers
    gopls
    lua-language-server
    pyright
    tailwindcss-language-server
    typescript-language-server
    nodePackages."@astrojs/language-server"

    # Formatters/linters
    stylua
    nixfmt-rfc-style
    markdownlint-cli
    prettierd
    eslint_d
    shfmt
    shellcheck
  ];

  # Symlink nvim config from dotfiles
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
}
