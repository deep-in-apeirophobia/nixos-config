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
    platformTheme.name = "qt5ct";  # Use GTK theme for Qt apps
    style = {
      name = "Utterly Nord Plasma";
      package = pkgs.utterly-nord-plasma;
    };
  };
	xdg.configFile = {
		"Kvantum/Utterly-Nord-Solid-Plasma/Utterly-Nord-Solid/Utterly-Nord-Solid.kvconfig".source = "${pkgs.utterly-nord-plasma}/share/Kvantum/Utterly-Nord-Solid/Utterly-Nord-Solid.kvconfig";
		"Kvantum/Utterly-Nord-Solid-Plasma/Utterly-Nord-Solid/Utterly-Nord-Solid.svg".source = "${pkgs.utterly-nord-plasma}/share/Kvantum/Utterly-Nord-Solid/Utterly-Nord-Solid.svg";
		"Kvantum/Utterly-Nord-Solid-Plasma/Utterly-Nord-Solid/Nord.patchconfig".source = "${pkgs.utterly-nord-plasma}/share/Kvantum/Utterly-Nord-Solid/Nord.patchconfig";
		"Kvantum/kvantum.kvconfig".text = ''
		[General]
		theme=Utterly-Nord-Solid
		'';
	};

  # Kvantum theme configuration
  # home.file.".config/Kvantum/kvantum.kvconfig".text = ''
  #   [General]
  #   theme=OrchisDark
  # '';

  # XDG portal for proper integration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ pkgs.gsettings-desktop-schemas ];
  };

	home.packages = with pkgs; [
		utterly-nord-plasma
		libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
	];
}
