{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		hyprpwcenter
	];
	# programs.hyprpwcenter = {
	# 	enable = true;
	# };
}
