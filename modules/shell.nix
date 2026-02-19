{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		oh-my-fish
	];

	programs.fish = {
		enable = true;
		shellAliases = {
			ls = "eza --group-directories-first --icons=auto --color=auto";
			cat = "bat --style=plain --paging=never";
		};
		interactiveShellInit = ''
			set -g fish_greeting
		'';
	};
}
