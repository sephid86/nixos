# { pkgs, ... }:
# 1. 다른 배포판에서 nix home-manager 이용할때는
#   home.nix 와 config 가 같은 경로에 있어야함.
# 2. config 내에 있는 파일들은 
#   ~/.config 에서 수정하지 말고 config 에서 수정할것
# 3. ~/.config/nix/nix.conf 에 아래 필수
#   experimental-features = nix-command flakes
# -----
# 이하 다른 배포판에서 첫 복구시 명령어들
# -----
# mkdir -p ~/.config/nix
# echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
# git add .
# nix run github:nix-community/home-manager/release-25.11 -- --impure switch --flake .#계정아이디
# -----
# 무언가를 수정했다면 hswitch 하면 됨.
# 혹시라도 hswitch 가 안되면 터미널을 껏다 켜보거나 아래 명령어.
# home-manager switch --flake ~/homenix#계정아이디
# hswitch 는 아래처럼 생겼음.
# hswitch = "cd ~/homenix && git add . && home-manager switch --flake .#계정아이디";
# 아래 경로 꼭 변경할것.
# userPath = "/home/계정아이디/homenix";

{ pkgs, lib, config, catppuccin, ... }:

let
# 1. 아웃 링크를 걸 실제 하드디스크 상의 절대 경로 변수
userPath = "/home/sephid86/homenix";

# 2. 파일 목록을 읽기 위한 상대 경로
configDir = ./config;

# 3. 전체 자동화 로직 (mkOutOfStoreSymlink 적용)
allConfigs = builtins.listToAttrs (map (name: {
      inherit name;
      value = { 
# .config 내부의 모든 파일을 /etc/nixos 주소로 직접 연결합니다.
      source = config.lib.file.mkOutOfStoreSymlink "${userPath}/config/${name}"; 
      };
      }) (builtins.filter (name: 
          name != "dconf" && 
          name != "fontconfig" &&
          name != "swaync"
          ) (builtins.attrNames (builtins.readDir configDir))));
in

{
  imports = [
    catppuccin.homeModules.catppuccin # 독립형에서는 homeModules가 정석
  ];
  home.username = "sephid86";
  home.homeDirectory = "/home/sephid86";
  home.stateVersion = "25.11";
  home.enableNixpkgsReleaseCheck = false;
  xdg.configFile = allConfigs;
# xdg.configFile.".".source = ./.config;
# nixpkgs.config.allowUnfree = true;
  systemd.user.services.hyprpolkitagent = {
    Unit = {
      Description = "Hyprland Polkit Agent";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
# 2. 프로그램 설정 (enable 방식 - 설정 및 서비스 자동 관리)
  programs = {
    home-manager.enable = true;

# 크롬: 키링 잠금 해제 팝업 방지 및 Wayland 최적화
    google-chrome = {
      enable = true;
      commandLineArgs = [
        "--password-store=basic"
          "--enable-features=vulkan"
          "--use-angle=vulkan"
      ];
    };

# 멀티미디어 및 도구 (enable 권장 항목들)
    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [ mpris uosc ];
    };

    wezterm.enable = true;
# foot.enable = true;
    yazi = {
      enable = true;
      enableBashIntegration = false;
    };
    fastfetch.enable = true;
    fuzzel.enable = true;
    hyprlock.enable = true;
    waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };
    obs-studio.enable = true;
  };

# 3. 백그라운드 서비스 설정
  services = {
    hypridle.enable = true;
    hyprpaper.enable = true;
    swaync.enable = true;
    easyeffects.enable = true;
  };

# 4. GTK 및 UI 테마 (Nix 스타일로 관리)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Vimix-white-cursors";
      package = pkgs.vimix-cursors;
      size = 24;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

# 5. 사용자별 개별 패키지 목록 (전용 모듈이 없거나 단순 도구들)
  home.packages = with pkgs; [
    gcc
      lua
# 유틸리티
      jq
      xwayland-satellite
      wl-clipboard
      hyprpolkitagent
      libnotify
      playerctl
      grim
      slurp
      swayimg
      pavucontrol
      eww
      ffmpegthumbnailer
      imagemagick
      gimp
      libreoffice
      pciutils
      (discord.override {
       commandLineArgs = "--enable-wayland-ime --wayland-text-input-version=3";
       })
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    QT_QPA_PLATFORM = "wayland";

    XDG_CURRENT_DESKTOP = "GNOME";
    XDG_SESSION_DESKTOP = "GNOME";

    GLFW_IM_MODULE  = "fcitx";
    GTK_IM_MODULE  = "fcitx";
    QT_IM_MODULE  = "fcitx";
    XMODIFIERS  = "@im=fcitx";
    SDL_IM_MODULE  = "fcitx";
  };

  home.shellAliases = {
# git add를 포함하여 수정 사항을 즉시 반영하고 빌드
    nswitch = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild switch --flake .";
# 빌드 성공 후 찌꺼기까지 싹 청소 (가장 깔끔한 상태 유지)
    nconfirm = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild switch --flake . && sudo nix-collect-garbage -d";
    nconf = "sudoedit /etc/nixos/configuration.nix";
# 2. 사용자 설정 업데이트 (자주 실행: 새로운 패키지 설치 등)
# [수정] 이제 Standalone 방식의 명령어로 대체합니다.
    hswitch = "cd ~/homenix && git add . && home-manager switch --flake .#sephid86";

    vi = "nvim";
    sudo = "sudo "; # 뒤에 공백이 있어야 별칭 뒤의 명령어도 별칭 인식 가능
      ls = "ls --color=auto";

# 백업 및 SSH 관련
    sshcon = "ssh 접속아이디@접속주소";
    bakweb = "scp -r 접속아이디@접속주소:~/www ~/; tar -zcvf ~/$(date +%y%m%d)-bakweb.tgz ~/웹경로; rm -rf ~/웹경로";
    bakdb = "ssh 접속아이디@접속주소 mysqldump -u디비아이디 > $(date +%y%m%d).sql; tar -zcvf $(date +%y%m%d)-db.tgz $(date +%y%m%d).sql; rm $(date +%y%m%d).sql";
    bakall = "bakweb; bakdb";

# sway = "env XDG_CURRENT_DESKTOP=sway GTK_IM_MODULE=kime QT_IM_MODULE=kime XMODIFIERS=@im=kime sway";
  };

  programs.bash = {
    enable = true;
    initExtra = ''
# Yazi 종료 시 디렉토리 유지 함수 (r)
      function r() {
# --- 추가된 부분: 실행 시 무조건 설정 폴더로 이동 ---
# builtin cd -- "/etc/nixos/users/sephid86/.config" 2>/dev/null
# -----------------------------------------------
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
              fi
              rm -f -- "$tmp"
      }

# 프롬프트 설정 (PS1)
    PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]\$ '
      '';
  };
}
