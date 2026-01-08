let
  keys = import ./keys.nix;
in {
  "secrets/ssh_private_key.age".publicKeys = keys.encryptionKeys;
  "secrets/restic.env.age".publicKeys = keys.encryptionKeys;
}
