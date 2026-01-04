# homenix/modules/default.nix
{ ... }: {
  imports = [
    ./niri.nix
    ./fuzzel.nix
    ./nvim.nix
    ./yazi.nix
    ./wezterm.nix
    ./chrome.nix
    # 앞으로 추가될 모듈들을 여기에 줄 세우면 됩니다!
  ];
}
