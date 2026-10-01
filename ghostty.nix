{ pkgs, ... }: {
  # Colors + font (JetBrains Mono Nerd Font) come from stylix's ghostty target,
  # auto-enabled by stylix-minimal once programs.ghostty is on.
  programs.ghostty = {
    enable = true;
    # nixpkgs' `ghostty` is Linux-only; ghostty-bin is the signed macOS .app.
    package = pkgs.ghostty-bin;
    settings = {
      # Option behaves as Alt — needed for nvim/shell Alt bindings.
      macos-option-as-alt = true;
      # AeroSpace tiles windows; no need for the titlebar chrome.
      macos-titlebar-style = "hidden";
      confirm-close-surface = false;
      quit-after-last-window-closed = true;
      scrollback-limit = 10000000; # bytes
    };
  };
}
