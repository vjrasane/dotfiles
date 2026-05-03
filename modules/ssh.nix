{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      ocivm = {
        hostname = "132.145.234.144";
        user = "ubuntu";
      };
    };
  };
}
