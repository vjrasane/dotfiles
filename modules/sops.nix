{
  config,
  pkgs,
  lib,
  dotfiles,
  homeDir,
  ...
}:
let
  keys = import "${dotfiles}/keys.nix";

  sopsAuthorizedKeys = builtins.filter (k: lib.hasPrefix "ssh-ed25519 " k) keys.encryptionKeys;

  sopsAgeKeys = lib.pipe sopsAuthorizedKeys [
    (map (
      k:
      pkgs.runCommand "ssh-to-age" { nativeBuildInputs = [ pkgs.ssh-to-age ]; } ''
        echo "${k}" | ssh-to-age | tr -d '\n' > $out
      ''
    ))
    (map builtins.readFile)
  ];

  allAgeKeys = sopsAgeKeys ++ [ keys.age ];
in
{
  home.file.".sops.yaml".text = builtins.toJSON {
    creation_rules = [ { age = lib.concatStringsSep "," allAgeKeys; } ];
  };

  home.activation.sopsAgeKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    keyfile="${config.xdg.configHome}/sops/age/keys.txt"
    mkdir -p "$(dirname $keyfile)"
    ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "${keys.currentMachine.privateKeyPath homeDir}" > "$keyfile"
    chmod 600 "$keyfile"
  '';
}
