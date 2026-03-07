{ config, pkgs, ... }:
{
	home.file.".local/bin/hypr-wallpaper" = {
		executable = true;
		text = ''
			#!/usr/bin/env bash
			WALLPAPER_DIR="$HOME/wallpapers"

			# Pick a random image from the folder
			img=$(find "$WALLPAPER_DIR" -type f \( \
				-iname "*.jpg"  -o \
				-iname "*.jpeg" -o \
				-iname "*.png"  -o \
				-iname "*.gif"  \
			\) | shuf -n 1)

			if [[ -z "$img" ]]; then
				echo "No wallpapers found in $WALLPAPER_DIR"
				exit 1
			fi

			# Wait for hyprpaper socket to be ready
			# until hyprctl hyprpaper listloaded &>/dev/null; do
			# 	sleep 0.5
			# done

			# Preload then set on all monitors
			hyprctl hyprpaper preload "$img"
			hyprctl hyprpaper wallpaper ",$img"    # empty monitor = all monitors

			# Optional: unload previous wallpapers to free memory
			hyprctl hyprpaper unload unused
		'';
	};

	services.hyprpaper = {
		enable = true;
		settings = {
			ipc = "on";
			splash = false;
		};
	};
}
