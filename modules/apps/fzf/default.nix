{ pkgs, ... }: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # zsh用のキーバインド等を自動設定
   
    # FZF_DEFAULT_COMMAND の代わり
    # (例: fd (findの高速版) を使う設定)
    defaultCommand = "fd --type f";

    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];

    # Ctrl+T (ファイル検索) 
    fileWidgetCommand = "fd --type f";
    
    # Alt+C (ディレクトリ移動) 
    changeDirWidgetCommand = "fd --type d";
  };

  # fzfで使うツール(fdやbat)もついでに入れておくと便利です
  home.packages = with pkgs; [
    fd
    bat
  ];
}