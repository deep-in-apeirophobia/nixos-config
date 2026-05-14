{ config, pkgs, inputs, ... }:
{
	programs.neovim = {
		enable = true;
		# package = pkgs.neovim-nightly;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

		withPython3 = true;
		withRuby = false;
	};

	xdg.configFile."nvim" = {
		source = inputs.nvim-config;
		recursive = true;
	};
}
