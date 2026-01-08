let
  homeDirectory = builtins.getEnv "HOME";
  rsaPublicKeyFile = ./ssh/id_rsa.pub;
in {
  rsa = {
    publicKeyFile = rsaPublicKeyFile;
    publicKey = builtins.readFile rsaPublicKeyFile;
    privateKeyPath = "${homeDirectory}/.ssh/id_rsa";
    publicKeyPath = "${homeDirectory}/.ssh/id_rsa.pub";
  };
}
