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
    krew2nix = {
      url = "github:eigengrau/krew2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      agenix,
      krew2nix,
      ...
    }:
    let
      system = builtins.currentSystem;
      username = builtins.getEnv "USER";
      pkgs = nixpkgs.legacyPackages.${system};
      kubectl = krew2nix.packages.${system}.kubectl;
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          agenix-cli = agenix.packages.${system}.default;
          dotfiles = "${builtins.getEnv "HOME"}/dotfiles";
          homeDir = builtins.getEnv "HOME";
          inherit kubectl;
        };
        modules = [
          agenix.homeManagerModules.default
          ./home.nix
          ./modules/tmux.nix
          ./modules/git.nix
          ./modules/zsh.nix
          ./modules/i3.nix
          ./modules/kubernetes.nix
          ./modules/neovim.nix
        ];
      };
    };
}
