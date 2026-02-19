{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		python3
		python3Packages.pip
		python3Packages.virtualenv
		python3Packages.debugpy
		python3Packages.jupyterlab
		pipx
		poetry
		uv
		ruff
		black
		isort
		mypy
		pyright
	];
}
