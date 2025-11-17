# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

# Time Zone and Locale
  time.timeZone = "Asia/Seoul";
  time.hardwareClockInLocalTime = false;

# Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

# Input Method (Fcitx5 for Hangul)
  i18n.defaultLocale = "ko_KR.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-hangul qt6Packages.fcitx5-configtool fcitx5-gtk ];
  };

# Nixpkgs Configuration
  nixpkgs.config = {
    allowUnfree = true;
    instructionSet = "x86-64";
# enable1ultilib 옵션은 존재하지 않으므로 제거합니다.
  };

  nixpkgs.config.enable1ultilib = true;
# Hardware Configuration
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.enableRedistributableFirmware = true;

# Fonts
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      d2coding
      nerd-fonts.d2coding
      nerd-fonts.symbols-only
      font-awesome
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Noto Sans CJK KR" ];
    serif = [ "Noto Serif CJK KR" ];
    monospace = [ "D2CodingLigature Nerd Font" "D2Coding" ]; 
  };

# Networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

# User Account
  users.users.sephid86 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ]; # audio/video 그룹 추가 권장
  };

# Environment and Editor Aliases
  environment.shellAliases = {
    vi = "nvim";
    sudo = "sudo ";
  };
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";

# Neovim Program
  programs.neovim.enable = true;
  programs.neovim.vimAlias = true;

# System Services
  services.dbus.enable = true;
  services.udisks2.enable = true; # 자동 마운트 지원
  security.polkit.enable = true; # 권한 관리 지원
  services.gvfs.enable = true; # Thunar 같은 파일 매니저 기능 지원
  services.openssh.enable = true;
  services.xserver.enable = false; # X 서버 비활성화 명시 (기본값)

# PipeWire (Sound Server)
    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true; # PulseAudio 호환성
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };

# Display Manager (Greetd + Regreet)
# X 서버를 사용하지 않으므로 systemd-managed display manager를 사용합니다.
# services.displayManager.greetd = {
#   enable = true;
#   vt = 1; # 가상 터미널 1번에서 실행 (Wayland 기본)
#   greeter = {
#     command = "${pkgs.regreet}/bin/regreet";
#   };
# };
  programs.regreet.enable = true; # regreet 설정 파일을 관리하기 위해 활성화
  programs.hyprland.enable = true;
  programs.yazi.enable = true;


# Cursor Theme Configuration (시스템 전반 적용, Home Manager 옵션 회피)
# GTK/XWayland 환경 변수 설정
  environment.sessionVariables = {
# Hyprland 자체 (Wayland 네이티브)
    HYPRCURSOR_THEME = "Vimix-white-cursors";
    HYPRCURSOR_SIZE = "24"; 

# XWayland (X 애플리케이션용) 및 GTK
    XCURSOR_THEME = "Vimix-white-cursors";
    XCURSOR_SIZE = "24";
    GTK_CURSOR_THEME = "Vimix-white-cursors";
    CHROME_FLAGS = "--enable-features=Vulkan --use-angle=vulkan";
  };

# GTK 설정 파일에 직접 기재하여 Greetd 및 GTK 앱 보장
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Vimix-white-cursors
      gtk-cursor-theme-size=24
      '';
  environment.etc."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Vimix-white-cursors
      gtk-cursor-theme-size=24
      '';

# GTK 모듈 활성화
# gtk.enable = true;
  # environment.shellInit = ''
  #   export CHROME_FLAGS="--enable-features=Vulkan --use-angle=vulkan"
  # '';
# System Packages
  environment.systemPackages = with pkgs; [
    gcc
      git
      wl-clipboard
      hyprpolkitagent
      hypridle
      hyprlock
      grim
      slurp
      vimix-cursors # 커서 패키지는 설치되어 있어야 합니다.
      papirus-icon-theme
      adwaita-icon-theme
      foot
      waybar
      wofi
      google-chrome
      ffmpegthumbnailer
      xfce.tumbler
      xfce.thunar
      xfce.thunar-volman
      imagemagick
      pavucontrol
      mpv
      gimp
      libreoffice
      vulkan-tools
      obs-studio
      easyeffects
      discord
      fastfetch
      bluez
      ];

# System State Version (매우 중요)
# 25.05는 아직 불안정할 수 있어 23.11로 하향 권고합니다.
  system.stateVersion = "25.05"; 
}
