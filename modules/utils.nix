{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		# Common utilities
		curl
		wget
		rsync
		git
		jq
		ripgrep
		fd
		fzf
		zoxide
		eza
		bat
		file
		unzip
		zip
		p7zip
		tree
		btop
		htop

		# File manager + archive tools
		dolphin
		ark

		# PDF viewer
		okular
		tor-browser
		wine

		# Hyprland essentials
		xwayland
		xdg-desktop-portal
		xdg-desktop-portal-hyprland
		wl-clipboard
		cliphist
		wl-gammactl
		grim
		slurp
		swappy
		hyprpicker
		swaybg
		hyprpaper
		hypridle
		waybar
		dunst
		swaynotificationcenter
		wofi
		starship
		polkit_gnome
		imagemagick
	];
}
