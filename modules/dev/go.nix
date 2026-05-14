{ config, pkgs, ... }: let
  gotoolsWithoutModernize = pkgs.symlinkJoin {
    name = "gotools-without-modernize";
    paths = [pkgs.gotools];
    postBuild = ''
      rm -f "$out/bin/modernize"
    '';
  };
in
{
	home.packages = with pkgs; [
		go
		gopls
		# gotools
		gotoolsWithoutModernize
		golangci-lint
		delve
		govulncheck
		cobra-cli
		air
	];
}
