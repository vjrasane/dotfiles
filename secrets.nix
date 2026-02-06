let
  keys = import ./keys.nix;

  secretsDir = builtins.readDir ./secrets;
  secretFiles = builtins.filter (file: builtins.match ".*\\.age$" file != null) (
    builtins.attrNames secretsDir
  );
in
builtins.listToAttrs (
  map (file: {
    name = "secrets/${file}";
    value.publicKeys = keys.encryptionKeys;
  }) secretFiles
)
