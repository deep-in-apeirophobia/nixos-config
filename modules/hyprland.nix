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
		"$mod" = "SUPER";
		bind = [
			"$mod, SPACE, exec, wofi --show drun"

			"$mod, h, movefocus, l"
			"$mod, j, movefocus, d"
			"$mod, k, movefocus, u"
			"$mod, l, movefocus, r"

			(builtins.concatLists (builtins.genList (x: 
				let 
					ws = builtins.toString (x + 1);
					key = if x == 9 then "0" else builtins.toString (x + 1);
				in [
					"$mod, ${key}, workspace, ${ws}"
					"$mod SHIFT, ${key}, movetoworkspace, ${ws}"
					"$mod CTRL, ${key}, movetoworkspacesilent, ${ws}"
				]
			) 10));
			"$mod, S, togglespecialworkspace, scratchpad"
			"$mod SHIFT, S, movetoworkspace, special:scratchpad"

			"$mod, Tab, workspace, m+1"  # Next workspace
			"$mod SHIFT, Tab, workspace, m-1"  # Previous workspace

			"$mod, backslash, togglefloating,"
			"$mod, Return, exec, kitty"
			"$mod, Q, killactive,"
			"$mod, F, fullscreen,"


			"SUPER, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
		];
	};
}
