{ config, pkgs, ... }:
{
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				after_sleep_cmd = "hyprctl dispatch dpms on";
				ignore_dbus_inhibit = false;
				lock_cmd = "pidof hyprlock || hyprlock";
			};

			listener = [
				{
					timeout = 180;          # 5 min — lock screen
					on-timeout = "pidof hyprlock || hyprlock";
				}
				{
					timeout = 360;          # 6 min — turn off displays
					on-timeout = "hyprctl dispatch dpms off";
					on-resume = "hyprctl dispatch dpms on";
				}
				{
					timeout = 1800;         # 30 min — suspend
					on-timeout = "systemctl suspend";
				}
			];
		};
	};
}
