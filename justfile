
hooks:
    @devenv tasks run devenv:git-hooks:run

fmt:
    @shfmt -w scripts
    @nixfmt devenv.nix
