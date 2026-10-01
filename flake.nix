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

    # Installs Homebrew itself; nix-darwin's homebrew module only drives it.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      nichtsverbessert,
      fenix,
      nix-homebrew,
      zen-browser,
      ...
    }:
    {
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin.nix
          ./homebrew.nix
          nix-homebrew.darwinModules.nix-homebrew
          { nixpkgs.overlays = [ fenix.overlays.default ]; }
          home-manager.darwinModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            home-manager = {
              useUserPackages = true;
              # so home.nix sees the darwin-level overlays (fenix)
              useGlobalPkgs = true;
              users.tobiaswaurick = {
                imports = [ ./home.nix ];
              };

              sharedModules = [
                nichtsverbessert.homeModules.nvim
                nichtsverbessert.homeModules.stylix-minimal
                zen-browser.homeModules.beta
              ];
            };
          }
        ];
      };
    };
}
