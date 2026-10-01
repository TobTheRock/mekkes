{
  imports = [ ./aerospace.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowunfree=true;

  # The Determinate installer owns the nix daemon and its config; nix-darwin
  # must not fight it for /etc/nix/nix.conf. Drop this if you ever install
  # nix some other way.
  nix.enable = false;

  system.stateVersion = 6;
  system.primaryUser = "tobiaswaurick";

  # home-manager reads homeDirectory from here; nix-darwin's default is /var/empty.
  users.users.tobiaswaurick.home = "/Users/tobiaswaurick";

  # ponytail: no system.defaults / homebrew yet — add the knobs you actually
  # change by hand (dock, finder, keyboard) instead of a speculative block.
}
