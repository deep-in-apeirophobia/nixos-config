{ config, pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      # hyprlock 0.9 dropped disable_loading_bar, grace and no_fade_in; grace
      # now defaults to 0 and fade-in is turned off via `--no-fade-in`
      # (see lock_cmd in hypridle.nix).
      general = {
        hide_cursor = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "300, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 2;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 3;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$USER";
          color = "rgb(202, 211, 245)";
          font_size = 25;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -140";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$TIME";
          color = "rgb(202, 211, 245)";
          font_size = 55;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
