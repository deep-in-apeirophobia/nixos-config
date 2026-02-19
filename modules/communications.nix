{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		telegram-desktop
		weechat
		element-desktop
		protonmail-bridge
	];
}
