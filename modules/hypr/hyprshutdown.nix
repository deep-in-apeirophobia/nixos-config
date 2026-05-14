{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		hyprshutdown
	];
	# programs.hyprshutdown = {
	# 	enable = true;
	# };
}
