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
		input = {
			kb_layout = "us,ir";
			kb_varaint = ",qwerty";
			repeat_delay = 300;

			# mouse_refocuse = false;
			float_switch_override_focus = false;

			touchpad = {
				natural_scroll = true;
			};
		};

		general = {
			layout = "scrolling";

			gaps_in = 4;
			gaps_out = 8;
			border_size = 2;

			
      "col.active_border" = "rgb(2bdfba) rgb(2bdfba) 45deg";
      "col.inactive_border" = "0x00000000";
		};

		misc = {
			# focus_on_active_window = true;
		};

		decoration = {
			rounding = 4;
			
      blur = {
        enabled = true;

        size = 3;
        noise = 0;
        passes = 2;
        contrast = 1.4;
        brightness = 1;

        xray = true;
      };

      shadow = {
        enabled = true;

        range = 20;
        render_power = 3;

        offset = "0 2";
        color = "rgba(00000055)";
      };
		};

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
			) 10))
			"$mod, S, togglespecialworkspace, scratchpad"
			"$mod SHIFT, S, movetoworkspace, special:scratchpad"

			"$mod, Tab, workspace, m+1"  # Next workspace
			"$mod SHIFT, Tab, workspace, m-1"  # Previous workspace

			"$mod, backslash, togglefloating,"
			"$mod, Return, exec, kitty"
			"$mod, Q, killactive,"
			"$mod, F, fullscreen,"

			"$mod, mouse:272, moveactive"
			"$mod, mouse:273, resizeactive"

			"SUPER, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
		];
	};
}
