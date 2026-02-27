{ nixpkgs, conf, config, lib, pkgs, hostname, username, ...}: 
{
	services.udisks2 = {
		enable = true;
		mountOnMedia = true;
	};
}
