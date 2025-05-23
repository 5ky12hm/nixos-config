{
	description = "A very basic flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs = { self, nixpkgs }: {

		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "aarch64-linux";
			modules = [
				./configuration.nix
			];
		};

	};
}
