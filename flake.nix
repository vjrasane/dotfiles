{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, agenix, ...}: let
    system = builtins.currentSystem;
    username = builtins.getEnv "USER";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        agenix-cli = agenix.packages.${system}.default;
        dotfiles = "${builtins.getEnv "HOME"}/dotfiles";
        homeDir = builtins.getEnv "HOME";
      };
      modules = [
        agenix.homeManagerModules.default
        ./home.nix
        ./modules/tmux.nix
        ./modules/git.nix
      ];
    };
  };
}
