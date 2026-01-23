{ pkgs, ... }: {
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
}

