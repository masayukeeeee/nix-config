{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    
    # --- 基本設定 ---
    shortcut = "s";      # set -g prefix C-s
    mouse = true;        # set-option -g mouse on
    keyMode = "vi";      # set-window-option -g mode-keys vi
    baseIndex = 1;       # (推奨) ウィンドウ番号を1から開始（お好みで削除可）
    escapeTime = 0;      # (推奨) vimのESC遅延防止（sensibleにも含まれますが念のため）

    # --- プラグイン設定 (TPMは不要になります) ---
    plugins = with pkgs.tmuxPlugins; [
      sensible
      continuum
      {
        plugin = resurrect;
        # resurrect 固有の設定はここに書けます
        extraConfig = ''
          set -g @resurrect-save 'S'
          set -g @resurrect-restore 'R'
        '';
      }
    ];

    # --- その他の設定 & キーバインド ---
    extraConfig = ''
      # default shell
      set -g default-command "''${SHELL}"

      # --- Pane Navigation (h,j,k,l) ---
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # --- Pane Resizing (User Custom: y,u,g,b) ---
      bind y resize-pane -L 5
      bind u resize-pane -R 5
      bind g resize-pane -U 5
      bind b resize-pane -D 5

      # --- Window Splitting (-, |) ---
      # 注: tmuxの -h オプションは「左右分割(Horizontal split)」、-v は「上下分割」です
      bind - split-window -h
      bind | split-window -v

      # --- New Window with Current Path ---
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
