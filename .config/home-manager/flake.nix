{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Import machine-specific config (username, system, etc.)
      # Copy local.nix.example to local.nix and customize
      local = import ./local.nix;

      pkgs = nixpkgs.legacyPackages.${local.system};
    in {
      homeConfigurations.${local.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit local;
        };

        modules = [ ./home.nix ];
      };
    };
}
