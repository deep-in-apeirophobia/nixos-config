{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		gcc
		clang
		clang-tools

		cmake
		gnumake

		cppcheck
		valgrind
		
		vcpkg-tool

		ninja

		gdb
		lldb
		pkg-config
	];

	home.sessionVariables = {
    CC = "gcc";
    CXX = "g++";
  };
}
