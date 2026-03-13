{ config, pkgs, ... }:
{

	home.packages = with pkgs; [
		# steam
		# steam-run
		# vulkan-tools
		# vulkan-loader
		# vulkan-validation-layers
		airshipper
		# godot_4
	];
}
