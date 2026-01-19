{
  dotfiles,
  homeDir,
  ...
}:
{
  age.secrets = {
    restic-homelab = {
      file = "${dotfiles}/secrets/restic-homelab.env.age";
      path = "${homeDir}/.config/restic/homelab.env";
    };
    restic-glacier = {
      file = "${dotfiles}/secrets/restic-glacier.env.age";
      path = "${homeDir}/.config/restic/glacier.env";
    };
    restic-s3 = {
      file = "${dotfiles}/secrets/restic-s3.env.age";
      path = "${homeDir}/.config/restic/s3.env";
    };
    restic-work = {
      file = "${dotfiles}/secrets/restic-work.env.age";
      path = "${homeDir}/.config/restic/work.env";
    };
  };
}
