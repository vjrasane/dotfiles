{
  pkgs,
  ...
}:
{
  pre-commit = {
    default_stages = [ "pre-push" ];
    hooks = {
      nixfmt-rfc-style.enable = true;
      check-shebang-scripts-are-executable.enable = true;
      check-symlinks.enable = true;
      check-yaml.enable = true;
      ripsecrets.enable = true;
      shellcheck.enable = true;
      shfmt.enable = true;
      typos.enable = true;
      trim-trailing-whitespace.enable = true;
      end-of-file-fixer.enable = true;
    };
  };
}
