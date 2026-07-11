{ inputs, config, pkgs, ... }:
{

	services.ollama = {
		enable = true;
		package = pkgs.ollama-cuda;
	};

	home.packages = [
		# pkgs.llama.cpp

		# nodePackages.opencode-ai

		inputs.codex-cli-nix.packages.${pkgs.system}.default
		pkgs.opencode
		pkgs.claude-code
	];
}
