{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, sops-nix, ... }:
    let
      # Auto-detect from environment (requires --impure flag)
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
      system = builtins.currentSystem;

      # Machine-specific settings from local.nix (absolute path for impure eval)
      localNixPath = "${homeDirectory}/dotfiles/local.nix";
      local = (import (builtins.toPath localNixPath)) // { inherit username homeDirectory system; };

      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit local;
        };

        modules = [
          sops-nix.homeManagerModules.sops
          ./home.nix
        ];
      };
    };
}
