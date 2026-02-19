{ config, pkgs, ... }:
{
  # Shared across all hosts
  home.stateVersion = "24.11";
  
  imports = [
    ../modules/shell.nix
    ../modules/git.nix
    ../modules/hyprland.nix
    ../modules/doom-emacs.nix
    ../modules/neovim.nix
    ../modules/utils.nix
    ../modules/browsers.nix

    ../modules/media/common.nix

    ../modules/dev/default.nix
  ];
  
  programs.home-manager.enable = true;

	programs.hyprland.enable = true;
	programs.kitty.enable = true;

	wayland.windowManager.hyprland.enable = true;

	home.sessionVariables.NIXOS_OZONE_WL = "1";

	home.username = "atrin";
	home.homeDirectory = "/home/atrin";

	programs.git.userName = "Atrin Hojjat";
	# programs.git.userEmail = "hi@atrin.dev";
	programs.git.userEmail = "atrin.hojjat@gmail.com";

}
