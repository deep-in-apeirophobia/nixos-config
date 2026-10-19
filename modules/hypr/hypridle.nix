{ config, pkgs, lib, ... }:
let
	# Idle timeouts in seconds. The waybar indicator shows these too.
	dimAfter = 240;
	lockAfter = 300;
	screenOffAfter = 360;
	suspendAfter = 1800;

	minutes = s: "${toString (s / 60)}m";
	dpms = action: "hyprctl dispatch 'hl.dsp.dpms({ action = \"${action}\" })'";

	# Answers "what is keeping this machine awake?" for hypridle and waybar.
	# hypridle already pauses every listener on its own for Wayland, D-Bus and
	# systemd *idle* inhibitors; this covers what it can't see: media playback,
	# running T3 Code tasks and systemd *sleep* inhibitors.
	hyprPower = pkgs.writeShellApplication {
		name = "hypr-power";
		runtimeInputs = with pkgs; [ gawk gnugrep jq sqlite systemd playerctl hyprland ];
		text = ''
			t3_dir="$HOME/.t3/userdata"
			idle_actions="dim ${minutes dimAfter} · lock ${minutes lockAfter} · screen off ${minutes screenOffAfter}"

			# Number of running T3 Code tasks. T3 Code takes no sleep inhibitor of
			# its own, so read its state DB. Rows left behind by a dead server, or
			# older than a day, are ignored so a stale "running" row can't keep the
			# laptop up forever. Prints "?" if the DB can't be read (e.g. a schema
			# change in a newer nightly).
			t3_running() {
				local pid
				pid=$(jq -r '.pid // empty' "$t3_dir/server-runtime.json" 2>/dev/null) || pid=""
				if [[ -z $pid ]] || ! kill -0 "$pid" 2>/dev/null; then
					echo 0
					return
				fi
				sqlite3 -readonly -cmd '.timeout 2000' "file:$t3_dir/statev2.sqlite?mode=ro" "
					SELECT count(*) FROM orchestration_v2_projection_runs
					WHERE status IN ('preparing', 'starting', 'running')
						AND requested_at > strftime('%Y-%m-%dT%H:%M:%fZ', 'now', '-1 day');
				" 2>/dev/null || echo "?"
			}

			# Names of players that are currently playing.
			playing() {
				playerctl -a status --format '{{playerName}} {{status}}' 2>/dev/null |
					awk '$2 == "Playing" { print $1 }' || true
			}

			# Blocking logind inhibitors, as "what<TAB>who<TAB>why".
			inhibitors() {
				busctl --json=short call org.freedesktop.login1 /org/freedesktop/login1 \
					org.freedesktop.login1.Manager ListInhibitors 2>/dev/null |
					jq -r '.data[0][] | select(.[3] == "block") | [.[0], .[1], .[2]] | @tsv' || true
			}

			# Windows holding a Wayland idle inhibitor.
			wayland_inhibitors() {
				hyprctl clients -j 2>/dev/null | jq -r '.[] | select(.inhibitingIdle) | .class' || true
			}

			# hypridle's inhibit count: one per D-Bus screensaver inhibitor (browsers,
			# vlc, ...) plus one if any systemd idle inhibitor exists. Only hypridle
			# knows about the D-Bus ones, and it logs the running total.
			hypridle_locks() {
				local id
				id=$(systemctl --user show -p InvocationID --value hypridle.service 2>/dev/null) || id=""
				if [[ -z $id ]]; then
					echo 0
					return
				fi
				journalctl --user "_SYSTEMD_INVOCATION_ID=$id" -o cat --no-pager -r -n 1 \
					-g '^\[LOG\] Inhibit locks: ' 2>/dev/null | grep -o '[0-9]*$' || echo 0
			}

			waybar_status() {
				local -a awake=() nosleep=() notes=()
				local line what who why t3 dbus systemd_idle=0 alt tooltip

				while IFS= read -r line; do
					awake+=("$line (Wayland inhibitor)")
				done < <(wayland_inhibitors)
				while IFS= read -r line; do
					awake+=("$line is playing")
				done < <(playing)
				while IFS=$'\t' read -r what who why; do
					if [[ $what == *idle* ]]; then
						awake+=("$who: $why")
						systemd_idle=1
					elif [[ $what == *sleep* ]]; then
						nosleep+=("$who: $why")
					fi
				done < <(inhibitors)
				dbus=$(( $(hypridle_locks) - systemd_idle ))
				if (( dbus > 0 )); then
					awake+=("$dbus app(s) via D-Bus screensaver inhibit")
				fi

				t3=$(t3_running)
				if [[ $t3 == "?" ]]; then
					notes+=("Couldn't read T3 Code's task state; not holding off suspend for it")
				elif (( t3 > 0 )); then
					nosleep+=("T3 Code: $t3 task(s) running")
				fi

				if (( ''${#awake[@]} > 0 )); then
					alt=awake
					tooltip="Screen stays on: no dim, lock, screen off or suspend"
					tooltip+=$(printf '\n • %s' "''${awake[@]}")
					if (( ''${#nosleep[@]} > 0 )); then
						tooltip+=$'\n'"Also holding off suspend:"
						tooltip+=$(printf '\n • %s' "''${nosleep[@]}")
					fi
				elif (( ''${#nosleep[@]} > 0 )); then
					alt=nosleep
					tooltip="Won't suspend"
					tooltip+=$(printf '\n • %s' "''${nosleep[@]}")
					tooltip+=$'\n'"Still on idle: $idle_actions"
				else
					alt=normal
					tooltip="On idle: $idle_actions · suspend ${minutes suspendAfter}"
				fi
				tooltip+=$'\n'"Lid: suspend + lock (laptop panel off when docked)"
				if (( ''${#notes[@]} > 0 )); then
					tooltip+=$(printf '\n⚠ %s' "''${notes[@]}")
				fi

				jq -cn --arg alt "$alt" --arg tooltip "$tooltip" '{
					text: $alt,
					alt: $alt,
					class: $alt,
					tooltip: ($tooltip | gsub("&"; "&amp;") | gsub("<"; "&lt;") | gsub(">"; "&gt;"))
				}'
			}

			case "''${1:-}" in
				# Dim, lock and screen-off wait while media plays.
				can-idle)
					[[ -z $(playing) ]]
					;;
				# Idle suspend also waits for T3 Code tasks and sleep inhibitors.
				can-sleep)
					t3=$(t3_running)
					sleep_inhibitors=$(inhibitors | awk -F '\t' '$1 ~ /sleep/')
					[[ -z $(playing) && -z $sleep_inhibitors && ($t3 == 0 || $t3 == "?") ]]
					;;
				waybar)
					waybar_status
					;;
				*)
					echo "usage: hypr-power can-idle|can-sleep|waybar" >&2
					exit 2
					;;
			esac
		'';
	};
	canIdle = "${lib.getExe hyprPower} can-idle";
in
{
	home.packages = [ hyprPower ];

	services.hypridle = {
		enable = true;
		settings = {
			general = {
				# Every lock (keybind, idle and sleep) goes through
				# `loginctl lock-session`, so hyprlock is only named here.
				# --no-fade-in: on resume the lock screen is already opaque.
				lock_cmd = "pidof hyprlock || hyprlock --no-fade-in";
				# logind emits PrepareForSleep for every route into sleep, lid
				# close included. Since lock_cmd runs hyprlock, hypridle holds off
				# the sleep until the lock screen is actually up.
				before_sleep_cmd = "loginctl lock-session";
				after_sleep_cmd = dpms "enable";
				ignore_dbus_inhibit = false;
				ignore_wayland_inhibit = false;
				ignore_systemd_inhibit = false;
			};

			# A listener whose condition_cmd fails keeps re-checking every
			# condition_retry seconds and fires once it passes, as long as the
			# machine is still idle.
			listener = [
				{
					timeout = dimAfter;
					condition_cmd = canIdle;
					condition_retry = 30;
					on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10%";
					on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
				}
				{
					timeout = lockAfter;
					condition_cmd = canIdle;
					condition_retry = 30;
					on-timeout = "loginctl lock-session";
				}
				{
					timeout = screenOffAfter;
					condition_cmd = canIdle;
					condition_retry = 30;
					on-timeout = dpms "disable";
					on-resume = dpms "enable";
				}
				{
					# Running T3 Code tasks hold this one off; lock and screen-off
					# above still happen.
					timeout = suspendAfter;
					condition_cmd = "${lib.getExe hyprPower} can-sleep";
					condition_retry = 60;
					on-timeout = "systemctl suspend";
				}
			];
		};
	};

	# Idle/sleep indicator. It's listed and styled in waybar.nix.
	programs.waybar.settings.mainBar."custom/idle" = {
		exec = "${lib.getExe hyprPower} waybar";
		return-type = "json";
		interval = 5;
		format = "{icon}";
		format-icons = {
			normal = "󰒲";
			nosleep = "󰒳";
			awake = "󰅶";
		};
	};
}
