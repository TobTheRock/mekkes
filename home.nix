{ config, ... }: {
  # username/homeDirectory come from nix-darwin's users.users.tobi
  home.stateVersion = "24.05";

  nvim.configDirectory = config.home.homeDirectory + "/Development/nix/mekkes";
}
