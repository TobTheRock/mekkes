{ config, pkgs, ... }: {
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

  # System-wide so every app (not just home-manager ones) sees them.
  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
    symbols-only
  ];

  # sudo via Touch ID. Goes into /etc/pam.d/sudo_local, which survives macOS
  # updates. reattach makes it work inside tmux too.
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  # zsh is configured system-wide (/etc/zshrc) — no home-manager zsh.
  # Ctrl-R history, Tab ** completion, Ctrl-G git pickers. The scripts call
  # `fzf`, so it must be on PATH too.
  environment.systemPackages = [ pkgs.fzf ];
  # Where `cargo install` / `cargo binstall` put binaries.
  environment.systemPath = [ "${config.users.users.tobiaswaurick.home}/.cargo/bin" ];
  programs.zsh = {
    enableFzfHistory = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
  };

  # ponytail: no system.defaults / homebrew yet — add the knobs you actually
  # change by hand (dock, finder, keyboard) instead of a speculative block.
}
