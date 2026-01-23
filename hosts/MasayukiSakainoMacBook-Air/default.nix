{ self, ... }: {
  imports = [
    ./darwin.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit self; };

  home-manager.users.masayukisakai = import ../../users/masayukisakai/home.nix;
}
