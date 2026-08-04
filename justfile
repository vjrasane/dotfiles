default:
    @just --list

hooks:
    @devenv tasks run devenv:git-hooks:run

fmt:
    @shfmt -w scripts
    @nixfmt devenv.nix

# One-time bootstrap: keyd daemon is system-level, config comes from modules/keyd.nix
setup-keyd:
    sudo apt-get install -y keyd
    sudo mkdir -p /etc/keyd
    sudo ln -sf "$HOME/.config/keyd/default.conf" /etc/keyd/default.conf
    # apt auto-starts keyd before the symlink exists; restart so it picks up the config
    sudo systemctl enable --now keyd
    sudo systemctl restart keyd
