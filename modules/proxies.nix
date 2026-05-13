{ nixpkgs, conf, lib, pkgs, hostname, username, ...}: 
{
	# programs.clash-verge = {
 #    enable = true;
 #    serviceMode = true;
 #    tunMode = true;
 #    autoStart = false;
 #    package = pkgs.clash-nyanpasu; # Alternative fork
 #  };
	home.packages = with pkgs; [
		throne
		v2rayn
		xray
		wireguard-tools
		protonvpn-gui
	];

	xdg.dataFile = {
    # v2rayn
    "v2rayN/bin/sing_box/sing-box".source = "${pkgs.sing-box}/bin/sing-box";
    "v2rayN/bin/xray/xray".source = "${pkgs.xray}/bin/xray";
    "v2rayN/bin/geoip.dat".source = "${pkgs.v2ray-geoip}/share/v2ray/geoip.dat";
    "v2rayN/bin/geosite.dat".source = "${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat";
  };
}
