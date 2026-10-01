{ config, ... }: {
  imports = [ ./dev.nix ./ghostty.nix ./zen.nix ];


  home = {
    username = "tobiaswaurick";
    homeDirectory = "/Users/tobiaswaurick";
    stateVersion = "24.05";
  };

  nvim.configDirectory = "/Dev/nix/mekkes";
}
