{ config, pkgs, ... }:
{
	programs.waybar = {
		enable = true;
		settings = {
			mainBar = {
				layer = "top";
				position = "top";
				height = 32;
				spacing = 4;

				modules-left = [ "hyprland/workspaces" "hyprland/window" ];
				modules-center = [ "clock" ];
				modules-right = [
					"pulseaudio"
					"network"
					"cpu"
					"memory"
					"battery"
					"tray"
				];

				"hyprland/workspaces" = {
					disable-scroll = true;
					all-outputs = true;
					format = "{icon}";
					format-icons = {
						"1" = "";
						"2" = "";
						"3" = "";
						default = "";
						urgent = "";
						active = "";
					};
				};

				"hyprland/window" = {
					max-length = 60;
				};

				clock = {
					format = " {:%H:%M}";
					format-alt = " {:%A, %B %d, %Y}";
					tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
				};

				cpu = {
					format = " {usage}%";
					tooltip = false;
					interval = 2;
				};

				memory = {
					format = " {}%";
					interval = 2;
				};

				battery = {
					states = {
						warning = 30;
						critical = 15;
					};
					format = "{icon} {capacity}%";
					format-charging = " {capacity}%";
					format-plugged = " {capacity}%";
					format-icons = [ "" "" "" "" "" ];
				};

				network = {
					format-wifi = " {signalStrength}%";
					format-ethernet = " {ipaddr}";
					format-disconnected = "⚠ Disconnected";
					tooltip-format = "{essid} ({signalStrength}%) via {gwaddr}";
				};

				pulseaudio = {
					format = "{icon} {volume}%";
					format-muted = " Muted";
					format-icons = {
						default = [ "" "" "" ];
					};
					on-click = "pavucontrol";
				};

				tray = {
					spacing = 8;
				};
			};
		};

		style = ''
			* {
				font-family: "JetBrainsMono Nerd Font", monospace;
				font-size: 13px;
				border: none;
				border-radius: 0;
				min-height: 0;
			}

			window#waybar {
				background-color: rgba(26, 27, 38, 0.95);
				color: #cdd6f4;

				/* Hide all but ~4px at the top edge — enough to act as a hover target */
				margin-top: -28px;
				transition: margin-top 0.3s cubic-bezier(0.16, 1, 0.3, 1);
			}

			window#waybar:hover {
				margin-top: 0;
			}

			#workspaces button {
				padding: 0 8px;
				color: #7f849c;
			}

			#workspaces button.active {
				color: #cba6f7;
				border-bottom: 2px solid #cba6f7;
			}

			#workspaces button.urgent {
				color: #f38ba8;
			}

			#clock,
			#battery,
			#cpu,
			#memory,
			#network,
			#pulseaudio,
			#tray {
				padding: 0 10px;
				color: #cdd6f4;
			}

			#battery.warning { color: #fab387; }
			#battery.critical { color: #f38ba8; }
		'';
	};
}
