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

		# The newest t3 code nightly is resolved out of this releases listing at
		# eval time -- upstream ships no rolling nightly tag or URL. Moving to a
		# newer nightly is `nix flake update t3code-releases`.
		t3code-releases = {
			url = "file+https://api.github.com/repos/pingdotgg/t3code/releases";
			flake = false;
		};

		codex-cli-nix.url = "github:sadjow/codex-cli-nix";

		# nixpkgs still ships waybar 0.15.0, whose hyprland/workspaces module
		# sends legacy `dispatch workspace N` and so breaks under Hyprland's Lua
		# config. Upstream master speaks the Lua dispatch protocol. Drop this
		# input once nixpkgs has a waybar release newer than 0.15.0.
		waybar = {
			url = "github:Alexays/Waybar";
			inputs.nixpkgs.follows = "nixpkgs";
		};
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
						({ pkgs, ... }: {
							programs.appimage.enable = true;
							programs.appimage.binfmt = true;
							environment.systemPackages = [
								(pkgs.callPackage ./pkgs/t3code-nightly.nix {
									releases = inputs.t3code-releases;
								})
							];
						})
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
