{ ... }: {
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    # "signed" (default) keeps the upstream .app untouched so 1Password,
    # iCloud Passwords and Touch ID keep working; policies go to the
    # app.zen-browser.zen defaults domain instead of into the bundle.
    darwin.packageMode = "signed";

    policies = {
      DisableTelemetry = true;
      DisableAppUpdate = true; # nix pins the version
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

  # stylix-minimal auto-enables its zen target; it needs to know which profile.
  stylix.targets.zen-browser.profileNames = [ "default" ];
}
