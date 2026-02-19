{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		oh-my-fish
	];

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			set -g fish_greeting
		'';
	};
}
