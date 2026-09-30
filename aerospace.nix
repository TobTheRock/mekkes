{ lib, ... }:

let
  # ponytail: 1-9 generated instead of 18 literal lines.
  workspaces = map toString (lib.range 1 9);
  binds = prefix: cmd:
    lib.listToAttrs (map (w: lib.nameValuePair "${prefix}${w}" "${cmd} ${w}") workspaces);
in
{
  services.aerospace = {
    enable = true;

    # Hotkeys mirror the nvim config (nichtsverbessert): hjkl to move around,
    # s/v to split, d to close.
    #
    # alt, not ctrl: nvim + tmux own ctrl-hjkl, aerospace would swallow them.
    settings.mode.main.binding = {
      # navigation — C-hjkl in nvim
      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";

      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      # windows — <leader>w… in nvim. :split stacks, :vsplit sits side by side.
      alt-s = "layout tiles vertical";
      alt-v = "layout tiles horizontal";
      alt-shift-d = "close";
      alt-f = "fullscreen";

      alt-minus = "resize smart -50";
      alt-equal = "resize smart +50";

      # workspaces — no nvim equivalent, the usual alt-N / alt-shift-N.
      alt-tab = "workspace-back-and-forth";
    }
    // binds "alt-" "workspace"
    // binds "alt-shift-" "move-node-to-workspace";
  };
}
