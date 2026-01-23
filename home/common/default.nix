{ ... }: {
  imports = [
    ./packages.nix
    ./zsh.nix
    ./git.nix

    # Keep existing app modules as-is for now.
    ../../modules/apps/karabiner/default.nix
    ../../modules/apps/yabai/default.nix
    ../../modules/apps/skhd/default.nix
    ../../modules/apps/nvim/default.nix
    ../../modules/apps/fzf/default.nix
    ../../modules/apps/zsh/default.nix
  ];
}

