{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		go
		gopls
		gotools
		golangci-lint
		delve
		govulncheck
		cobra-cli
		air
	];
}
