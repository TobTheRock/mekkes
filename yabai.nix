{ config, lib, pkgs, ... }:

let
  ghostty = config.home-manager.users.${config.system.primaryUser}.programs.ghostty.package;
  yabai = "${config.services.yabai.package}/bin/yabai";
  user = config.system.primaryUser;
  # Fuzzy list of the focused space's windows; picking one focuses it.
  pickWindow = pkgs.writeShellScript "yabai-pick-window" ''
    id=$(${yabai} -m query --windows --space \
      | ${pkgs.jq}/bin/jq -r '.[] | "\(.id) | \(.app) | \(.title)"' \
      | ${pkgs.choose-gui}/bin/choose | cut -d' ' -f1)
    [ -n "$id" ] && ${yabai} -m window --focus "$id"
  '';
  # SIP stays on, so yabai can't switch spaces. alt-1..9 drive macOS's own
  # "Switch to Desktop N" shortcuts (ids 118..126) instead.
  # [ascii, keycode] per digit; 524288 is the option modifier.
  digitKeys = [ [ 49 18 ] [ 50 19 ] [ 51 20 ] [ 52 21 ] [ 53 23 ] [ 54 22 ] [ 55 26 ] [ 56 28 ] [ 57 25 ] ];
  desktopHotkey = i: k: ''
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${toString (118 + i)} \
      '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>${toString (lib.elemAt k 0)}</integer><integer>${toString (lib.elemAt k 1)}</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>'
  '';
  desktopHotkeys = pkgs.writeShellScript "desktop-hotkeys" ''
    ${lib.concatStrings (lib.imap0 desktopHotkey digitKeys)}
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
in
{
  # -dict-add keeps the other shortcuts; nix-darwin's CustomUserPreferences
  # would replace the whole AppleSymbolicHotKeys dict.
  system.activationScripts.postActivation.text = ''
    launchctl asuser "$(id -u -- ${user})" sudo --user=${user} -- ${desktopHotkeys}
  '';

  services.yabai = {
    enable = true;
    # Default partitioning: each new window splits the focused one along its
    # longer side.
    config.layout = "bsp";
    extraConfig = ''
      ${yabai} -m rule --add app="^System Settings$" manage=off
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # -n: always a new window, even when Ghostty is already running.
      alt - return : open -na ${ghostty}/Applications/Ghostty.app
      # Not -n: Zen is single-instance per profile, a second copy hits the
      # profile lock. This focuses Zen, or launches it.
      alt - b : open -a /Applications/Zen.app
      alt - w : ${pickWindow}
      alt - q : ${yabai} -m window --close
      alt - t : ${yabai} -m window --toggle float
      alt - f : ${yabai} -m window --toggle zoom-fullscreen
      # Flip the focused split between side by side and stacked.
      alt - e : ${yabai} -m window --toggle split

      alt - left : ${yabai} -m window --focus west
      alt - right : ${yabai} -m window --focus east
      alt - up : ${yabai} -m window --focus north
      alt - down : ${yabai} -m window --focus south

      alt + shift - up : ${yabai} -m display --focus prev
      alt + shift - down : ${yabai} -m display --focus next

      alt + shift - left : ${yabai} -m window --swap west
      alt + shift - right : ${yabai} -m window --swap east

      :: resize @
      alt - r ; resize
      resize < left : ${yabai} -m window --resize right:-50:0 || ${yabai} -m window --resize left:50:0
      resize < right : ${yabai} -m window --resize right:50:0 || ${yabai} -m window --resize left:-50:0
      resize < up : ${yabai} -m window --resize bottom:0:-50 || ${yabai} -m window --resize top:0:50
      resize < down : ${yabai} -m window --resize bottom:0:50 || ${yabai} -m window --resize top:0:-50
      resize < return ; default
      resize < escape ; default
    '';
  };
}
