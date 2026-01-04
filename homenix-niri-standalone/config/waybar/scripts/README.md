Fulleaf Linux (based on Arch Linux) developer. <br>
'풀잎 리눅스' 개발자입니다.

I also develop small utilities and occasionally contribute to other projects. <br>
또한, 소소한 유틸리티들을 개발하며 드물게 가끔 다른 오픈소스 프로젝트에도 아주 작지만 기여를 하고 있습니다. <br>
 <br>
I'm working towards becoming Cup Noodles Profitable. <br>
이 개발자는 오늘 굶었을지도 모릅니다. <br>
<br>
[![ Buy me a Cup noodles ](https://img.shields.io/badge/Buy%20me%20a%20cup%20noodles-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sephid86) [![ 컵라면 하나만 사주세요 ](https://img.shields.io/badge/%EC%BB%B5%EB%9D%BC%EB%A9%B4%20%ED%95%98%EB%82%98%EB%A7%8C%20%EC%82%AC%EC%A3%BC%EC%84%B8%EC%9A%94-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/sephid86)
<br>

Fcitx5 의 트레이 아이콘이 너무 구석에 있다 보니 시야에 잘 들어오지 않아서 <br>
지금 언어 입력상태가 한글 입력 상태인지 영문 입력 상태인지 <br>
시야에 들어오기 좀 더 쉽고 편하게 해보고자 만들었습니다. <br>
저는 이걸 윈도우 타이틀 옆에 표시되도록 설정해서 사용합니다. <br> 
##
CPU 점유율이나 부하가 없도록 그리고 리소스를 최소한만 사용하도록 하기 위해 <br>
많은 고민을 하고 AI 와 많은 토론과 많은 시행착오를 겪어가며 만들었습니다. AI 가 만들었습니다. <br>
<br>
High-efficiency event-driven architecture using Lua LGI. <br>
Zero idle CPU usage (0.0%). Single PID design with NixOS self-healing logic. <br>
Perfect for Waybar or any custom bar modules. (Tested by sephid86) <br>
##

### 설치 필요 - need packages
- Arch Linux: `sudo pacman -S lua-lgi fcitx5`
- Ubuntu/Debian: `sudo apt install lua-lgi fcitx5`
- Fedora: `sudo dnf install lua-lgi fcitx5`
- NixOS : `fcitx5 lua`

### waybar 에서 사용법 - How to use with Waybar
Waybar 설정 파일(`config`)에 아래 내용을 추가하세요: <br>
Add the following to your Waybar `config`:

```waybar config
"modules-center": ["YOUR_WM/window", "custom/fcitx5"],
"custom/fcitx5": {
    "exec": "/YOUR_PATH/fcitx5-status-lang.lua",
    //"return-type": "json",
    "format": "{}",
    "tooltip": false
}
```
!! 이 스크립트는 Fcitx5 의 트레이 아이콘이 표시 혹은 실행중일때만 동작가능합니다. Tested on waybar. <br>
!! This script requires the Fcitx5 tray icon to be enabled, as it relies on D-Bus signals from the StatusNotifierItem.

!! print 부분은 필요에 따라 json 이나 다른 형식으로 변경하여 사용하시면 됩니다. <br>
!! The output format in the print section can be customized to JSON or other structures to suit your specific bar configuration (e.g., Waybar's JSON mode).

🔗 왜 JSON 모드를 사용해야 하나요? / Why use JSON mode?
--
- 클래스 주입: 스크립트에서 직접 class 필드(예: "class": "kor")를 Waybar로 전달할 수 있습니다.
- Class Injection: You can pass a class field (e.g., "class": "kor") from the script directly to Waybar.
- 동적 스타일링: 입력 언어가 바뀔 때마다 오렌지색 캡슐 스타일 같은 다양한 CSS 효과를 자동으로 적용할 수 있습니다.
- Dynamic Styling: This allows you to apply different CSS styles (like your Orange Capsule) automatically when the language changes.
- 풍부한 데이터 처리: 스크립트 출력 결과에 따라 툴팁(Tooltip)이나 커스텀 아이콘 변경 등 더 고급 기능을 활용할 수 있습니다.
- Rich Data: It enables more advanced features like tooltips or custom icons based on the script's output.

### JSON 모드 사용시 아래와 같이 waybar config 를 수정해야 합니다.
When using JSON mode, the waybar config should be modified as follows: 
--
```waybar config
"modules-center": ["YOUR_WM/window", "custom/fcitx5"],
"custom/fcitx5": {
    "exec": "/YOUR_PATH/fcitx5-status-lang-json.lua",
    "return-type": "json",
    "format": "{}",
    "tooltip": false
}
```

<br>
새해 복 많이 받으세요. Happy New Year! - 2026-01-02 -
<br>