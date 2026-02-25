{ config, pkgs, nixpkgs, ... }:
{
	imports = [
		./ai.nix
		./cpp.nix
		./go.nix
		./latex.nix
		./lua.nix
		./rust.nix
		./java.nix
		./python.nix
		./web.nix
	];

	home.packages = with pkgs; [
		obsidian
		openssl.dev
		zlib
		libffi
		direnv
		vscode
		octave
		kubectl
		doctl
	];
}
