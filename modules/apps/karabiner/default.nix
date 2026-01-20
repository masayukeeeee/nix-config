{ pkgs, self, ... }: {
  xdg.configFile."karabiner/karabiner.json".source = self + /files/config/karabiner/karabiner.json;
}