{ nixpkgs, conf, config, lib, pkgs, hostname, username, ...}: 
{
	security.polkit.enable = true;
	security.soteria.enable = false;

	services.udisks2 = {
		enable = true;
		mountOnMedia = true;
	};
}
