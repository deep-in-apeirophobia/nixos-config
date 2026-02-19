{ config, pkgs, ... }:
{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
	};

	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	environment.systemPackages = with pkgs; [
		steam
		steam-run
		vulkan-tools
		vulkan-loader
		vulkan-validation-layers
		godot_4
	];
}
