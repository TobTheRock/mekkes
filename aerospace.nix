{ config, lib, ... }:

let
  ghostty = config.home-manager.users.${config.system.primaryUser}.programs.ghostty.package;
  workspaces = map toString (lib.range 1 9);
  binds =
    prefix: cmd: lib.listToAttrs (map (w: lib.nameValuePair "${prefix}${w}" "${cmd} ${w}") workspaces);
in
{
  services.aerospace = {
    enable = true;

    settings.mode.main.binding = {
      # -n: always a new window, even when Ghostty is already running.
      alt-enter = "exec-and-forget open -na ${ghostty}/Applications/Ghostty.app";
      alt-q = "close";
      alt-t = "layout floating tiling";
      alt-f = "fullscreen";

      alt-left = "focus left";
      alt-right = "focus right";
      alt-up = "focus up";
      alt-down = "focus down";

      alt-shift-up = "focus-monitor prev";
      alt-shift-down = "focus-monitor next";

      alt-shift-left = "move left";
      alt-shift-right = "move right";

      alt-tab = "workspace-back-and-forth";

      alt-r = "mode resize";
    }
    // binds "alt-" "workspace"
    // binds "alt-shift-" "move-node-to-workspace";

    settings.mode.resize.binding = {
      left = "resize width -50";
      right = "resize width +50";
      up = "resize height -50";
      down = "resize height +50";
      enter = "mode main";
      esc = "mode main";
    };
  };
}
