let
  publicKeyFile = ./ssh/id_rsa.pub;
in {
  inherit publicKeyFile;
  publicKey = builtins.readFile publicKeyFile;
  privateKeySecret = "ssh_private_key";
  privateKeyPath = homeDirectory: "${homeDirectory}/.ssh/id_rsa";
  publicKeyPath = homeDirectory: "${homeDirectory}/.ssh/id_rsa.pub";
}
