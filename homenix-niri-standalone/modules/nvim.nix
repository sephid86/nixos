{ pkgs, config, ... }:

{
catppuccin.nvim.enable = false; 
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  xdg.configFile."nvim".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/homenix/config/nvim";
}
