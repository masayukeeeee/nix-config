{ pkgs, ... }: {
	nix.enable = false;
	system.primaryUser = "masayukisakai";

	system.stateVersion = 5;

	fonts.packages = [
    pkgs.meslo-lgs-nf          # ターミナル用 (P10k推奨)
    
    # ▼ おすすめを追加
    pkgs.udev-gothic           # 日本語×プログラミングの最強格
    pkgs.hackgen-font          # 定番の日本語対応フォント
    pkgs.jetbrains-mono        # 美しい合字を使いたい場合
  ];

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

		trackpad = {
			# タップによるクリックを有効化する
			Clicking = true;

			# トラックパッドでの右クリックを有効化する
			TrackpadRightClick = true;

			# 3本指でのドラッグを有効化する
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

			# 保存前にサムネイルを表示する
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
		# VS Codeのパスを通す
		if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
				export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
		fi
	'';
}
