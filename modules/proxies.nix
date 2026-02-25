{ nixpkgs, conf, lib, pkgs, hostname, username, ...}: 
{
	programs.clash-verge = {
    enable = true;
    serviceMode = true;
    tunMode = true;
    autoStart = false;
    package = pkgs.clash-nyanpasu; # Alternative fork
  };
}
