#!/usr/bin/env lua

--[[
    fcitx5-status-lang.lua
    Copyright (c) 2026 Google Gemini (Author)
    Idea provided, tested, and debugged by sephid86 (Co-Author)
    
    GitHub: github.com
    Gist: gist.github.com
    Email: sephid86@gmail.com
    License: MIT
    
    Description: 
    Extremely efficient Fcitx5 language status monitor for Waybar.
    This version achieves 'Zero PID Increment' by utilizing direct 
    D-Bus communication via the LGI library, eliminating the need 
    for any external process calls.
]]

-- 1. NixOS 자가 치유 및 LGI 로드
-- Self-healing for NixOS and LGI library loading
local status, lgi = pcall(require, 'lgi')

if not status then
    local f = io.open("/etc/os-release", "r")
    if f then
        local content = f:read("*all")
        f:close()
        -- NixOS 환경 감지 시 필요한 패키지를 포함하여 자동 재실행
        -- Re-execute with nix-shell when NixOS environment is detected
        if content:match("ID=nixos") and not os.getenv("IN_NIX_SHELL") then
            local cmd = string.format("nix-shell -p 'pkgs.lua.withPackages (ps: [ps.lgi])' -p gobject-introspection -p glib --run 'lua %s'", arg[0])
            os.execute(cmd)
            os.exit()
        end
    end
    error("LGI module not found. Please install 'lua-lgi'.")
end

local Gio = lgi.Gio
local GLib = lgi.GLib

-- 출력 버퍼 즉시 비우기 (실시간 반영 보장)
-- Flush output buffer immediately for real-time updates
io.stdout:setvbuf('line')

-- 2. D-Bus 프록시 설정 (Direct D-Bus Proxy Setup)
-- D-Bus와 직접 통신하여 외부 프로세스 생성 없이 정보를 가져옵니다.
-- Communicates directly with D-Bus without creating external processes.
local bus = Gio.bus_get_sync(Gio.BusType.SESSION)
local proxy = Gio.DBusProxy.new_sync(
    bus,
    Gio.DBusProxyFlags.NONE,
    nil,
    'org.fcitx.Fcitx5',
    '/controller',
    'org.fcitx.Fcitx.Controller1',
    nil
)

-- 3. 상태 업데이트 및 출력 함수 (PID 증가 없음!)
-- JSON output function using direct D-Bus query.
local function update_status()
    -- fcitx5-remote -n 명령어를 직접적인 D-Bus 쿼리로 대체
    -- Replaces external command calls with a direct D-Bus method call.
    local res = proxy:call_sync('CurrentInputMethod', nil, 0, -1, nil)
    if res then
        local ime = res:get_child_value(0):get_string()
        
        -- 언어 판별 및 범용 출력 로직
        -- Language detection and universal output logic
        if ime == "" or ime:match("^keyboard%-us$") or ime:match("^us$") then
            -- 영어(기본) 레이아웃
            -- English (Default) layout
            print("ENG")
        elseif ime:match("hangul") then
            -- 한국어 유저를 위한 명시적 표기
            -- Explicit notation for Korean users
            print("한글")
        else
            -- 일본어(mozc), 중국어(pinyin) 등 기타 모든 언어는 이름을 대문자로 출력
            -- For all other languages (e.g., mozc, pinyin), print the name in uppercase
            print(ime:upper())
        end
    end
end

-- 4. 초기 상태 출력 (Print initial status)
update_status()

-- 5. D-Bus 신호 구독 (이벤트 발생 시 즉시 반응 / Event Subscription)
-- 신뢰성 있는 신호들을 구독하여 입력기 상태 변화에 즉각 대응합니다.
-- Subscribes to reliable signals for immediate reaction to status changes.
if bus then
    -- 입력 상태가 바뀔 때 발생하는 Fcitx5 고유 신호 구독
    -- Subscribe to Fcitx5 native status change signal.
    bus:signal_subscribe(
        'org.fcitx.Fcitx5',
        'org.fcitx.Fcitx.InputMethod1',
        'StatusChanged',
        '/org/fcitx/Fcitx5/InputMethod1',
        nil,
        Gio.DBusSignalFlags.NONE,
        update_status
    )
    
    -- 범용성을 위해 기존의 신호들도 유지 (StatusNotifier 등)
    -- Maintain auxiliary signals for universal compatibility.
    bus:signal_subscribe(nil, "org.kde.StatusNotifierItem", "NewIcon", nil, nil, 0, update_status)
    bus:signal_subscribe(nil, "com.canonical.dbusmenu", "LayoutUpdated", nil, nil, 0, update_status)
end

-- 6. 메인 루프 실행 (Start main event loop)
-- 이벤트 기반 방식으로 CPU 점유율이 0%에 수렴합니다.
-- Minimal CPU usage via event-driven architecture.
GLib.MainLoop():run()
