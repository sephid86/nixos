# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules
# ./niri.niafgasdfsadxxxgsssdfasdgaaasdsagasdgasdgawhatx
    ];

# Time Zone and Hardware Clock Settings
  time = {
    timeZone = "Asia/Seoul";
    hardwareClockInLocalTime = false; # UTC 방식을 사용하여 윈도우와 시간 충돌 방지 (리눅스 정석)
  };

# Kernel n boot
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernel = {
      sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "vm.swappiness" = 10;
      };
    };

    extraModprobeConfig = "options btusb enable_autosuspend=0";
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
    };

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

    kernelParams = [
      "quiet"
        "splash"
        "vga=current"
        "udev.log_priority=5"
        "usbcore.autosuspend=-1"
    ];
  };

# Input Method (Fcitx5 for Hangul)
  # i18n.defaultLocale = "ko_KR.UTF-8";
i18n.defaultLocale = "en_US.UTF-8";
i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "ko_KR.UTF-8/UTF-8" ]; # 한글 폰트/데이터를 미리 생성해둬야 함
  # i18n.inputMethod = {
  #   type = "fcitx5";
  #   enable = true;
  #   fcitx5 = {
  #     waylandFrontend = true;
  #     addons = with pkgs; [ fcitx5-hangul qt6Packages.fcitx5-configtool fcitx5-gtk ];
  #   };
  # };
  # nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs = {
# # 1. 라이젠 5600(Zen 3) CPU 밀착 최적화
    hostPlatform = {
#       gcc.arch = "znver3";    # Ryzen 5600 전용 명령어 최적화
#         gcc.tune = "znver3";    # Zen 3 마이크로아키텍처 튜닝
        system = "x86_64-linux";
    };

# 2. 패키지 정책 및 호환성 설정
    config = {
      allowUnfree = true;        # 비자유 소프트웨어(드라이버 등) 허용
        enable1ultilib = true;     # 32비트 앱(스팀 등) 지원 (저거 오타 아님.)
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.enableRedistributableFirmware = true;

# Networking
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
# Shows battery charge of connected devices on supported
# Bluetooth adapters. Defaults to 'false'.
# Experimental = true;
# When enabled other devices can connect faster to us, however
# the tradeoff is increased power consumption. Defaults to
# 'false'.
# FastConnectable = true;
      };
      Policy = {
# Enable all controllers when they are found. This includes
# adapters present on start as well as adapters that are plugged
# in later on. Defaults to 'true'.
# AutoEnable = true;
      };
    };
  };

# User Account
  users.users.sephid86 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "bluetooth" ]; # audio/video 그룹 추가 권장
  };

  environment.shellAliases = {
    vi = "nvim";
    sudo = "sudo ";
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
  };

# PipeWire (Sound Server)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin # 압축 파일 관리
      thunar-volman         # USB/외부 드라이브 관리
    ];
  };

  services.xserver.enable = false;
  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
# services.openssh.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.polkit.enable = true;

# programs.ssh.startAgent = true;
  programs.regreet.enable = true;
  programs.git.enable = true;
  programs.niri.enable = true;
  programs.xfconf.enable = true;
  programs.dconf.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ 
  #     pkgs.xdg-desktop-portal-gnome 
  #     pkgs.xdg-desktop-portal-wlr
  #     pkgs.xdg-desktop-portal-gtk
  #   ];
  #   config.niri = {
  #     default = [ "gnome" "gtk" "wlr" ];
  #   };
  # };

  environment.systemPackages = with pkgs; [
      vulkan-tools
      libva-utils
  # xdg-utils 
  # glib
  # shared-mime-info
  ];

  system.stateVersion = "25.11"; 
}
