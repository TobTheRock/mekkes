{ ... }: {
  # Writes ~/.config/starship.toml. The shell hook lives in darwin.nix
  # (programs.zsh.promptInit) because zsh is configured system-wide.
  # stylix's starship target supplies the palette, so the colour names below
  # follow the theme.
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      directory = {
        truncation_length = 3; # last 3 parts
        truncate_to_repo = true; # inside a repo, start at its root
        fish_style_pwd_dir_length = 1; # …and shorten the rest: ~/D/xradar-app
        style = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      # ! modified, ? untracked, + staged, ⇡⇣ ahead/behind
      git_status.style = "bold red";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      cmd_duration.min_time = 2000; # ms
    };
  };
}
