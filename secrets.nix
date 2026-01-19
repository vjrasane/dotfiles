let
  keys = import ./keys.nix;
in
{
  "secrets/ssh_private_key.age".publicKeys = keys.encryptionKeys;
  "secrets/restic-homelab.env.age".publicKeys = keys.encryptionKeys;
  "secrets/restic-glacier.env.age".publicKeys = keys.encryptionKeys;
  "secrets/restic-s3.env.age".publicKeys = keys.encryptionKeys;
  "secrets/restic-work.env.age".publicKeys = keys.encryptionKeys;
}
