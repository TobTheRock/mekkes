{ lib, pkgs, ... }: {
  # Writes ~/.config/starship.toml. The shell hook lives in zsh.nix
  # (programs.zsh.promptInit) because zsh is configured system-wide.
  # stylix's starship target supplies the palette, so the colour names
  # follow the theme.
  programs.starship = {
    enable = true;
    # Official "pure" preset, squashed onto one line, with a short path.
    settings = lib.recursiveUpdate
      (lib.importTOML "${pkgs.starship}/share/starship/presets/pure-preset.toml")
      {
        # Preset format minus $line_break.
        format = lib.concatStrings [
          "$username$hostname$directory$git_branch$git_state$git_status"
          "$cmd_duration$python$character"
        ];
        add_newline = false;
        directory = {
          truncation_length = 3; # last 3 parts
          truncate_to_repo = true; # inside a repo, start at its root
          fish_style_pwd_dir_length = 1; # …and abbreviate the rest: ~/D/xradar-app
        };
        # main  /  main* ⇡  — exactly one space before ❯ either way. The
        # preset's per-state symbols are zero-width, so (*…) shows when any
        # of them is set.
        git_branch.format = "[$branch]($style)";
        git_status.format = lib.concatStrings [
          "([*$conflicted$untracked$modified$staged$renamed$deleted](218))"
          "( [$ahead_behind$stashed]($style)) "
        ];
      };
  };
}
