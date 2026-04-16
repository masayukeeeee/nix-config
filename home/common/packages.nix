{ pkgs, ... }: {
  home.packages = with pkgs; [
    jq
    tree
    duckdb
    delta
    gh
    bat
    uv
    gemini-cli
    bitwarden-cli
    gcc
    gnumake
    tree-sitter
  ];
}
