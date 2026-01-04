{ pkgs, config, lib, ... }:

{
  programs.niri.settings = {
    # ... (기존 binds 설정 뒤에 추가)

    window-rules = [
      # 1. 기본 창 스타일 (테두리 및 라운딩)
      {
        draw-border-with-background = false;
        geometry-corner-radius = 4;
        clip-to-geometry = true;
      }

      # 2. 비활성 창 투명도 (0.85 무결성 유지)
      {
        matches = [{ is-active = false; }];
        opacity = 0.85;
      }

      # 3. 플로팅 창 그림자 ON
      {
        matches = [{ is-floating = true; }];
        shadow.on = true;
      }

      # 4. MPV: 항상 불투명하게 (영상 시청 무결성)
      {
        matches = [{ app-id = "mpv"; }];
        opacity = 1.0;
      }

      # 5. Polkit Agent: 자동 플로팅
      {
        matches = [{ app-id = "org.hyprland.polkit-agent"; }];
        open-floating = true;
      }

      # 6. Wezterm 플로팅 클래스 (사용자님 커스텀 클래스)
      {
        matches = [{ app-id = "wezterm-floating"; }];
        open-floating = true;
      }

      # 7. Firefox Picture-in-Picture (정규표현식 이식)
      {
        matches = [{ 
          app-id = "firefox$"; 
          title = "^Picture-in-Picture$"; 
        }];
        open-floating = true;
      }

      # 8. 유튜브 시청 중 크롬: 불투명도 고정 (정규표현식 반영)
      {
        matches = [{ 
          title = ".+ - YouTube - (Google )?Chrome$"; 
        }];
        opacity = 1.0;
      }

      # 9. PIP 모드 (크롬 등): 크기 및 위치 정밀 제어
      {
        matches = [{ title = "PIP 모드"; }];
        open-floating = true;
        max-height = 270;
        default-floating-position = { 
          x = 10; 
          y = 10; 
          relative-to = "bottom-right"; 
        };
        opacity = 1.0;
      }
    ];
  };
}
