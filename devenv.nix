{
  pkgs,
  config,
  ...
}:
{
  packages = with pkgs; [
    just
  ];

  claude.code.enable = true;

  claude.code.mcpServers = {
    devenv = {
      type = "stdio";
      command = "devenv";
      args = [ "mcp" ];
      env = {
        DEVENV_ROOT = config.devenv.root;
      };
    };
  };

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
