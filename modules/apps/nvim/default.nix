{ pkgs, self, ... }: {
  programs.neovim = {
    enable = true;
    
    # ▼ これを true にすると、vim コマンドで nvim が起動します
    viAlias = true;
    vimAlias = true;
    
    withNodeJs = true;
  };

  # 設定ファイルのリンク (Read-only)
  xdg.configFile."nvim".source = self + /files/config/nvim;
}
