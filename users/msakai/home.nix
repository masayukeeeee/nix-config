{ ... }: {
  imports = [
    ../../home/common/default.nix
  ];

  home.username = "msakai";
  home.homeDirectory = "/Users/msakai";
  home.stateVersion = "24.05";

  # If you want per-user git identity, set it here.
  programs.git.settings.user = { name = "masayukeeeee"; email = "masayukeeeee@gmail.com"; };
}

