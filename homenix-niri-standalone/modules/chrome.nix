{ pkgs, ... }:

{
  catppuccin.chromium.enable = true;
  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--password-store=basic"
        "--enable-features=vulkan"
        "--use-angle=vulkan"
    ];
  };
}
