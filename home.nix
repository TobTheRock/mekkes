{ config, ... }: {
  imports = [ ./dev.nix ];

  # username/homeDirectory come from nix-darwin's users.users.tobi
  home.stateVersion = "24.05";

  # Where this repo is checked out. Pure flake eval cannot see that, so $FLAKE
  # (the variable nh & co. already use) is the only dynamic source — and only
  # when you rebuild with --impure. Otherwise: the usual spot.
  nvim.configDirectory =
    let flake = builtins.getEnv "FLAKE";
    in if flake != "" then flake else config.home.homeDirectory + "/Development/nix/mekkes";
}
