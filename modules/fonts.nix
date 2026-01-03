{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      pretendard
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        d2coding
        nerd-fonts.d2coding
        nerd-fonts.symbols-only
        font-awesome
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Pretendard" ];
        serif = [ "Noto Serif CJK KR" ];
        monospace = [ "D2CodingLigature Nerd Font" "D2Coding" ]; 
      };
    };
  };
  environment.etc."tmp/fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
    <match target="pattern">
    <test qual="any" name="family"><string>sans</string></test>
    <edit name="family" mode="prepend" binding="strong">
    <string>Pretendard</string>
    </edit>
    </match>
    <match target="pattern">
    <test qual="any" name="family"><string>sans-serif</string></test>
    <edit name="family" mode="prepend" binding="strong">
    <string>Pretendard</string>
    </edit>
    </match>
    <match target="pattern">
    <test qual="any" name="family"><string>Noto Sans</string></test>
    <edit name="family" mode="prepend" binding="strong">
    <string>Pretendard</string>
    </edit>
    </match>
    <match target="pattern">
    <test qual="any" name="family"><string>Noto Sans CJK KR</string></test>
    <edit name="family" mode="prepend" binding="strong">
    <string>Pretendard</string>
    </edit>
    </match>
    <match target="pattern">
    <test qual="any" name="family"><string>monospace</string></test>
    <edit name="family" mode="prepend" binding="strong">
    <string>D2CodingLigature Nerd Font</string>
    </edit>
    </match>
    <alias>
    <family>sans</family>
    <prefer><family>Noto Sans CJK KR</family></prefer>
    </alias>
    <alias>
    <family>sans-serif</family>
    <prefer><family>Noto Sans CJK KR</family></prefer>
    </alias>
    <alias>
    <family>serif</family>
    <prefer><family>Noto Serif CJK KR</family></prefer>
    </alias>
    </fontconfig>
    '';
  systemd.user.tmpfiles.rules = [
    "L %h/.config/fontconfig/fonts.conf - - - - /etc/tmp/fonts.conf"
  ];
}
