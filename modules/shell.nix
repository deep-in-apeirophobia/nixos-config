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
			fish_vi_key_bindings
			set -g fish_greeting
			starship init fish | source
		'';
	};

	home.file.".config/starship.toml".text = ''
# Spacefish-inspired prompt via Starship
format = "$all"

[character]
success_symbol = "❯"
error_symbol = "✖"

[command_duration]
min_time = 200
show_milliseconds = true
format = "took [$duration]($style) "

[time]
disabled = false
time_format = "%H:%M:%S"
format = "[$time]($style) "
'';
}
