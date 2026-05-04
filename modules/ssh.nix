{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      ocivm = {
        hostname = "144.24.167.182";
        port = 2222;
        user = "ubuntu";
      };
    };
  };
}
