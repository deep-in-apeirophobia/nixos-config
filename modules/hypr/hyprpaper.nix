{ config, pkgs, ... }:
let
	wallpaperDir = "${config.home.homeDirectory}/wallpapers";

	# hypr-wallpaper [IMAGE]: put IMAGE, or a random one from ~/wallpapers, on
	# every monitor.
	setWallpaper = pkgs.writeShellApplication {
		name = "hypr-wallpaper";
		runtimeInputs = with pkgs; [ coreutils findutils jq hyprland ];
		text = ''
			img="''${1:-}"
			if [[ -z $img ]]; then
				img=$(find -L "${wallpaperDir}" -type f \( \
					-iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \
				\) | shuf -n 1)
			fi
			if [[ -z $img ]]; then
				echo "No wallpapers found in ${wallpaperDir}" >&2
				exit 1
			fi
			# hyprpaper only accepts absolute paths over IPC.
			img=$(realpath "$img")

			# Set it per monitor: the catch-all target is held by the random pick
			# from hyprpaper.conf, and an explicit monitor always wins over it.
			hyprctl monitors -j | jq -r '.[].name' | while read -r monitor; do
				hyprctl hyprpaper wallpaper "$monitor,$img"
			done
		'';
	};
in
{
	home.file.".local/bin/hypr-wallpaper".source = "${setWallpaper}/bin/hypr-wallpaper";

	# Runs as a systemd user service, so it isn't started from Hyprland too.
	services.hyprpaper = {
		enable = true;
		settings = {
			ipc = true;
			splash = false;
			# A random wallpaper from ~/wallpapers each time hyprpaper starts, i.e.
			# every login. Given a directory, hyprpaper also cycles to the next
			# image every `timeout` seconds; the timeout is ~10 years so it doesn't.
			# "*" rather than an empty monitor: hyprpaper drops empty keys.
			wallpaper = {
				monitor = "*";
				path = wallpaperDir;
				order = "random";
				timeout = 315360000;
			};
		};
	};
}
