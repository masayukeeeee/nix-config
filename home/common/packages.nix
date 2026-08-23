{ pkgs, ... }:

let
  terminal-browser = pkgs.callPackage ../../packages/terminal-browser.nix { };
  terminal-code = pkgs.callPackage ../../packages/terminal-code.nix { };
in
{
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
    terminal-browser
    terminal-code
  ];
}
