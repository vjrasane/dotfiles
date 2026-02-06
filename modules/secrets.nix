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
}
