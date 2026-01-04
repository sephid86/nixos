{ config, pkgs, ... }:

{
catppuccin.yazi.enable = false;
  programs.yazi = {
    enable = true;
    # enableBashIntegration = false;
  };
  xdg.configFile."yazi".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/homenix/config/yazi";
}
