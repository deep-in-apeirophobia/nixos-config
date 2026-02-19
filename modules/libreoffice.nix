{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		libreoffice
		# libreoffice-writer
		# libreoffice-calc
		# libreoffice-math
		# libreoffice-impress
		# libreoffice-draw
		# libreoffice-base
	];
}
