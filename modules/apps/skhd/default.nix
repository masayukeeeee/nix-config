{ pkgs, self, ... }: {
  xdg.configFile."skhd/skhdrc".source = self + /files/config/skhd/skhdrc;
}

