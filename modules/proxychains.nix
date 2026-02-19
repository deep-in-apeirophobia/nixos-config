{ config, pkgs, ... }:
{
	programs.proxychains = {
    enable = true;
		proxyDNS = true;
		proxies = {
			tor = {
				type = "socks5";
				host = "127.0.0.1";
				port = "9050";
			};
			torbrowser = {
				type = "socks5";
				host = "127.0.0.1";
				port = "9150";
			};
			tunnel = {
				type = "socks5";
				host = "127.0.0.1";
				port = "1112";
			};
			nekoray = {
				type = "http";
				host = "127.0.0.1";
				port = "2080";
			};
		};
  };
}
