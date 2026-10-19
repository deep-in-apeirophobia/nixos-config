{ config, pkgs, ... }:
let
	cursor = config.home.pointerCursor;
	brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
	wpctl = "${pkgs.wireplumber}/bin/wpctl";
	playerctl = "${pkgs.playerctl}/bin/playerctl";
in
{
	# Hyprland's Lua config (hyprland.lua). Option tables are Nix below and get
	# rendered as hl.config()/hl.monitor() calls; binds and startup are plain
	# Lua in extraConfig. Under Lua, `hyprctl dispatch` takes hl.dsp.* calls
	# and `hyprctl keyword` no longer exists.
	wayland.windowManager.hyprland.configType = "lua";
	wayland.windowManager.hyprland.settings = {
		monitor = [
			# The laptop panel gets its own rule so the lid handlers in
			# extraConfig can switch just it off and on.
			{ output = "eDP-1"; mode = "preferred"; position = "auto"; scale = "1.33"; }
			# Fallback for any other monitor
			{ output = ""; mode = "preferred"; position = "auto"; scale = "1.33"; }
		];

		config = {
			input = {
				kb_layout = "us,ir";
				kb_options = "grp:alt_shift_toggle";
				repeat_delay = 300;

				float_switch_override_focus = false;

				touchpad = {
					natural_scroll = true;
				};
			};

			# Recommended for fractional scaling
			xwayland = {
				force_zero_scaling = true;
			};

			general = {
				layout = "dwindle";

				gaps_in = 4;
				gaps_out = 8;
				border_size = 2;

				col = {
					active_border = { colors = [ "rgb(2bdfba)" "rgb(2bdfba)" ]; angle = 45; };
					inactive_border = "rgba(00000000)";
				};

				# Drag a window's edge to resize it, easier on a touchpad than
				# SUPER + right-drag.
				resize_on_border = true;
			};
			dwindle = {
				preserve_split = true;
			};
			scrolling = {
				column_width = 0.5;
				fullscreen_on_one_column = true;
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

				active_opacity = 1.0;
				inactive_opacity = 0.85;

				shadow = {
					enabled = true;

					range = 20;
					render_power = 3;

					offset = "0 2";
					color = "rgba(00000055)";
				};
			};

			misc = {
				# hyprpaper draws the wallpaper; never show Hyprland's own
				# wallpaper, logo or splash text, not even while it starts.
				force_default_wallpaper = 0;
				disable_hyprland_logo = true;
				disable_splash_rendering = true;
			};
		};
	};

	wayland.windowManager.hyprland.extraConfig = ''
		hl.env("XCURSOR_THEME", "${cursor.name}")
		hl.env("XCURSOR_SIZE", "${toString cursor.size}")

		-- hypridle and hyprpaper run as systemd user services.
		hl.on("hyprland.start", function()
			hl.exec_cmd("waybar")
			hl.exec_cmd("dunst") -- notifications
		end)

		local mod = "SUPER"

		-- Applications
		hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
		hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
		hl.bind(mod .. " + E", hl.dsp.exec_cmd("dolphin"))
		hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("nwg-displays"))

		-- Arrows or vim keys:
		--   SUPER          focus, raising floating windows to the top
		--   SUPER + SHIFT  move the window in the layout
		--   SUPER + CTRL   resize (grows/shrinks from the bottom-right corner)
		--   SUPER + ALT    move a floating window
		local directions = {
			left = "left", down = "down", up = "up", right = "right",
			h = "left", j = "down", k = "up", l = "right",
		}
		local steps = { left = { -40, 0 }, down = { 0, 40 }, up = { 0, -40 }, right = { 40, 0 } }
		for key, dir in pairs(directions) do
			local x, y = steps[dir][1], steps[dir][2]
			hl.bind(mod .. " + " .. key, function()
				hl.dispatch(hl.dsp.focus({ direction = dir }))
				hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
			end)
			hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
			hl.bind(mod .. " + CTRL + " .. key, hl.dsp.window.resize({ x = x, y = y, relative = true }), { repeating = true })
			hl.bind(mod .. " + ALT + " .. key, hl.dsp.window.move({ x = x, y = y, relative = true }), { repeating = true })
		end

		-- Mouse: SUPER + left-drag moves, SUPER + right-drag resizes. On a
		-- touchpad SUPER + CTRL + click-drag resizes too.
		hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
		hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
		hl.bind(mod .. " + CTRL + mouse:272", hl.dsp.window.resize(), { mouse = true })

		-- Workspaces
		for i = 1, 10 do
			local key = i % 10 -- workspace 10 is on the 0 key
			hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
			hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
			hl.bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
		end
		hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
		hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))
		hl.bind(mod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }))
		hl.bind(mod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))
		hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
		hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

		-- Layouts
		for key, layout in pairs({ F1 = "dwindle", F2 = "master", F3 = "scrolling" }) do
			hl.bind(mod .. " + " .. key, function()
				hl.config({ general = { layout = layout } })
			end)
		end

		-- Windows
		hl.bind(mod .. " + P", hl.dsp.window.pseudo())
		hl.bind(mod .. " + backslash", hl.dsp.window.float())
		hl.bind(mod .. " + Q", hl.dsp.window.close())
		hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
		hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

		-- Color picker
		hl.bind(mod .. " + ALT + C", hl.dsp.exec_cmd("hyprpicker -a"))
		hl.bind(mod .. " + SHIFT + ALT + C", hl.dsp.exec_cmd("hyprpicker -a --format=rgb"))

		-- Wallpaper: pick one with wofi, or a random one
		hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.local/bin/hypr-wallpaper-wofi"))
		hl.bind(mod .. " + ALT + W", hl.dsp.exec_cmd("~/.local/bin/hypr-wallpaper"))

		-- Screenshot a region
		hl.bind(mod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

		-- Clipboard
		hl.bind(mod .. " + C", hl.dsp.exec_cmd("wl-copy"))
		hl.bind(mod .. " + V", hl.dsp.exec_cmd("wl-paste"))

		-- Lock screen. Goes through logind so hypridle's lock_cmd is the one
		-- place that starts hyprlock, same as idle and lid-close locking.
		hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("loginctl lock-session"))
		hl.bind(mod .. " + SHIFT + Escape", hl.dsp.exec_cmd("loginctl lock-session"))

		-- Brightness, volume and media keys, also on the lock screen
		hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${brightnessctl} set +5%"), { locked = true, repeating = true })
		hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${brightnessctl} set 5%-"), { locked = true, repeating = true })
		hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
		hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
		hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
		hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${playerctl} play-pause"), { locked = true })
		hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${playerctl} previous"), { locked = true })
		hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${playerctl} next"), { locked = true })

		-- Clamshell: with an external monitor attached logind leaves the lid
		-- alone (HandleLidSwitchDocked = ignore), so turn the laptop panel off
		-- here. Without one, logind suspends and hypridle locks first.
		hl.bind("switch:on:Lid Switch", function()
			if #hl.get_monitors() > 1 then
				hl.monitor({ output = "eDP-1", disabled = true })
			end
		end, { locked = true })
		hl.bind("switch:off:Lid Switch", function()
			hl.monitor({ output = "eDP-1", disabled = false })
		end, { locked = true })

		-- Touchpad gestures, e.g.:
		-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
	'';
}
