{
	description = "A flake to provision my environment";

	inputs = {
		nixpkgs = {
			url = "github:nixos/nixpkgs?ref=nixos-unstable";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-darwin = {
			url = "github:LnL7/nix-darwin";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, nix-darwin }: {
		darwinConfigurations = {
			"MasayukiSakainoMacBook-Air" = nix-darwin.lib.darwinSystem {
				system = "aarch64-darwin";

				modules = [
					./modules/darwin.nix

					home-manager.darwinModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;

						home-manager.extraSpecialArgs = { inherit self; };

						home-manager.users.masayukisakai = import ./modules/home.nix;
					}
				];
			};
		};
	};
}

