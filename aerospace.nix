{ config, lib, pkgs, ... }:

let
  ghostty = config.home-manager.users.${config.system.primaryUser}.programs.ghostty.package;
  aerospace = "${config.services.aerospace.package}/bin/aerospace";
  # Fuzzy list of the focused workspace's windows; picking one focuses it.
  pickWindow = pkgs.writeShellScript "aerospace-pick-window" ''
    id=$(${aerospace} list-windows --workspace focused \
      --format '%{window-id} | %{app-name} | %{window-title}' \
      | ${pkgs.choose-gui}/bin/choose | cut -d' ' -f1)
    [ -n "$id" ] && ${aerospace} focus --window-id "$id"
  '';
  workspaces = map toString (lib.range 1 9);
  binds =
    prefix: cmd: lib.listToAttrs (map (w: lib.nameValuePair "${prefix}${w}" "${cmd} ${w}") workspaces);
in
{
  # AeroSpace parks other workspaces' windows in a screen corner, which makes
  # Mission Control (ctrl+up) a mess of slivers; grouping by app fixes that.
  system.defaults.dock.expose-group-apps = true;

  services.aerospace = {
    enable = true;

    settings.mode.main.binding = {
      # -n: always a new window, even when Ghostty is already running.
      alt-enter = "exec-and-forget open -na ${ghostty}/Applications/Ghostty.app";
      # Not -n: Zen is single-instance per profile, a second copy hits the
      # profile lock. This focuses Zen, or launches it.
      alt-b = "exec-and-forget open -a /Applications/Zen.app";
      alt-w = "exec-and-forget ${pickWindow}";
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
