{ nixpkgs, conf, config, lib, pkgs, hostname, username, ...}: 
{
	services.udisk2 = {
		enable = true;
		mountOnMedia = true;
	};
}
