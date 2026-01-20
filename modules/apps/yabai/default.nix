{ pkgs, self, ... }: {
  xdg.configFile."yabai/yabairc".source = self + /files/config/yabai/yabairc;
}