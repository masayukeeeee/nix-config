{ pkgs, ... }: {
  home.packages = with pkgs; [
    jq
    tree
    duckdb
    delta
    gh
    bat
    uv
  ];
}
