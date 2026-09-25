{
  description = "macOS config — nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nichtsverbessert = {
      url = "github:TobTheRock/nichtsverbessert";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix-darwin, home-manager, nichtsverbessert, ... }: {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            users.tobi = ./home.nix;
            sharedModules = [
              nichtsverbessert.homeModules.nvim
              nichtsverbessert.homeModules.stylix-minimal
            ];
          };
        }
      ];
    };
  };
}
