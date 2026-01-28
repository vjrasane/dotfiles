{
  pkgs,
  ...
}:
{
  packages = with pkgs; [
    just
  ];

  git-hooks.hooks = {
    nixfmt.enable = true;
    check-shebang-scripts-are-executable = {
      enable = true;
      excludes = [
        "\\.p10k\\.zsh$"
        "\\.zsh_plugins\\.zsh$"
        "zshrc/.*\\.sh$"
      ];
    };
    check-symlinks.enable = true;
    check-yaml.enable = true;
    ripsecrets.enable = true;
    shellcheck = {
      enable = true;
      excludes = [
        "\\.p10k\\.zsh$"
        "\\.zsh_plugins\\.zsh$"
        "zshrc/.*\\.sh$"
      ];
    };
    shfmt = {
      enable = true;
      excludes = [
        "\\.p10k\\.zsh$"
        "\\.zsh_plugins\\.zsh$"
        "zshrc/.*\\.sh$"
      ];
    };
    trim-trailing-whitespace = {
      enable = true;
      excludes = [ "^secrets/" ];
    };
    end-of-file-fixer = {
      enable = true;
      excludes = [ "^secrets/" ];
    };
  };
}
