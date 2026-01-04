{ pkgs, ... }:

{
catppuccin.fuzzel.enable = true;
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=14";
        terminal = "wezterm";
        prompt = "🚀 ";
        layer = "overlay";
      };
      border = {
        width = 2;
        radius = 10;
      };
      # colors 섹션은 적지 마세요.
    };
  };
}
