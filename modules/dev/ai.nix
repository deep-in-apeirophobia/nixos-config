{ config, pkgs, ... }:
{

	services.ollama = {
		enable = true;
		package = pkgs.ollama-cuda;
	};

	home.packages = [
		# nixpkgs.llama.cpp

		# nodePackages.opencode-ai
	];
}
