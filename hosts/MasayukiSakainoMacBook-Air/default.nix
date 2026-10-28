{ self, ... }: {
  imports = [
    ./darwin.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # Preserve existing files before replacing them with managed symlinks.
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit self; };

  home-manager.users.masayukisakai = import ../../users/masayukisakai/home.nix;
}
