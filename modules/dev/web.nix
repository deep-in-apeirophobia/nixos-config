{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		# nodejs
		nodejs_22
		bun
		# corepack       # Enables pnpm/yarn via 'corepack enable'
		corepack_22       # Enables pnpm/yarn via 'corepack enable'
		# (pkgs.corepack.overrideAttrs (_: { doCheck = false; }))
		# yarn
		# pnpm
		typescript
		typescript-language-server
		vscode-langservers-extracted
		prettier
		eslint
		tailwindcss
		# nodePackages."@slidev/cli"
		# nodePackages.opencode-ai
		bruno
	];

	home.sessionVariables = {
		# Force Node.js to use consistent cache location
		NPM_CONFIG_CACHE = "$HOME/.npm";
		# NODE_OPTIONS = "--max-old-space-size=4096";
	};
}
