{ pkgs, ... }:
{
  # services.xserver.enable = false;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  security.polkit.enable = true;
services.gnome.gnome-keyring.enable = true;
security.pam.services.greetd.enableGnomeKeyring = true; # regreet 사용 시 중요!

# services.polkit-gnome.enable = true;
# security.pam.services.regreet.enableGnomeKeyring = true;
# services.gnome.gnome-keyring.enable = true;
  programs.regreet.enable = true;
  programs.niri.enable = true;
  programs.waybar.enable = true;
  # programs.yazi.enable = true;
  programs.xfconf.enable = true;
  programs.obs-studio.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
        thunar-volman
    ];
  };

programs.google-chrome = {
  enable = true;
  commandLineArgs = [
    "--password-store=basic" # 키링(Kwallet/Gnome-Keyring)을 쓰지 않음
  ];
};
 
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk # 폴백(Fallback)용으로 유지 추천
    ];
    
    # niri 세션에서 어떤 포털을 쓸지 우선순위 지정
    config.niri = {
      default = [ "gnome" "gtk" ];
      # 특정 기능(예: 스크린캐스트)에 대해 gnome 강제
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    };
  };

# services.greetd = {
#   enable = true;
#   settings = {
#     default_session = {
#       # 여기서 niri-session을 사용하도록 지정합니다.
#       command = "${pkgs.niri}/bin/niri-session"; 
#       user = "greeter"; # regreet 실행에 필요한 기본 사용자
#     };
#     # 필요하다면 initial_session 설정도 추가할 수 있습니다 (자동 로그인 시)
#   };
# };

# environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
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

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GDK_BACKEND="wayland";
    QT_QPA_PLATFORM="wayland";
    CHROME_FLAGS = "--enable-features=Vulkan --use-angle=vulkan";
    MOZ_ENABLE_WAYLAND="1";
# XCURSOR_THEME = "Vimix-white-cursors";
# XCURSOR_SIZE = "24";
  };

  # systemd.user.services.polkit-gnome-authentication-agent-1 = {
  #   description = "polkit-gnome-authentication-agent-1";
  #   wantedBy = [ "graphical-session.target" ];
  #   wants = [ "graphical-session.target" ];
  #   after = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     TimeoutStopSec = 10;
  #   };
  # };

  environment.systemPackages = with pkgs; [
    jq
    # libsecret
# niri
      xdg-desktop-portal-gnome
      xwayland-satellite
      wl-clipboard
hyprpolkitagent
      hypridle
      hyprlock
      hyprpaper
      # waybar
      swaynotificationcenter
      libnotify
      playerctl
      grim
      slurp
      vimix-cursors
      adwaita-icon-theme
      foot
      eww
      fuzzel
      ffmpegthumbnailer
      imagemagick
      pavucontrol
      # google-chrome

  (google-chrome.override {
    commandLineArgs = [
      "--password-store=basic"
    ];
  })

      gimp
      libreoffice
      vulkan-tools
      easyeffects
      fastfetch
      (discord.override {
       commandLineArgs = "--enable-wayland-ime --wayland-text-input-version=3";
       })
  (mpv.override { scripts = [
   mpvScripts.mpris
   mpvScripts.uosc
# mpvScripts.sponsorblock
  ];})
yazi
    ];
}
