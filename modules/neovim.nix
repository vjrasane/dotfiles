{
  config,
  pkgs,
  dotfiles,
  ...
}:
{
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
    cook-cli
    gopls
    lua-language-server
    pyright
    tailwindcss-language-server
    nodePackages."@astrojs/language-server"
    vscode-langservers-extracted
    emmet-language-server
    rust-analyzer

    # Treesitter parser compilation
    tree-sitter

    # Formatters/linters
    stylua
    nixfmt
    markdownlint-cli
    prettierd
    shfmt
    shellcheck
    dockerfmt
  ];

  # Symlink nvim config from dotfiles
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
}
