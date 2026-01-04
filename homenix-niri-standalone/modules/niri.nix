{ config, pkgs, ... }:

{

    # catppuccin.niri.enable = true;
  programs.niri = {
    enable = true;
  };
  xdg.configFile."niri".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/homenix/config/niri";
}
