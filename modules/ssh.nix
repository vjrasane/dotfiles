{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      ocivm = {
        hostname = "152.70.169.143";
        port = 2222;
        user = "ubuntu";
      };
    };
  };
}
