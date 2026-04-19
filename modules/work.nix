{
  config,
  lib,
  dotfiles,
  homeDir,
  ...
}:
let
  keys = import "${dotfiles}/keys.nix";

  git_user = config.programs.git.settings.user;

  work_user = {
    name = "ville";
    email = builtins.concatStringsSep "@" [
      "ville"
      "datacrunch.io"
    ];
  };
in
{
  programs.git.includes = [
    {
      condition = "gitdir:${homeDir}/repositories/work/";
      contents.user = work_user;
    }
  ];

  programs.jujutsu.settings."--scope" = [
    {
      "--when".repositories = [ "${homeDir}/repositories/work" ];
      user = work_user;
    }
  ];

  xdg.configFile."git/allowed_signers".text =
    let
      emails = lib.unique [
        git_user.email
        work_user.email
      ];
      signers = lib.flatten (map (email: map (key: "${email} ${key}") (keys.signingKeys homeDir)) emails);
    in
    lib.concatStringsSep "\n" signers;
}
