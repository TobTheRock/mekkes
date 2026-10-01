{ config, ... }: {
  imports = [ ./dev.nix ];

  home.username = "tobiaswaurick";
  home.homeDirectory = "/Users/tobiaswaurick";
  home.stateVersion = "24.05";


  nvim.configDirectory = "/Dev/nix/mekkes";
}
