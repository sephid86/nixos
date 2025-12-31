{ pkgs, ... }:
{
  services.xserver.enable = false;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  security.polkit.enable = true;

  programs.regreet.enable = true;
  programs.hyprland.enable = true;
  programs.xfconf.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
        thunar-volman
    ];
  };

  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/interface" = {
        "color-scheme" = "prefer-dark";
        "gtk-theme" = "Adwaita";
        "icon-theme" = "Adwaita";
        "cursor-theme" = "Vimix-white-cursors";
        "cursor-size" = "24";
      };
    };
  }];

  environment.etc = {
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=Vimix-white-cursors
      '';
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
        '';
  };
  systemd.user.tmpfiles.rules = [
    "L %h/.config/gtk-3.0/settings.ini - - - - /etc/gtk-3.0/settings.ini"
      "L %h/.config/gtk-4.0/settings.ini - - - - /etc/gtk-4.0/settings.ini"
  ];

  environment.systemPackages = with pkgs; [
    jq
      wl-clipboard
      hyprpolkitagent
      hypridle
      hyprlock
      swaynotificationcenter
      libnotify
      grim
      slurp
      vimix-cursors
      adwaita-icon-theme
      foot
      waybar
      eww
      wofi
      ffmpegthumbnailer
      imagemagick
      pavucontrol
  ];
}
