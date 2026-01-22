{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    
    # --- 標準機能 & プラグイン ---
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
      }
    ];

    # --- Powerlevel10k Instant Prompt ---
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    # --- 履歴設定 ---
    history = {
      size = 100000;
      save = 100000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreDups = true;
    };

    # --- エイリアス ---
    shellAliases = {
      ls = "ls -FG";
      ll = "ls -alFG";
      h = "history";
      gi = "git";
      
      # Editors
      vim = "nvim";
      vi = "nvim";
      
      # UV (Python管理はこれに統一)
      upy = "uv run python";
      uipy = "uv run ipython";
      
      # WiFi
      nkdev-comeback = "networksetup -setairportnetwork en0 nk-dev KurolanK1";
      
      # Tmux
      tm = "tmux";      
    };

    # --- 環境変数 ---
    sessionVariables = {
      LANG = "ja_JP.UTF-8";
      EDITOR = "nvim";
      LSCOLORS = "gxfxcxdxbxGxDxabagacad";
    };

    # --- その他の設定 ---
    initExtra = ''
      # --- Option ---
      setopt print_eight_bit
      setopt no_beep
      setopt ignore_eof
      setopt interactive_comments
      setopt auto_cd
      setopt auto_pushd
      setopt extended_glob

      # --- Completion Styles ---
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

      # --- Keybindings ---
      bindkey '^[[Z' reverse-menu-complete
      bindkey -e
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # --- NVM (Homebrew版) ---
      # Node.jsもNix管理にするなら削除可能です
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
      [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

      # --- Webpack ---
      export PATH=$PATH:./node_modules/.bin

      # --- Powerlevel10k Config ---
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}