let
  keys = import ./keys.nix;
in
{
  "secrets/restic-homelab.env.age".publicKeys = keys.encryptionKeys;
  "secrets/restic-glacier.env.age".publicKeys = keys.encryptionKeys;
  "secrets/restic-s3.env.age".publicKeys = keys.encryptionKeys;
  "secrets/restic-work.env.age".publicKeys = keys.encryptionKeys;
  "secrets/secrets.zsh.age".publicKeys = keys.encryptionKeys;
  "secrets/kubeconfig-k3s.age".publicKeys = keys.encryptionKeys;
  "secrets/kubeconfig-prod.age".publicKeys = keys.encryptionKeys;
  "secrets/kubeconfig-staging.age".publicKeys = keys.encryptionKeys;
  "secrets/kubeconfig-verda.age".publicKeys = keys.encryptionKeys;
  "secrets/ansible-inventory.yml.age".publicKeys = keys.encryptionKeys;
}
