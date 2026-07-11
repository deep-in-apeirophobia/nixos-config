{ config, lib, pkgs, ... }:
let
	codeMimeTypes = [
		"text/plain" "text/markdown" "text/x-c" "text/x-c++" "text/x-chdr"
		"text/x-c++hdr" "text/x-cmake" "text/x-python" "text/x-rust"
		"text/x-go" "text/x-java" "text/x-lua" "text/x-shellscript"
		"application/javascript" "application/json" "application/toml"
		"application/x-yaml" "application/xml"
	];
  mimeApps = pkgs.writeText "default-mimeapps.list" ''
    [Default Applications]
    inode/directory=org.kde.dolphin.desktop
    application/pdf=org.kde.okular.desktop
		text/plain=nvim-kitty.desktop
		text/markdown=nvim-kitty.desktop
		text/x-c=nvim-kitty.desktop
		text/x-c++=nvim-kitty.desktop
		text/x-python=nvim-kitty.desktop
		text/x-rust=nvim-kitty.desktop
		text/x-go=nvim-kitty.desktop
		text/x-java=nvim-kitty.desktop
		text/x-lua=nvim-kitty.desktop
		text/x-shellscript=nvim-kitty.desktop
		application/javascript=nvim-kitty.desktop
		application/json=nvim-kitty.desktop
		application/toml=nvim-kitty.desktop
		application/x-yaml=nvim-kitty.desktop
    text/html=firefox.desktop
    x-scheme-handler/http=firefox.desktop
    x-scheme-handler/https=firefox.desktop
    x-scheme-handler/mailto=firefox.desktop
    image/jpeg=org.kde.gwenview.desktop
    image/png=org.kde.gwenview.desktop
    image/webp=org.kde.gwenview.desktop
    audio/mpeg=mpv.desktop
    audio/flac=mpv.desktop
    audio/ogg=mpv.desktop
    video/mp4=vlc.desktop
    video/x-matroska=vlc.desktop
    video/webm=vlc.desktop
    application/zip=org.kde.ark.desktop
    application/x-7z-compressed=org.kde.ark.desktop
    application/vnd.rar=org.kde.ark.desktop
  '';
in
{
  xdg = {
    enable = true;
    mime.enable = true;
		desktopEntries.nvim-kitty = {
			name = "Neovim (Kitty)";
			genericName = "Code Editor";
			comment = "Edit code in Neovim inside Kitty";
			exec = "kitty --class nvim-kitty nvim %F";
			icon = "nvim";
			terminal = false;
			categories = [ "Development" "TextEditor" ];
			mimeType = codeMimeTypes;
			settings = {
				StartupNotify = "true";
			};
		};
  };

  # Seed defaults once. Keeping this file outside xdg.configFile makes it
  # writable, so KDE settings and `xdg-mime default ...` can update it.
  home.activation.seedMimeApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mimeapps=${lib.escapeShellArg "${config.xdg.configHome}/mimeapps.list"}
    if [[ ! -e "$mimeapps" ]]; then
      run ${pkgs.coreutils}/bin/install -Dm644 ${mimeApps} "$mimeapps"
    fi
  '';

	# Apply the new coding defaults once for existing installations. The marker
	# keeps later choices made in an application chooser from being overwritten.
	home.activation.seedCodingMimeDefaults = lib.hm.dag.entryAfter [ "seedMimeApps" ] ''
		marker=${lib.escapeShellArg "${config.xdg.configHome}/.nixos-coding-mime-defaults-v1"}
		if [[ ! -e "$marker" ]]; then
			${lib.concatMapStringsSep "\n" (mime: ''
				run ${pkgs.xdg-utils}/bin/xdg-mime default nvim-kitty.desktop ${lib.escapeShellArg mime}
			'') codeMimeTypes}
			run ${pkgs.coreutils}/bin/touch "$marker"
		fi
	'';

  home.packages = [ pkgs.xdg-utils ];
}
