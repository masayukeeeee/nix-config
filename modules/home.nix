{ pkgs, ... }: {
  # --- 外部設定の読み込み ---
  imports = [
    ./apps/karabiner/default.nix
		./apps/yabai/default.nix
		./apps/skhd/default.nix
    ./apps/nvim/default.nix
    ./apps/fzf/default.nix
    ./apps/zsh/default.nix
  ];

  # --- Home Manager設定 ---
  home.stateVersion = "24.05";

  # ユーザー用CLIツール
  home.packages = with pkgs; [
    tmux
    jq
    tree
    duckdb
    delta
		gh
		bat
    uv
  ];

  # --- シェル設定 (zsh) ---
  programs.zsh = {
    enable = true;
    shellAliases = {
      l = "ls -la";
      # 設定反映用のショートカット
			darwin = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin && exec zsh";
    };
  };

  # --- Git設定 ---
  programs.git = {
    enable = true;
		settings = {
			user = {
				name = "masayukeeeee";
				email = "masayukeeeee@gmail.com";
			};

			init = {
				defaultBranch = "main";
			};

			alias = {
				ad = "add";
				br = "branch";
				st = "status";
				cm = "commit";
				co = "checkout";
				sw = "switch";
				di = "diff";
			};
		};
  };
}
