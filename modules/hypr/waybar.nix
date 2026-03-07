{ config, pkgs, ... }:
{
	programs.waybar = {
		enable = true;
		settings = {
			mainBar = {
				# layer = "overlay";
				# exclusive = false;
				layer = "top";
				position = "top";
				height = 24;
				spacing = 4;

				modules-left = [ "hyprland/workspaces" ];
				modules-center = [ "clock" ];
				modules-right = [
					"keyboard-state"
					"pulseaudio"
					"backlight" 
					"network"
					"cpu"
					"memory"
					"tray"
					"battery"
				];

				"hyprland/workspaces" = {
					disable-scroll = true;
					all-outputs = true;
					format = "{icon}";
					format-icons = {
						"1" = "";
						"2" = "";
						"3" = "";
						"7" = "󰐊";
					};
				};

				# "hyprland/window" = {
				# 	max-length = 60;
				# };

				keyboard-state = {
					numlock = true;
					capslock = true;
					format = "{name} {icon}";
					format-icons = {
						locked = "";
						unlocked = "";
					};
				};

				clock = {
					format = "{:%H:%M}";
					format-alt = " {:%A, %B %d, %Y}";
					tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
				};

				backlight = {
					scroll-step = 5;
					format = "{percent}% {icon}";
					format-icons = ["" "" "" "" "" "" ""
						"" ""];
				};
				cpu = {
					format = "{icon}";
					format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
					interval = 2;
				};

				memory = {
					format = "{}% 󰍛";
					interval = 2;
				};

				battery = {
					states = {
						warning = 50;
						critical = 20;
					};
					format = "{capacity}% {icon}";
					format-charging = "{capacity}% 󰂄";
					format-plugged = "";
					format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󱊣"];
				};

				network = {
					format-wifi = "󰖩 {signalStrength}%";
					format-ethernet = "󰛳 {ipaddr}";
					format-disconnected = "󰌙 Disconnected";
					tooltip-format = "{essid} ({signalStrength}%) via {gwaddr}";
				};

				pulseaudio = {
					scroll-step = 1;
					format = "{volume}% {icon}";
					format-bluetooth = "{volume}% {icon} {format_source}";
					format-bluetooth-muted = " {icon} {format_source}";
					format-muted = " {format_source}";
					format-icons = {
						headphone = "󰋋";
						hands-free = "󱡏";
						headset = "󰋎";
						phone = "";
						portable = "";
						car = "";
						speaker = "󰓃";
						default = ["" "" ""];
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
    font-family: FiraCode , Noto Sans,FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 13px;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#custom-expand,
#custom-cycle_wall,
#custom-ss,
#custom-dynamic_pill,
#mpd {
    padding: 0 10px;
    border-radius: 15px;
    background: #11111b;
    color: #b4befe;
    box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
    margin-top: 4px;
    margin-bottom: 4px;
    margin-right: 10px;
}

window#waybar {
    background-color: transparent;
		/* margin-top: -24px;
		transition: margin-top 0.3s cubic-bezier(0.16, 1, 0.3, 1); */
}
/*
window#waybar:hover {
	margin-top: 0;
}
*/

#custom-dynamic_pill label {
    color: #11111b;
    font-weight: bold;
}

#custom-dynamic_pill.paused label {
    color: 	#89b4fa ;
    font-weight: bolder; 
}

#workspaces button label{
    color: 	#89b4fa ;
    font-weight: bolder;
}

#workspaces button.active label{
    font-weight: bolder;
}

#workspaces{
    background-color: transparent;
    margin-right: 10px;
    margin-left: 25px;
}
#workspaces button{
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
		/* backdrop-filter: blur(6px); */
    background: rgba(17, 17, 27, 0.36);
    border-radius: 15px;
    margin-right: 10px;
    padding: 10px;
    padding-top: 4px;
    padding-bottom: 2px;
    font-weight: bolder;
    color: 	#89b4fa ;
    transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
}

#workspaces button.active{
		background: rgba(0, 145, 205, 0.34);
}

@keyframes gradient {
	0% {
		background-position: 0% 50%;
	}
	50% {
		background-position: 100% 30%;
	}
	100% {
		background-position: 0% 50%;
	}
}

@keyframes gradient_f {
	0% {
		background-position: 0% 200%;
	}
    50% {
        background-position: 200% 0%;
    }
	100% {
		background-position: 400% 200%;
	}
}

@keyframes gradient_f_nh {
	0% {
		background-position: 0% 200%;
	}
	100% {
		background-position: 200% 200%;
	}
}



#custom-dynamic_pill.low{
    background: rgb(148,226,213);
    background: linear-gradient(52deg, rgba(148,226,213,1) 0%, rgba(137,220,235,1) 19%, rgba(116,199,236,1) 43%, rgba(137,180,250,1) 56%, rgba(180,190,254,1) 80%, rgba(186,187,241,1) 100%); 
    background-size: 300% 300%;
    text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
    animation: gradient 15s ease infinite;
    font-weight: bolder;
    color: #fff;
}
#custom-dynamic_pill.normal{
    background: rgb(148,226,213);
    background: radial-gradient(circle, rgba(148,226,213,1) 0%, rgba(156,227,191,1) 21%, rgba(249,226,175,1) 34%, rgba(158,227,186,1) 35%, rgba(163,227,169,1) 59%, rgba(148,226,213,1) 74%, rgba(164,227,167,1) 74%, rgba(166,227,161,1) 100%); 
    background-size: 400% 400%;
    animation: gradient_f 4s ease infinite;
    text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
    font-weight: bolder;
    color: #fff;
}
#custom-dynamic_pill.critical{
    background: rgb(235,160,172);
    background: linear-gradient(52deg, rgba(235,160,172,1) 0%, rgba(243,139,168,1) 30%, rgba(231,130,132,1) 48%, rgba(250,179,135,1) 77%, rgba(249,226,175,1) 100%); 
    background-size: 300% 300%;
    animation: gradient 15s cubic-bezier(.55,-0.68,.48,1.68) infinite;
    text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
    font-weight: bolder;
    color: #fff;
}

#custom-dynamic_pill.playing{
    background: rgb(137,180,250);
    background: radial-gradient(circle, rgba(137,180,250,120) 0%, rgba(142,179,250,120) 6%, rgba(148,226,213,1) 14%, rgba(147,178,250,1) 14%, rgba(155,176,249,1) 18%, rgba(245,194,231,1) 28%, rgba(158,175,249,1) 28%, rgba(181,170,248,1) 58%, rgba(205,214,244,1) 69%, rgba(186,169,248,1) 69%, rgba(195,167,247,1) 72%, rgba(137,220,235,1) 73%, rgba(198,167,247,1) 78%, rgba(203,166,247,1) 100%); 
    background-size: 400% 400%;
    animation: gradient_f 9s cubic-bezier(.72,.39,.21,1) infinite;
    text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
    font-weight: bold;
    color: #fff ;
}

#custom-dynamic_pill.paused{
    background: #11111b ;
    font-weight: bolder;
    color: #b4befe;
}

#custom-ss{
    background: #11111b;
    color: #89b4fa;
    font-weight:  bolder;
    padding: 5px;
    padding-left: 20px;
    padding-right: 20px;
    border-radius: 15px;
}


#custom-cycle_wall{
    background: rgb(245,194,231);
    background: linear-gradient(45deg, rgba(245,194,231,1) 0%, rgba(203,166,247,1) 0%, rgba(243,139,168,1) 13%, rgba(235,160,172,1) 26%, rgba(250,179,135,1) 34%, rgba(249,226,175,1) 49%, rgba(166,227,161,1) 65%, rgba(148,226,213,1) 77%, rgba(137,220,235,1) 82%, rgba(116,199,236,1) 88%, rgba(137,180,250,1) 95%); 
    color: #fff;
    background-size: 500% 500%;
    animation: gradient 7s linear infinite;
    font-weight:  bolder;
    border-radius: 15px;
}

#clock label{
    color: #11111b;
    font-weight:  bolder;
}

#clock {
    background-color: #11111b;

    margin-right: 25px;
    color: #e8f3f1 ;
    text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
    
    font-size: 15px;
    padding-top: 5px;
    padding-left: 10px;
    padding-right: 10px;
    padding-bottom: 5px;
    font-weight: bolder;
}

#battery.charging, #battery.plugged {
		color: #2bdfba;
}

#battery {
    background-color: #2f4858;
    color:#c7fcec;
    font-weight: bolder;
    font-size: 20px;
    padding-left: 15px;
    padding-right: 15px;
}

@keyframes blink {
    to {
        background-color: #f9e2af;
        color:#96804e;
    }
}



#battery.critical:not(.charging) {
    background-color:  #f38ba8;
    color:#bf5673;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#cpu label{
    color:#89dceb;
}

#cpu {
    background: rgb(30,30,46);
    background: radial-gradient(circle, rgba(30,30,46,1) 30%, rgba(17,17,27,1) 100%); 
    color: 	#89b4fa;
}

#memory {
    background-color: #11111b;
    color: 	#9a75c7;
    font-weight: bolder;
}

#disk {
    color: #964B00;
}

#backlight {
    color: #90b1b1;
}

#network{
    color:#000;
}

#network.disabled{
    background-color: #45475a;
}

#network.disconnected{
    background: rgb(243,139,168);
    background: linear-gradient(45deg, rgba(243,139,168,1) 0%, rgba(250,179,135,1) 100%); 
    color: #e8f3f1;
    font-weight: bolder;
    padding-top: 3px;
    padding-right: 11px;
}

#network.linked, #network.wifi{
    background-color: #a6e3a1 ;
}

#network.ethernet{
    background-color:#f9e2af ;
}

#pulseaudio {
    background-color:	#5f788a ;
    color: #e8f3f1;
    font-weight: bolder;
}

#pulseaudio.muted {
    background-color: #90b1b1;
}

#custom-media {
    color: #66cc99;
}

#custom-media.custom-spotify {
    background-color: #66cc99;
}

#custom-media.custom-vlc {
    background-color: #ffa000;
}

#temperature {
    background-color: #f9e2af;
    color:#96804e;
}

#temperature.critical {
    background-color: #f38ba8 ;
    color:#bf5673;
}

#tray {
    background-color: #2980b9;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
}		'';
	};
}
