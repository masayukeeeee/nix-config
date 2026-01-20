{ pkgs, ... }: {
	nix.enable = false;
	system.primaryUser = "masayukisakai";

	system.stateVersion = 5;

	system.defaults = {
		finder = {
				AppleShowAllFiles = true;
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

	programs.zsh.interactiveShellInit = ''
		# VS Codeのパスを通す
		if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
				export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
		fi
	'';
}
