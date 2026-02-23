{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		audacity
		musescore
		# muse-sounds-manager
	];

	programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
