{ ... }: {
  programs.zsh = {
    enable = true;
    shellAliases = {
      l = "ls -la";
      # Apply this flake (uses Makefile defaults; override via Makefile.local if needed)
      darwin = "make -C ~/.config/nix-config apply && exec zsh";
    };
  };
}

