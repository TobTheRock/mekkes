{ lib, ... }: {
  programs.zen-browser = {
    enable = true;
    # The app itself is the `zen` cask (homebrew.nix), so it lands in
    # /Applications. This module only manages profiles, policies and
    # extensions; in "signed" mode policies go to the app.zen-browser.zen
    # defaults domain, which the cask's app reads too.
    package = null;
    darwin.packageMode = "signed";

    policies = {
      DisableTelemetry = true;
      # The cask is auto_updates, so brew never upgrades it; Zen must.
      DisableAppUpdate = false;
      PasswordManagerEnabled = false; # Proton Pass handles logins
      # Extensions: AMO id -> slug from addons.mozilla.org/firefox/addon/<slug>.
      # Force-installed from AMO on start; removing a line uninstalls it.
      ExtensionSettings = builtins.mapAttrs
        (_: slug: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
          installation_mode = "force_installed";
        })
        {
          "uBlock0@raymondhill.net" = "ublock-origin";
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = "proton-pass";
        };
    };

    profiles.default = {
      id = 0;
      isDefault = true;
    };
  };

  # Zen picks a profile per install location, keyed by a hash of the app path
  # (/Applications/Zen.app here). Without this it creates and locks its own
  # "Default (release)" profile and ignores the Nix-managed one. Read the hash
  # from installs.ini if the app ever moves.
  home.file."Library/Application Support/Zen/installs.ini" = {
    force = true;
    text = lib.generators.toINI { } {
      "6ED35B3CA1B5D3AF" = {
        Default = "Profiles/default";
        Locked = 1;
      };
    };
  };

  # stylix-minimal auto-enables its zen target; it needs to know which profile.
  stylix.targets.zen-browser.profileNames = [ "default" ];
}
