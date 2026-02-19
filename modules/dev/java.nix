{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		jdk
		maven
		gradle
		jdt-language-server
		google-java-format
		spring-boot-cli
	];
}
