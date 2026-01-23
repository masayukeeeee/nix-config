{ ... }: {
  imports = [
    ../../home/common/default.nix
  ];

  home.username = "masayukisakai";
  home.homeDirectory = "/Users/masayukisakai";
  home.stateVersion = "24.05";

  programs.git.settings.user = {
    name = "masayukeeeee";
    email = "masayukeeeee@gmail.com";
  };
}

