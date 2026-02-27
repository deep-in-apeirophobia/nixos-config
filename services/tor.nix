{ nixpkgs, conf, config, lib, pkgs, hostname, username, ...}: 
{
	environment.systemPackages = with pkgs; [
		tor
		obfs4
		webtunnel
		nyx
	];
	
	services.tor = {
		enable = true;
		openFirewall = true;
		# relay = {
		# 	enable = true;
		# 	role = "relay";
		# };
		client.enable = true;
		settings = {
			# SocksPort = 9050;
			# ControlPort = 9051;

			# UseBridges = true;
			# ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
			# Bridge = "obfs4 IP:ORPort [fingerprint]";

			# ContactInfo = "whoknows";
			# Nickname = "idk";
			# ORPort = 9001;
			# BandWidthRate = "1 MBytes";
		};
	};
}
