{ config, ... }: {
  home = {
    username = "tobi";
    homeDirectory = "/Users/tobi";
    stateVersion = "24.05";
  };

  nvim.configDirectory = config.home.homeDirectory + "/Development/nix/mekkes";
}
