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
    restic-oci = {
      file = "${dotfiles}/secrets/restic-oci.env.age";
      path = "${homeDir}/.config/restic/oci.env";
    };
    restic-work = {
      file = "${dotfiles}/secrets/restic-work.env.age";
      path = "${homeDir}/.config/restic/work.env";
    };
    restic-psql = {
      file = "${dotfiles}/secrets/restic-psql.env.age";
      path = "${homeDir}/.config/restic/psql.env";
    };
    restic-psql-cloudflare = {
      file = "${dotfiles}/secrets/restic-psql-cloudflare.env.age";
      path = "${homeDir}/.config/restic/psql-cloudflare.env";
    };
  };
}
