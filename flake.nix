{
  description = "macOS config — home-manager, standalone";

  inputs = {
    # nixpkgs must be a direct input: home-manager reads `pkgs.path`, which
    # only resolves for a first-class input, not a `follows` into another's.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nichtsverbessert = {
      url = "github:TobTheRock/nichtsverbessert";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nichtsverbessert, ... }: {
    homeConfigurations."tobi@mac" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [
        nichtsverbessert.homeModules.nvim
        nichtsverbessert.homeModules.stylix-minimal
        ./home.nix
      ];
    };
  };
}
