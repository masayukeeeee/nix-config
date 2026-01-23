{ pkgs, ... }: {
  nix.enable = false;
  system.primaryUser = "msakai";

  system.stateVersion = 5;

  # Start from the same defaults as the existing host; tweak per-machine as needed.
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 10;
      KeyRepeat = 2;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTextShowsControlCharacters = true;
      "com.apple.mouse.tapBehavior" = 1;
    };
  };

  users.users.msakai = {
    home = "/Users/msakai";
    description = "2023-X0160";
  };

  nix.settings.trusted-users = [ "root" "msakai" ];

  environment.systemPackages = [
    pkgs.vim
  ];

  programs.zsh.enable = true;
}

