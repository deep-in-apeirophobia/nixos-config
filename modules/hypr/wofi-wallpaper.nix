{ config, pkgs, ... }:
let
  wallpaperPicker = pkgs.writeShellApplication {
    name = "hypr-wallpaper-wofi";
    runtimeInputs = with pkgs; [ coreutils findutils imagemagick wofi ];
    text = ''
      wallpaper_dir="$HOME/wallpapers"
      thumb_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/hypr-wallpaper-thumbs"
      mkdir -p "$thumb_dir"

      mapfile -t wallpapers < <(find -L "$wallpaper_dir" -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \
      \) | sort)
      if (( ''${#wallpapers[@]} == 0 )); then
        echo "No wallpapers found in $wallpaper_dir" >&2
        exit 1
      fi

      entries=()
      for file in "''${wallpapers[@]}"; do
        # Wofi decodes every image at full size, which takes seconds for a
        # folder of 4K wallpapers, so it gets small cached thumbnails instead.
        thumb="$thumb_dir/$(printf '%s' "$file" | sha1sum | cut -d' ' -f1).png"
        if [[ ! -f $thumb || $file -nt $thumb ]]; then
          magick "$file" -thumbnail 400x250^ -gravity center -extent 400x250 "$thumb" || continue
        fi
        # Wofi's image syntax is img:<image>:text:<label>; without the text:
        # marker the label is read as part of the image path. --parse-action
        # makes wofi print just the label back, so the label is the wallpaper
        # path (the stylesheet hides it, the search box still matches it).
        entries+=("img:$thumb:text:$file")
      done

      # Wofi exits non-zero when the picker is dismissed.
      selected=$(printf '%s\n' "''${entries[@]}" | wofi \
        --dmenu \
        --conf /dev/null \
        --style "''${XDG_CONFIG_HOME:-$HOME/.config}/wofi/wallpaper.css" \
        --prompt "Select wallpaper..." \
        --insensitive \
        --allow-images \
        --parse-action \
        --define image_size=250 \
        --cache-file /dev/null \
        --height 700 \
        --width 900 \
        --location center \
        --columns 3) || exit 0

      if [[ -n $selected ]]; then
        exec "$HOME/.local/bin/hypr-wallpaper" "$selected"
      fi
    '';
  };
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

  home.file.".local/bin/hypr-wallpaper-wofi".source = "${wallpaperPicker}/bin/hypr-wallpaper-wofi";
}
