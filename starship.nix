{ lib, pkgs, ... }: {
  # Writes ~/.config/starship.toml. The shell hook lives in zsh.nix
  # (programs.zsh.promptInit) because zsh is configured system-wide.
  # stylix's starship target supplies the palette, so the colour names
  # follow the theme.
  programs.starship = {
    enable = true;
    # Official "pure" preset (minimal, two lines), plus a shorter path.
    settings = lib.recursiveUpdate
      (lib.importTOML "${pkgs.starship}/share/starship/presets/pure-preset.toml")
      {
        directory = {
          truncation_length = 3; # last 3 parts
          truncate_to_repo = true; # inside a repo, start at its root
        };
      };
  };
}
