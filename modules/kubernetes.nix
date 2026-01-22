{
  pkgs,
  kubectl,
  dotfiles,
  homeDir,
  ...
}:
{
  age.secrets = {
    kubeconfig-k3s = {
      file = "${dotfiles}/secrets/kubeconfig-k3s.age";
      path = "${homeDir}/.kube/config.k3s";
    };
    kubeconfig-prod = {
      file = "${dotfiles}/secrets/kubeconfig-prod.age";
      path = "${homeDir}/.kube/config.prod";
    };
    kubeconfig-staging = {
      file = "${dotfiles}/secrets/kubeconfig-staging.age";
      path = "${homeDir}/.kube/config.staging";
    };
    kubeconfig-verda = {
      file = "${dotfiles}/secrets/kubeconfig-verda.age";
      path = "${homeDir}/.kube/config.verda";
    };
  };

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
