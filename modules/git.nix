{
  pkgs, 
  lib,
  dotfiles,
  homeDir,
  ...
}: let
  keys = import "${dotfiles}/keys.nix";

  github = {
    user = "vjrasane";
    email = "3148501+vjrasane@users.noreply.github.com";
    remotes = [
      "git@github.com:${github.user}"
      "https://github.com/${github.user}"
    ];
  };

  workNixPath = "${dotfiles}/work.nix";
  hasWork = builtins.pathExists workNixPath;
  work =
    if hasWork
    then import workNixPath
    else {};
in {
  programs.jujutsu = {
    enable = true;
    settings =
      lib.recursiveUpdate
      (builtins.fromTOML (builtins.readFile "${dotfiles}/jj.toml"))
      {
        user = {
          name = github.user;
          email = github.email;
        };
        signing.key = keys.currentMachine.publicKeyPath homeDir;
      };
  };

  programs.git = {
    enable = true;
    signing = {
      key = keys.currentMachine.publicKeyPath homeDir; 
      signByDefault = true;
    };

    settings = {
      gpg.format = "ssh";
      "gpg \"ssh\"".allowedSignersFile = "${homeDir}/.ssh/allowed_signers";
      core.excludesFile = "${dotfiles}/gitignore";
    };

    includes =
      [
        {path = "${dotfiles}/gitconfig";}
      ]
      ++ (map (remote: {
          condition = "hasconfig:remote.*.url:${remote}/**";
          contents.user = {
            name = github.user;
            email = github.email;
          };
        })
        github.remotes)
      ++ lib.optionals hasWork (
        map (remote: {
          condition = "hasconfig:remote.*.url:${remote}/**";
          contents.user = {
            name = work.user;
            email = work.email;
          };
        }) (work.remotes or [])
      );

  };

  home.file.".ssh/allowed_signers".text = let
    emails = [github.email] ++ lib.optionals hasWork [work.email];
    signers = lib.flatten (map (email: map (key: "${email} ${key}") ( keys.signingKeys homeDir )) emails);
  in
    lib.concatStringsSep "\n" signers;
}
