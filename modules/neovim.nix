{
  config,
  pkgs,
  dotfiles,
  ...
}:
{
  home.sessionVariables.EDITOR = "nvim";
  home.shellAliases = {
    vi = "nvim";
    vim = "nvim";
  };

  home.packages = with pkgs; [
    neovim
    # Telescope dependencies
    ripgrep
    fd

    # Language servers
    cook-cli
    gopls
    lua-language-server
    pyright
    tailwindcss-language-server
    astro-language-server
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
