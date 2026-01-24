{ pkgs, ... }: {
  nix.enable = false;
  system.primaryUser = "masayukisakai";

  system.stateVersion = 5;

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Always";
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 12;
      KeyRepeat = 2;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTextShowsControlCharacters = true;
      "com.apple.mouse.tapBehavior" = 1;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };

    finder = {
      ShowStatusBar = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv";
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
    };

    dock = {
      autohide = true;
      tilesize = 10;
    };

    screencapture = {
      location = "/Users/masayukisakai/Downloads/screencapture";
      type = "png";
      disable-shadow = true;
      show-thumbnail = true;
      target = "file";
    };
  };

  users.users.masayukisakai = {
    home = "/Users/masayukisakai";
    description = "MasayukiSakainoMacBook-Air";
  };

  nix.settings.trusted-users = [ "root" "masayukisakai" ];

  environment.systemPackages = [
    pkgs.vim
  ];

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
  };

  services.skhd.enable = true;

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "google-chrome"
      "bitwarden"
      "notion"
      "slack"
      "karabiner-elements"
      "iterm2"
      "visual-studio-code"
      "displaylink"
    ];
  };

  programs.zsh.enable = true;

  programs.zsh.interactiveShellInit = ''
    # Add VS Code CLI to PATH
    if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
      export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fi
  '';
}

