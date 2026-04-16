{ config, pkgs, lib, ... }:
{
  # GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        variant = "mocha";
      };
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
        gtk-icon-theme-name=Papirus-Dark
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-icon-theme-name=Papirus-Dark
      '';
    };
  };

  # Qt/KDE application theming using qt6ct and qt5ct
  qt = {
    enable = true;
    platformTheme.name = "gtk2";
    style = {
      name = "gtk2";
    };
  };

  # Configure qt6ct and qt5ct to use the GTK2 style (which follows your GTK theme)
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    standard_dialogs=gtk2
    style=gtk2

    [Fonts]
    fixed=@Variant(\0\0\0[@\0\0\0\x12\0M\0o\0n\0o\0 \0S\0p\0a\0c\0e\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x12)
    general=@Variant(\0\0\0[@\0\0\0\x12\0M\0o\0n\0o\0 \0S\0p\0a\0c\0e\0\0\0\n\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x1e)

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3
  '';

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    standard_dialogs=gtk2
    style=gtk2

    [Fonts]
    fixed="MonoSpace,10,-1,5,50,0,0,0,0,0"
    general="MonoSpace,12,-1,5,50,0,0,0,0,0"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3
  '';

  # Environment variables for Qt applications to use the proper theming
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  # XDG portal for proper integration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ pkgs.gsettings-desktop-schemas ];
  };

  home.packages = with pkgs; [
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    gtk-engine-murrine
    gtk_engines
    gnome-themes-extra
    papirus-icon-theme
    catppuccin-gtk
  ];
}
