{ config, pkgs, ... }:
{
	systemd.user.services.polkit-gnome = {
		Unit = {
			Description = "Polkit GNOME Authentication Agent";
			After = [ "graphical-session.target" ];
		};
		Service = {
			Type = "simple";
			ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
			Restart = "on-failure";
		};
		Install = {
			WantedBy = [ "graphical-session.target" ];
		};
	};

	wayland.windowManager.hyprland.settings = {
		bind = [
			"SUPER, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
		];
	};
}
