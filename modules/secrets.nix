{
  dotfiles,
  homeDir,
  ...
}:
{
  xdg.configFile."ansible/.keep".text = "";

  age.secrets.shell-secrets = {
    file = "${dotfiles}/secrets/secrets.zsh.age";
    path = "${homeDir}/.secrets.zsh";
  };

  age.secrets.ansible-inventory = {
    file = "${dotfiles}/secrets/ansible-inventory.yml.age";
    path = "${homeDir}/.config/ansible/inventory.yml";
  };

  age.secrets.restic-profiles = {
    file = "${dotfiles}/secrets/restic-profiles.yaml.age";
    path = "${homeDir}/.config/resticprofile/profiles.yaml";
  };

  xdg.configFile."resticprofile/excludes.txt".text = ''
    .cache
    **/node_modules
    **/.devenv
    **/.venv
    **/.tox
    **/.git
    **/.jj
    **/__pycache__
    **/.cargo
    **/.next
    $HOME/.local
    $HOME/.npm
    $HOME/go
    $HOME/.config
    $HOME/tmp
    *.tmp
  '';

  age.secrets.oci-api-key = {
    file = "${dotfiles}/secrets/oci_api_key.pem.age";
    path = "${homeDir}/.oci/oci_api_key.pem";
  };
}
