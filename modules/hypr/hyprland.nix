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
			kb_options = "grp:alt_shift_toggle";
			# kb_varaint = ",qwerty";
			repeat_delay = 300;

			# mouse_refocuse = false;
			float_switch_override_focus = false;

			touchpad = {
				natural_scroll = true;
			};
		};

		monitor = [
			# name, resolution, position, scale
			# "eDP-1, 3840x2160@60, 0x0, 2"
			# 	"HDMI-A-1, 2560x1440@144, 0x0, 1.5"
			# Fallback for any other monitor
			# ", preferred, auto, 1.50"
		];

		# Recommended for fractional scaling
		xwayland = {
			force_zero_scaling = true;
		};

		exec-once = [
			"waybar"
			"hypridle"
			"hyprpaper"          # or swww for wallpapers
			"dunst"              # notifications
		];

		general = {
			layout = "dwindle";

			gaps_in = 4;
			gaps_out = 8;
			border_size = 2;

			
      "col.active_border" = "rgb(2bdfba) rgb(2bdfba) 45deg";
      "col.inactive_border" = "0x00000000";
		};
		dwindle = {
			pseudotile = true;
			preserve_split = true;
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

			active_opacity   = 1.0;
			inactive_opacity = 0.85;

      shadow = {
        enabled = true;

        range = 20;
        render_power = 3;

        offset = "0 2";
        color = "rgba(00000055)";
      };
		};

		"plugin:hyprscrolling" = {
			column_width = 0.5;
			fullscreen_on_one_column = true;
		};

		bind = [
			# Applications
			"$mod, SPACE, exec, wofi --show drun"
			"$mod, Return, exec, kitty"
			"$mod, E, exec, dolphin"

			# Movement
			"$mod, left, movefocus, l"
			"$mod, down, movefocus, d"
			"$mod, up, movefocus, u"
			"$mod, right, movefocus, r"
			"$mod, h, movefocus, l"
			"$mod, j, movefocus, d"
			"$mod, k, movefocus, u"
			"$mod, l, movefocus, r"

			"$mod, left, alterzorder, top"
			"$mod, down, alterzorder, top"
			"$mod, up, alterzorder, top"
			"$mod, right, alterzorder, top"
			"$mod, h, alterzorder, top"
			"$mod, j, alterzorder, top"
			"$mod, k, alterzorder, top"
			"$mod, l, alterzorder, top"

			"$mod SHIFT, left, movewindow, l"
      "$mod SHIFT, right, movewindow, r"
      "$mod SHIFT, up, movewindow, u"
      "$mod SHIFT, down, movewindow, d"
      "$mod SHIFT, h, movewindow, l"
      "$mod SHIFT, j, movewindow, d"
      "$mod SHIFT, k, movewindow, u"
      "$mod SHIFT, l, movewindow, r"

			# Workspace
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
			"$mod, F1, exec, hyprctl keyword general:layout dwindle"
			"$mod, F2, exec, hyprctl keyword general:layout master"
			"$mod, F3, exec, hyprctl keyword general:layout scrolling"

			"$mod, Tab, workspace, m+1"  # Next workspace
			"$mod SHIFT, Tab, workspace, m-1"  # Previous workspace

			"$mod, P, pseudo"
			"$mod, backslash, togglefloating,"

			"$mod, Q, killactive,"
			"$mod, F, fullscreen,"

			# Switch wallpapers
			"$mod SHIFT, W, exec, ~/.local/bin/hypr-wallpaper"

			"$mod CTRL SHIFT, S, exec, grim -g \"$(slurp)\" - | swappy -f -"

      "$mod, mouse_down, workspace, e-1"
      "$mod, mouse_up, workspace, e+1"

			# Brightness control
			", XF86MonBrightnessUp, exec, brightnessctl s +5%"
			", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

			# Volume control (using wpctl for PipeWire)
			", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
			", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

			# Keyboard
			# "$mod ALT k, exec, hyprctl switchxkblayout all next"

		];
		bindel = [
			## Media controls
			", XF86AudioPlay, exec, playerctl play-pause"
			", XF86AudioPrev, exec, playerctl previous"
			", XF86AudioNext, exec, playerctl next"

			# Mute toggle
			", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
		];

		bindm = [
			"$mod, mouse:273, resizewindow"
			"$mod, mouse:272, movewindow"
		];


		gestures = [
			"3, left, workspace, m+1"  # Next workspace
			"3, right, workspace, m-1"  # Previous workspace
		];
	};
}
