{ nixpkgs, conf, config, lib, pkgs, hostname, username, ...}: 
{
	services.tailscale = {
		enable = true;
	};
	systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];
}
