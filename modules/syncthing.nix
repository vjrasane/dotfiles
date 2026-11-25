{
  config,
  lib,
  pkgs,
  dotfiles,
  homeDir,
  ...
}:
let
  id = "A1XXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
  address = "tcp://A1_PUBLIC_IP:22000";
in
{
  home.packages = with pkgs; [
    syncthing
  ];

  services.syncthing = {
    enable = true;
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
      };

      folders.corpus = {
        path = "~/corpus";
        devices = [ ];
        type = "sendreceive";
      };

      options = {
        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
        relaysEnabled = false;
      };
    };
  };
}
