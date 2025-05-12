{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs = { self, nixpkgs }: {

		# nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
		# 	system = "aarch64-linux";
		# 	modules = [
		# 		./configuration.nix
		# 	];
		# };

		nixosConfigurations.nixos-aarch64 = nixpkgs.lib.nixosSystem {
			system = "aarch64-linux";
			modules = [
				./configuration.nix
			];
		};
		nixosConfigurations.nixos-x86_64 = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./configuration.nix
			];
		};
		nixosConfigurations.nixos = self.nixosConfigurations.nixos-aarch64;
	};
}
