{ config, pkgs, inputs, ... }:
let
  sessionizer = pkgs.writeShellScript "sessionizer.sh" ''
    selected=$(
			${pkgs.findutils}/bin/find \
				"$HOME/Developer" "$HOME/Documents" \
				-type d \
				\( \
					-path '*/node_modules/*' -o \
					-path '*/node_modules/' -o \
					-path '*/.venv/*' -o \
					-path '*/venv/*' -o \
					-path '*/.direnv/*' -o \
					-path '*/dist/*' -o \
					-path '*/build/*' -o \
					-path '*/target/*' -o \
					-path '*/.next/*' -o \
					-path '*/.cache/*' -o \
					-path '*/.git/*' \
				\) -prune -o -name .git \
				-print 2>/dev/null \
			| ${pkgs.gnugrep}/bin/grep -v "Permission denied" \
			| ${pkgs.gnused}/bin/sed 's/\/\.git$//' \
			| ${pkgs.fzf}/bin/fzf
		)

    if [[ -z "$selected" ]]; then
        exit 0
    fi

    selected_name=$(${pkgs.coreutils}/bin/basename "$selected" | tr . _)

    if ! ${pkgs.tmux}/bin/tmux has-session -t="$selected_name" 2>/dev/null; then
        ${pkgs.tmux}/bin/tmux new-session -ds "$selected_name" -c "$selected"
    fi

    ${pkgs.tmux}/bin/tmux switch-client -t "$selected_name"
  '';

  configSessionizer = pkgs.writeShellScript "config-sessionizer.sh" ''
    selected=$(${pkgs.findutils}/bin/find ~/dotfiles -mindepth 1 -maxdepth 1 -type d | ${pkgs.fzf}/bin/fzf)

    if [[ -z "$selected" ]]; then
        exit 0
    fi

    selected_name=$(${pkgs.coreutils}/bin/basename "$selected" | tr . _)

    if ! ${pkgs.tmux}/bin/tmux has-session -t="$selected_name" 2>/dev/null; then
        ${pkgs.tmux}/bin/tmux new-session -ds "$selected_name" -c "$selected"
    fi

    ${pkgs.tmux}/bin/tmux switch-client -t "$selected_name"
  '';

  windowSelector = pkgs.writeShellScript "window-selector.sh" ''
    selected=$(${pkgs.tmux}/bin/tmux list-windows -F '#I: #W' | ${pkgs.fzf}/bin/fzf)

    if [[ -z "$selected" ]]; then
        exit 0
    fi

    window_id=$(echo "$selected" | cut -d: -f1)
    ${pkgs.tmux}/bin/tmux select-window -t "$window_id"
  '';

  activeSessions = pkgs.writeShellScript "active-sessions.sh" ''
    selected=$(${pkgs.tmux}/bin/tmux list-sessions -F '#S' | ${pkgs.fzf}/bin/fzf)

    if [[ -z "$selected" ]]; then
        exit 0
    fi

    ${pkgs.tmux}/bin/tmux switch-client -t "$selected"
  '';
in
{
	programs.tmux = {
		enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";

		extraConfig = ''
			unbind C-b
      bind-key C-a send-prefix

      set -g visual-activity off
      set -g visual-bell off
      set -g visual-silence off
      setw -g monitor-activity off
      set -g bell-action none

      set -g status-keys vi
      setw -g clock-mode-colour colour1

      set-window-option -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane

      bind-key -T prefix r source-file ~/.config/tmux/tmux.conf

      unbind-key l
      bind-key -T prefix l select-pane -L
      bind-key -T prefix h select-pane -R
      bind-key -T prefix k select-pane -U
      bind-key -T prefix j select-pane -D

      # Scripts reference Nix store paths directly
      bind-key -T prefix w run-shell "tmux neww -n fzf-selector ${windowSelector}"
      bind-key -T prefix g run-shell "tmux neww -n fzf-selector ${sessionizer}"
      bind-key -T prefix C-c run-shell "tmux neww -n fzf-selector ${configSessionizer}"
      bind-key -T prefix a run-shell "tmux neww -n fzf-selector ${activeSessions}"

      bind-key -T prefix M-x kill-session

      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
      set -g @resurrect-strategy-nvim 'session'
		'';

		plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      continuum
      yank
			tmux-powerline
      { plugin = catppuccin; extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_session}"
        ''; }
    ];
	};

	# xdg.configFile."tmux" = {
	# 	source = inputs.tmux-config;
	# 	recursive = true;
	# };
	#
	# xdg.configFile."tmux/.tmux.conf".source = "${inputs.tmux-config}/.tmux.conf";
}
