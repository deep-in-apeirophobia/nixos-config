{
	description = "Atrin's nixos config";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixos-generators.url = "github:nix-community/nixos-generators";

		catppuccin.url = "github:catppuccin/nix";

		helium = {
			url = "github:schembriaiden/helium-browser-nix-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

		nvim-config = {
			# url = "github:deep-in-apeirophobia/Nvim-Config";
			url = "path:/home/atrin/dotfiles/Nvim-Config";
			flake = false;
		};

		tmux-config = {
			url = "github:deep-in-apeirophobia/tmux-config";
			flake = false;
		};

		t3code = {
      url = "github:rodeyseijkens/t3code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		codex-cli-nix.url = "github:sadjow/codex-cli-nix";
	};
	outputs = {self, nixpkgs, home-manager, ...}@inputs :
		let
			mkNixosConfig = { hostname, username, system ? "x86_64-linux", }:
				nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = { inherit inputs hostname username system; };
					modules = [
						./configuration.nix
						./hosts/${hostname}.nix
						{
							programs.appimage.enable = true;
							programs.appimage.binfmt = true;
							environment.systemPackages = [
								(inputs.t3code.packages.${system}.default.overrideAttrs (_: { pkgs = null; }))
							];
						}
						# ./modules/nixos/common.nix
						home-manager.nixosModules.home-manager
						{
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.sharedModules = [ inputs.catppuccin.homeModules.catppuccin ];
							home-manager.users.${username} = import ./home/${username}.nix;
							home-manager.extraSpecialArgs = { inherit inputs hostname username system; };
						}
						inputs.catppuccin.nixosModules.catppuccin
					];
				};
			mkHomeConfig = { hostname, username, system ? "x86_64-linux", }:
				home-manager.lib.homeManagerConfiguration{
					pkgs = nixpkgs.legacyPackages.${system};
					extraSpecialArgs = { inherit inputs hostname username system; };
					modules = [
					{
						nixpkgs.config.allowUnfree = true;
					}
						# ./home/global.nix
						./home/${username}.nix
						inputs.catppuccin.homeModules.catppuccin
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
