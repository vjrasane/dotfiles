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
  };

  home.packages = with pkgs; [
    # kubectl with krew plugins
    (kubectl.withKrewPlugins (plugins: [
      plugins.neat
      plugins.node-shell
    ]))

    # Kubernetes tools
    kubernetes-helm
    kustomize
    k9s
    kind
  ];

  home.file.".local/bin/k9s-debug" = {
    source = "${dotfiles}/scripts/k9s-debug";
    executable = true;
  };

  xdg.configFile."k9s/plugins.yaml".text = ''
    plugins:
      debug-pod:
        shortCut: Shift-D
        description: "Debug with custom image"
        scopes:
          - pods
        command: ${homeDir}/.local/bin/k9s-debug
        args:
          - $NAMESPACE
          - $NAME
        background: false
        confirm: false
      debug-container:
        shortCut: Shift-D
        description: "Debug with custom image"
        scopes:
          - containers
        command: ${homeDir}/.local/bin/k9s-debug
        args:
          - $NAMESPACE
          - $POD
          - $NAME
        background: false
        confirm: false
  '';

  home.sessionVariables = {
    # Add krew to PATH for any manually installed plugins
    KREW_ROOT = "$HOME/.krew";
  };

  home.sessionPath = [
    "$HOME/.krew/bin"
  ];
}
