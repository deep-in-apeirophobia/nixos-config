{ config, pkgs, ... }:
{
  # GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # Qt/KDE application theming
  qt = {
    enable = true;
    platformTheme = "gtk";  # Use GTK theme for Qt apps
    style = {
      name = "kvantum";
      package = pkgs.kvantum;
    };
  };

  # Kvantum theme configuration
  home.file.".config/Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=OrchisDark
  '';

  # XDG portal for proper integration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ pkgs.gsettings-desktop-schemas ];
  };
}
