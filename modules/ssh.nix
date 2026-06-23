{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      ocivm-a1 = {
        hostname = "152.70.169.143";
        port = 2222;
        user = "ubuntu";
      };
      ocivm-e2 = {
        hostname = "89.168.112.189";
        port = 2222;
        user = "ubuntu";
      };
    };
  };
}
