{ config, pkgs, inputs, ... }:
{
	programs.tmux.enable = true;

	xdg.configFile."tmux" = {
		source = inputs.tmux-config;
		recursive = true;
	};

	xdg.configFile."tmux/.tmux.conf".source = "${inputs.tmux-config}/.tmux.conf";
}
