{ config, pkgs, ... }:
{
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				after_sleep_cmd = "hyprctl dispatch dpms on";
				ignore_dbus_inhibit = false;
				ignore_wayland_inhibit = false;
				ignore_systemd_inhibit = false;
				lock_cmd = "pidof hyprlock || hyprlock";
			};

			listener = [
				{
					timeout = 240;          # 4 min — dim screen
					on-timeout = "playerctl -a status 2>/dev/null | grep -q Playing || brightnessctl -s set 10";
					on-resume = "brightnessctl -r";
				}
				{
					timeout = 300;          # 5 min — lock screen 1 min after display off
					on-timeout = "playerctl -a status 2>/dev/null | grep -q Playing || (pidof hyprlock || hyprlock)";
				}
				{
					timeout = 360;          # 6 min — turn off displays
					on-timeout = "playerctl -a status 2>/dev/null | grep -q Playing || hyprctl dispatch dpms off";
					on-resume = "hyprctl dispatch dpms on";
				}
				{
					timeout = 1800;         # 30 min — suspend
					on-timeout = "playerctl -a status 2>/dev/null | grep -q Playing || systemctl suspend";
				}
			];
		};
	};
}
