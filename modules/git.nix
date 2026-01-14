{
  pkgs,
  lib,
  dotfiles,
  homeDir,
  ...
}:
let
  keys = import "${dotfiles}/keys.nix";

  github = {
    user = "vjrasane";
    email = "3148501+vjrasane@users.noreply.github.com";
  };

  work = {
    user = "ville";
    email = builtins.concatStringsSep "@" [
      "ville"
      "datacrunch.io"
    ];
  };
in
{
  programs.jujutsu = {
    enable = true;
    settings = lib.recursiveUpdate (builtins.fromTOML (builtins.readFile "${dotfiles}/jj.toml")) ({
      user = {
        name = github.user;
        email = github.email;
      };
      signing.key = keys.currentMachine.publicKeyPath homeDir;
      signing.backends.ssh.allowed-signers = "${homeDir}/.ssh/allowed_signers";
      "--scope" = [
        {
          "--when".repositories = [ "${homeDir}/repositories/work" ];
          user = {
            name = work.user;
            email = work.email;
          };
        }
      ];
    });
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

    includes = [
      { path = "${dotfiles}/gitconfig"; }
      {
        condition = "gitdir:${homeDir}/repositories/work/";
        contents.user = {
          name = work.user;
          email = work.email;
        };
      }
    ];

  };

  home.file.".ssh/allowed_signers".text =
    let
      emails = lib.unique [
        github.email
        work.email
      ];
      signers = lib.flatten (map (email: map (key: "${email} ${key}") (keys.signingKeys homeDir)) emails);
    in
    lib.concatStringsSep "\n" signers;
}
