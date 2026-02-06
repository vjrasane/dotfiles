{
  dotfiles,
  homeDir,
  ...
}:
let
  secretFiles = builtins.attrNames (builtins.readDir "${dotfiles}/secrets");
  resticFiles = builtins.filter (n: builtins.match "restic-.*\\.env\\.age" n != null) secretFiles;
  toName = f: builtins.head (builtins.match "(restic-.*)\\.env\\.age" f);
  toEnv = f: builtins.head (builtins.match "restic-(.*)\\.env\\.age" f);
in
{

  age.secrets = builtins.listToAttrs (
    map (f: {
      name = toName f;
      value = {
        file = "${dotfiles}/secrets/${f}";
        path = "${homeDir}/.config/restic/${toEnv f}.env";
      };
    }) resticFiles
  );

  # age.secrets = {
  #   restic-homelab = {
  #     file = "${dotfiles}/secrets/restic-homelab.env.age";
  #     path = "${homeDir}/.config/restic/homelab.env";
  #   };
  #   restic-glacier = {
  #     file = "${dotfiles}/secrets/restic-glacier.env.age";
  #     path = "${homeDir}/.config/restic/glacier.env";
  #   };
  #   restic-s3 = {
  #     file = "${dotfiles}/secrets/restic-s3.env.age";
  #     path = "${homeDir}/.config/restic/s3.env";
  #   };
  #   restic-oci = {
  #     file = "${dotfiles}/secrets/restic-oci.env.age";
  #     path = "${homeDir}/.config/restic/oci.env";
  #   };
  #   restic-paperless = {
  #     file = "${dotfiles}/secrets/restic-paperless.env.age";
  #     path = "${homeDir}/.config/restic/paperless.env";
  #   };
  #   restic-work = {
  #     file = "${dotfiles}/secrets/restic-work.env.age";
  #     path = "${homeDir}/.config/restic/work.env";
  #   };
  #   restic-psql = {
  #     file = "${dotfiles}/secrets/restic-psql.env.age";
  #     path = "${homeDir}/.config/restic/psql.env";
  #   };
  #   restic-psql-cloudflare = {
  #     file = "${dotfiles}/secrets/restic-psql-cloudflare.env.age";
  #     path = "${homeDir}/.config/restic/psql-cloudflare.env";
  #   };
  # };
}
