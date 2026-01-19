
hooks:
    @pre-commit run --all-files

fmt:
    @shfmt -w scripts
    @nixfmt devenv.nix
