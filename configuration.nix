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
  boot = {
# 커널 모듈 설정
    extraModprobeConfig = "options btusb enable_autosuspend=0";

# 부팅 로그 레벨 설정
    consoleLogLevel = 3;
    initrd.verbose = false;

# 부트로더 설정
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };

# 플리머스(부팅 스플래시 화면) 설정
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };

# Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "quiet"
    "splash"
    "vga=current"
    "udev.log_priority=5"
    "usbcore.autosuspend=-1" 
  ];

# Input Method (Fcitx5 for Hangul)
  i18n.defaultLocale = "ko_KR.UTF-8";
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [ fcitx5-hangul qt6Packages.fcitx5-configtool fcitx5-gtk ];
    };
  };

# Nixpkgs Configuration
  nixpkgs.config = {
    allowUnfree = true;
    instructionSet = "x86-64";
    enable1ultilib = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.enableRedistributableFirmware = true;

# Fonts
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans CJK KR" ];
        serif = [ "Noto Serif CJK KR" ];
        monospace = [ "D2CodingLigature Nerd Font" "D2Coding" ]; 
      };
    };
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      d2coding
      nerd-fonts.d2coding
      nerd-fonts.symbols-only
      font-awesome
    ];
  };

# Networking
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        # FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

# User Account
  users.users.sephid86 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "bluetooth" ]; # audio/video 그룹 추가 권장
  };

# Environment and Editor Aliases
  environment.shellAliases = {
    vi = "nvim";
    sudo = "sudo ";
    nconfirm = "sudo nixos-rebuild switch && sudo nix-collect-garbage -d";
    nswitch = "sudo nixos-rebuild switch";
    nconf = "sudoedit /etc/nixos/configuration.nix";
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

# Neovim Program
  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

# System Services
  services.dbus.enable = true;
  services.udisks2.enable = true; # 자동 마운트 지원
  services.gvfs.enable = true; # Thunar 같은 파일 매니저 기능 지원
  services.openssh.enable = true;
  services.xserver.enable = false; # X 서버 비활성화 명시 (기본값)

  security.polkit.enable = true; # 권한 관리 지원

# PipeWire (Sound Server)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # PulseAudio 호환성
    jack.enable = true;
  };

  programs.regreet.enable = true;
  programs.hyprland.enable = true;
  programs.yazi.enable = true;

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

# Cursor Theme Configuration (시스템 전반 적용, Home Manager 옵션 회피)
# GTK/XWayland 환경 변수 설정
  environment.sessionVariables = {
    ELECTRON_ENABLE_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    # Hyprland 자체 (Wayland 네이티브)
    HYPRCURSOR_THEME = "Vimix-white-cursors";
    HYPRCURSOR_SIZE = "24"; 

    # XWayland (X 애플리케이션용) 및 GTK
    XCURSOR_THEME = "Vimix-white-cursors";
    XCURSOR_SIZE = "24";
    # GTK_THEME = "Adwaita:dark";
    # GTK_ICON_THEME = "Adwaita";
    # GTK_CURSOR_THEME = "Vimix-white-cursors";
    #크롬에서 vulkan 활성화 - 동영상 그래픽 하드웨어 가속 관련
    CHROME_FLAGS = "--enable-features=Vulkan --use-angle=vulkan";
  };

# GTK 설정 파일에 직접 기재하여 Greetd 및 GTK 앱에도 적용
  environment.etc."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-name=Vimix-white-cursors
    gtk-cursor-theme-size=24
    '';
  environment.etc."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-name=Vimix-white-cursors
    gtk-cursor-theme-size=24
    '';

# System Packages
  environment.systemPackages = with pkgs; [
    gcc
    git
    python3
    python3Packages.pip
    jq
    wl-clipboard
    hyprpolkitagent
    hypridle
    hyprlock
    dunst
    libnotify
    grim
    slurp
    vimix-cursors
    papirus-icon-theme
    adwaita-icon-theme
    foot
    waybar
    eww
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
    # discord
    (discord.override {
      commandLineArgs = "--enable-wayland-ime";
    })
    fastfetch
    ];

  system.stateVersion = "25.05"; 
}
