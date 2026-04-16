{ config, pkgs, ... }:
let
  wallpaperPickerScript = pkgs.writeShellScript "hypr-wallpaper-wofi" ''
    WALLPAPER_DIR="$HOME/wallpapers"

    # Find all wallpapers
    mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \
      \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | sort)

    if [[ ''${#wallpapers[@]} -eq 0 ]]; then
      echo "No wallpapers found in $WALLPAPER_DIR" >&2
      exit 1
    fi

    # Create a temp file with formatted entries
    TEMP_FILE=$(mktemp)
    for file in "''${wallpapers[@]}"; do
      filename=$(basename "$file")
      # Output format: filename<NULL>icon<RS>/path/to/file<newline>
      printf "%s\x00icon\x1f%s\n" "$filename" "$file" >> "$TEMP_FILE"
    done

    # Launch wofi with image support
    selected=$(cat "$TEMP_FILE" | ${pkgs.wofi}/bin/wofi \
      --dmenu \
      --conf /dev/null \
      --style ~/.config/wofi/wallpaper.css \
      --prompt "Select wallpaper..." \
      --insensitive \
      --show-icons \
      --allow-images \
      --cache-file /dev/null \
      --height 700 \
      --width 900 \
      --location center \
      --columns 3)

    rm -f "$TEMP_FILE"

    if [[ -n "$selected" ]]; then
      # Find the full path from the filename
      img=""
      for file in "''${wallpapers[@]}"; do
        if [[ "$(basename "$file")" == "$selected" ]]; then
          img="$file"
          break
        fi
      done
      
      if [[ -n "$img" && -f "$img" ]]; then
        # Set wallpaper using hyprpaper
        ${pkgs.hyprpaper}/bin/hyprctl hyprpaper preload "$img"
        ${pkgs.hyprpaper}/bin/hyprctl hyprpaper wallpaper ",$img"
        ${pkgs.hyprpaper}/bin/hyprctl hyprpaper unload unused
      fi
    fi
  '';
in
{
  # Wofi configuration for wallpaper picker with image preview
  xdg.configFile."wofi/wallpaper.css".text = ''
    window {
      margin: 20px;
      border: 2px solid #2bdfba;
      background-color: #1e1e2e;
      border-radius: 15px;
    }

    #input {
      margin: 10px;
      border: none;
      color: #cdd6f4;
      background-color: #313244;
      padding: 12px;
      border-radius: 8px;
      font-size: 14px;
    }

    #inner-box {
      margin: 10px;
      border: none;
      background-color: #1e1e2e;
    }

    #outer-box {
      margin: 10px;
      border: none;
      background-color: #1e1e2e;
    }

    #scroll {
      margin: 0px;
      border: none;
    }

    #text {
      margin: 5px;
      border: none;
      color: transparent;
      font-size: 1px;
    }

    #entry:selected {
      background-color: #2bdfba;
      border-radius: 10px;
      outline: none;
    }

    #entry {
      padding: 10px;
      border-radius: 10px;
      margin: 5px;
      background-color: #313244;
    }

    #entry:selected image {
      border: 3px solid #2bdfba;
      border-radius: 8px;
    }

    #entry image {
      min-width: 200px;
      min-height: 120px;
      border-radius: 8px;
    }
  '';

  home.file.".local/bin/hypr-wallpaper-wofi".source = wallpaperPickerScript;
}
