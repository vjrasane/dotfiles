{
  pkgs,
  kubectl,
  ...
}:
{
  home.packages = with pkgs; [
    # kubectl with krew plugins
    (kubectl.withKrewPlugins (plugins: [
      plugins.neat
      plugins.node-shell
    ]))

    # Kubernetes tools
    kubernetes-helm
    kubectx
    k9s
    kind
  ];

  home.sessionVariables = {
    # Add krew to PATH for any manually installed plugins
    KREW_ROOT = "$HOME/.krew";
  };

  home.sessionPath = [
    "$HOME/.krew/bin"
  ];
}
