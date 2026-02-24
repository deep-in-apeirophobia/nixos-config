{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		gcc-unwrapped
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
    CC = "${pkgs.gcc}/bin/gcc";
    CXX = "${pkgs.gcc}/bin/g++";
  };
}
