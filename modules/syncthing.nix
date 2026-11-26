{
  config,
  lib,
  pkgs,
  dotfiles,
  homeDir,
  ...
}:
let
  id = "TJ7IO3A-APGOG2Y-5DRHGM4-7CSW7FE-Y5MABCS-SIJ2JVK-QLZR3QW-R5YBOQO";
  address = "tcp://152.70.169.143:22000";
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
      devices.a1 = {
        inherit id;
        addresses = [ address ];
      };

      folders.corpus = {
        path = "~/sync/corpus";
        devices = [ "a1" ];
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
