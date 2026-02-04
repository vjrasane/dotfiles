{
  config,
  pkgs,
  dotfiles,
  ...
}:
let
  treesitterParsers = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.c
    p.go
    p.gomod
    p.gosum
    p.json
    p.yaml
    p.diff
    p.html
    p.astro
    p.javascript
    p.typescript
    p.lua
    p.luadoc
    p.markdown
    p.markdown_inline
    p.query
    p.vim
    p.vimdoc
  ]);
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = [ treesitterParsers ];
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
    nixfmt
    markdownlint-cli
    prettierd
    eslint_d
    shfmt
    shellcheck
    dockerfmt
  ];

  # Symlink nvim config from dotfiles
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
}
