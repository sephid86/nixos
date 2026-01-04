{ config, pkgs, ... }:

{
catppuccin.wezterm.enable = false;
  programs.wezterm = {
    enable = true;
  };
  xdg.configFile."wezterm".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/homenix/config/wezterm";
}
