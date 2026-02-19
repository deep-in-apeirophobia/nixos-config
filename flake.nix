{
	description = "Atrin's nixos config";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixos-generators.url = "github:nix-community/nixos-generators";

		helium = {
			url = "github:schembriaiden/helium-browser-nix-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		nvim-config = {
			url = "github:deep-in-apeirophobia/Nvim-Config/main";
			flake = false;
		};

		tmux-config = {
			url = "github:deep-in-apeirophobia/tmux-config/main";
			flake = false;
		};

	};
	outputs = {self, nixpkgs, home-manager, ...}@inputs :
		let
			mkNixoscConfig = { hostname, username, system ? "x86_64-linux", }:
				nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = { inherit inputs hostname username; };
					modules = [
						./configuration.nix
						./hosts/${hostname}.nix
						# ./modules/nixos/common.nix
						home-manager.nixosModules.home-manager
						{
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.users.${username} = import ./home/${username}.nix;
							home-manager.extraSpecialArgs = { inherit inputs hostname username; };
						}
					];
				};
			mkHomeConfig = { hostname, username, system ? "x86_64-linux", }:
				home-manager.lib.homeManagerConfiguration{
					pkgs = nixpkgs.legacyPackages.${system};
					extraSpecialArgs = { inherit inputs hostname username; };
					modules = [
						# ./home/global.nix
						./home/${username}.nix
					];
				};

		in {
			nixosConfigurations = {
        laptop = mkNixosConfig { 
          hostname = "parachutte"; 
          username = "atrin";
        };
      };

			homeConfigurations = {
				"atrin@parachutte" = mkHomeConfig {
					hostname = "parachutte";
					username = "atrin";
				};
			};

			# packages.x86_64-linux = {
			# 	iso = nixos-generators.nixosGenerate {
			# 		pkgs = nixpkgs.legacyPackages.x86_64-linux;
			# 		modules = [ ./hosts/installer ];
			# 		format = "iso";
			# 	};
			# };
    };
}
