{ config, pkgs, ... }:
{
  # Shared across all hosts
  home.stateVersion = "25.11";
  
  imports = [
    ../modules/shell.nix
    ../modules/git.nix

    ../modules/hypr/hyprland.nix
    ../modules/hypr/hypridle.nix
    ../modules/hypr/hyprpaper.nix
    ../modules/hypr/waybar.nix
    # ../modules/hypr/theme.nix

    ../modules/doom-emacs.nix
    ../modules/neovim.nix
    ../modules/tmux.nix
    ../modules/communications.nix
    ../modules/libreoffice.nix
    ../modules/utils.nix
    ../modules/browsers.nix
		../modules/proxies.nix

    ../modules/media/common.nix

    ../modules/dev/default.nix
  ];
  
  programs.home-manager.enable = true;

	programs.kitty = {
		enable = true;
	};

	wayland.windowManager.hyprland.enable = true;

	home.sessionVariables.NIXOS_OZONE_WL = "1";

	home.username = "atrin";
	home.homeDirectory = "/home/atrin";

	programs.git.settings.user.name = "Atrin Hojjat";
	# programs.git.userEmail = "hi@atrin.dev";
	programs.git.settings.user.email = "atrin.hojjat@gmail.com";

}
