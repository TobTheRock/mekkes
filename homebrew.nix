{ config, ... }: {
  nix-homebrew = {
    enable = true;
    user = config.system.primaryUser;
  };

  homebrew = {
    enable = true;
    # ponytail: no onActivation.cleanup — brew stuff installed by hand stays
    # until you list it here. Set "zap" once this list is the whole truth.
    casks = [
      # Word, Excel, PowerPoint, Outlook, OneNote + OneDrive (the separate
      # `onedrive` cask conflicts with this one).
      "microsoft-office"
      "microsoft-teams"
      "linear"
    ];
  };
}
