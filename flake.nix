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
				system = builtins.currentSystem;
				modules = [
					./hosts/MasayukiSakainoMacBook-Air/default.nix
					home-manager.darwinModules.home-manager
				];
			};

			"2023-X0160" = nix-darwin.lib.darwinSystem {
				system = builtins.currentSystem;
				modules = [
					./hosts/2023-X0160/default.nix
					home-manager.darwinModules.home-manager
				];
			};
		};
	};
}

