{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		lua5_1
		luarocks
	];
}
