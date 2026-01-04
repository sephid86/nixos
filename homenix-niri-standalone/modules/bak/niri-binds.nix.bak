{ pkgs, config, lib, ... }:

{
  programs.niri.settings = {
# 1. 스크린샷 경로 설정 (무결성 고정)
    screenshot-path = "~/Screenshots/ss-%y%m%d-%H%M%S.png";

# 2. 키 바인딩 (binds) 마이그레이션
    binds = with config.lib.niri.actions; {
# 도움말 및 실행
      "Mod+Ctrl+Slash".action = show-hotkey-overlay;
      "Mod+D".action = spawn "fuzzel";

# Wezterm 및 Yazi 실행 (사용자님의 커스텀 명령어 반영)
      "Mod+Return".action = spawn "wezterm" "start" "bash" "-ic" "r; exec bash";
      "Mod+Shift+Return".action = spawn "wezterm" "start" "--class" "wezterm-floating" "bash" "-ic" "r; exec bash";

# LazyVim (플로팅 Wezterm 기반 무결성 설정)
      "Mod+E".action = spawn "sh" "-c" "wezterm start --class wezterm-floating sh -c 'echo | nvim'";

# 오디오 제어 (allow-when-locked=true 반영)
      "XF86AudioRaiseVolume" = { allow-when-locked = true; action = spawn "wpctl" "set-volume" "-l" "1" "@DEFAULT_AUDIO_SINK@" "0.1+"; };
      "XF86AudioLowerVolume" = { allow-when-locked = true; action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; };
      "XF86AudioMute"        = { allow-when-locked = true; action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; };
      "XF86AudioMicMute"     = { allow-when-locked = true; action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; };

# 미디어 제어
      "XF86AudioPlay".action = spawn "playerctl" "play-pause";
      "XF86AudioStop".action = spawn "playerctl" "stop";
      "XF86AudioPrev".action = spawn "playerctl" "previous";
      "XF86AudioNext".action = spawn "playerctl" "next";

# 창 관리 및 포커스 (HJKL / 방향키)
      "Mod+Q".action = toggle-overview;
      "Mod+Shift+Q".action = close-window;

      "Mod+Left".action = focus-column-left;
      "Mod+Down".action = focus-window-down;
      "Mod+Up".action = focus-window-up;
      "Mod+Right".action = focus-column-right;
      "Mod+H".action = focus-column-left;
      "Mod+J".action = focus-window-down;
      "Mod+K".action = focus-window-up;
      "Mod+L".action = focus-column-right;

# 창 이동 (Shift + HJKL)
      "Mod+Shift+Left".action = move-column-left;
      "Mod+Shift+Down".action = move-window-down;
      "Mod+Shift+Up".action = move-window-up;
      "Mod+Shift+Right".action = move-column-right;
      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+J".action = move-window-down;
      "Mod+Shift+K".action = move-window-up;
      "Mod+Shift+L".action = move-column-right;

# 워크스페이스 이동
      "Mod+P".action = focus-workspace-up;
      "Mod+Semicolon".action = focus-workspace-down;
      "Mod+Shift+P".action = move-column-to-workspace-up;
      "Mod+Shift+Semicolon".action = move-column-to-workspace-down;

# 레이아웃 제어
      "Mod+R".action = switch-preset-column-width;
      "Mod+Shift+R".action = switch-preset-window-height;
      "Mod+Ctrl+R".action = reset-window-height;
      "Mod+F".action = fullscreen-window;
      "Mod+Shift+F".action = maximize-window-to-edges;
      "Mod+C".action = center-column;
      "Mod+Z".action = toggle-window-floating;
      "Mod+Space".action = switch-focus-between-floating-and-tiling;
# 1. 마우스 휠 워크스페이스 이동 (쿨다운 포함 무결성 설정)
      "Mod+WheelScrollDown" = { cooldown-ms = 150; action = focus-workspace-down; };
      "Mod+WheelScrollUp"   = { cooldown-ms = 150; action = focus-workspace-up; };
      "Mod+Ctrl+WheelScrollDown" = { cooldown-ms = 150; action = move-column-to-workspace-down; };
      "Mod+Ctrl+WheelScrollUp"   = { cooldown-ms = 150; action = move-column-to-workspace-up; };

# 2. 마우스 휠 가로 이동 (포커스 및 이동)
      "Mod+WheelScrollRight".action = focus-column-right;
      "Mod+WheelScrollLeft".action  = focus-column-left;
      "Mod+Ctrl+WheelScrollRight".action = move-column-right;
      "Mod+Ctrl+WheelScrollLeft".action  = move-column-left;

# 3. 마우스 휠 + Shift 조합 (가로 이동 확장)
      "Mod+Shift+WheelScrollDown".action = focus-column-right;
      "Mod+Shift+WheelScrollUp".action   = focus-column-left;
      "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
      "Mod+Ctrl+Shift+WheelScrollUp".action    = move-column-left;

# 4. 창 합치기 및 내보내기 (Consume / Expel)
      "Mod+Period".action = consume-or-expel-window-right;
      "Mod+Comma".action  = consume-or-expel-window-left;
      "Mod+Shift+Comma".action = consume-window-into-column;
      "Mod+Shift+Period".action = expel-window-from-column;

# 5. 첫 번째/마지막 열로 점프
      "Mod+I".action = focus-column-first;
      "Mod+O".action = focus-column-last;
      "Mod+Ctrl+I".action = move-column-to-first;
      "Mod+Ctrl+O".action = move-column-to-last;

# 6. 정밀한 창 크기 조절 (10% 단위 정밀 타격)
      "Mod+Ctrl+L".action = set-column-width "+10%";
      "Mod+Ctrl+H".action = set-column-width "-10%";
      "Mod+Ctrl+K".action = set-window-height "+10%";
      "Mod+Ctrl+J".action = set-window-height "-10%";

# 7. 기타 특수 기능
      "Mod+U".action = toggle-column-tabbed-display;
      "Mod+Ctrl+F".action = expand-column-to-available-width;
      "Mod+Shift+C".action = center-visible-columns;
# 스크린샷 (Print 키)
      "Print".action = screenshot;
      "Shift+Print".action = screenshot-screen;
      "Ctrl+Print".action = screenshot-window;
# 1. 키보드 단축키 억제 해제 (리모트 데스크톱 등에서 필수)
      "Mod+Escape" = {
        allow-inhibiting = false;
        action = toggle-keyboard-shortcuts-inhibit;
      };

# 2. 종료 및 재시작 (accidental exit 방지)
      "Mod+Shift+E".action = quit;
      "Ctrl+Alt+Delete".action = quit;

# 3. [핵심] 오디오 출력(Sink) 선택기 (pw-dump + jq + fuzzel)
      "Mod+Slash" = {
        action = spawn "sh" "-c" ''
          SINK_JSON=$(pw-dump | jq '[.[] | select(.type == "PipeWire:Interface:Node") | select(.info.props."media.class" == "Audio/Sink") | {id: .id, description: .info.props."node.description"}] | sort_by(.description)');
        SINK_NAMES=$(echo "$SINK_JSON" | jq -r '.[].description');
        SELECTED_NAME=$(echo "$SINK_NAMES" | fuzzel --dmenu --cache=$HOME/.cache/sinklist_fuzzel --prompt='Audio Output ' --anchor=top-right --x-margin=60 --y-margin=20 --width=30 --lines=3 --inner-pad=0);
        if [ -n "$SELECTED_NAME" ]; then
          SINK_ID=$(echo "$SINK_JSON" | jq -r ".[] | select(.description == \"$SELECTED_NAME\") | .id");
        wpctl set-default $SINK_ID;
        fi
          '';
      };

# 4. [핵심] 블루투스 장치 연결기 (bluetoothctl + fuzzel)
      "Mod+Shift+Slash" = {
        action = spawn "sh" "-c" ''
          SELECTED=$(bluetoothctl devices | grep 'Device' | fuzzel --dmenu --cache=$HOME/.cache/bluetooth_fuzzel --prompt='Bluetooth ' --anchor=top-right --x-margin=60 --y-margin=20 --width=30 --lines=3 --inner-pad=0) &&
          if [ -n "$SELECTED" ]; then
            bluetoothctl connect $(echo "$SELECTED" | awk '{print $2}');
        fi
          '';
      }; # binds 끝
    }; # settings 끝
  }; # settings 끝
}
