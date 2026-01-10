let
  thinkpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMng4MtYJch2SZUg3gwScDmtDOgdsT7WP+eu/XuFqxcb";
  homeWsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcvHxqEvHOH8TRWWy5RwUkQhGIcqt7HEDld7gD31JjZ";

  age = {
    publicKey = "age10qhzl4m6h2u6a9ankqdahuj2pexsj2f44af09g5q2w9sntupssyq96skej";
    privateKeyPath = homeDir: "${homeDir}/.config/age/key.txt";
  };

  master = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4av0koifiGT137NRGZ60x9DaH8t8GqNRDFjwqh43fZdYDjWNFH6TlCNxQZmhuZYVazGWqpx0+ar9WzrZqpB8vMZCL6v2opvKv5MCrVnj23aEQ2T4v8KWPQBUUYKDHKHZrUbwUmFDZ/9hCMA5ngNZC0f8Gv1yk+CocWgqg+JoSDF4Q/HDEZpmGWJ9DB+8MNKmSXFV2SvuzM3FCe2f2PAvRcmeobhuaTSWby9hJljlxt4IbIyNgULuQYiy1B6ibkS9eb7ukeVMHIoOMj7gU85TvYLLWAnhAAYS495B5e1zXOZKfScgn1Vlw5viyDEx91dvkHmkkHyoihwq18swL+mt5g7lN1K6qYvC/Mi1uBic2xR7qkLCo/lMkusRft1etKv5ML7CQdk3SN4zrPcWgo0b5Ke1/qxCX4o8J7g4C5tqnOvkUAL99GS/jdGJhauZqdN5Ts6zVLevGyeE2yFQrU2fVqYM3+0d+L3ZrUkRAuw6gJc3x2k0QqDR2rMoaWKGNPWU="; # pragma: allowlist secret

  currentMachine = {
    privateKeyPath = homeDir: "${homeDir}/.ssh/id_ed25519";
    publicKeyPath = homeDir: "${currentMachine.privateKeyPath homeDir}.pub";
    publicKey =
      homeDir:
      builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile (currentMachine.publicKeyPath homeDir));
  };
in
{
  inherit age master currentMachine;
  encryptionKeys = [
    homeWsl
    thinkpad
    age.publicKey
    master
  ];
  signingKeys = homeDir: [
    master
    (currentMachine.publicKey homeDir)
  ];
}
