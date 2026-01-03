{ config, pkgs, ... }:

{
  # Tailscale 활성화
  services.tailscale.enable = true;

  # 방화벽 설정 (KDE Connect & Syncthing)
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
    checkReversePath = "loose"; # Tailscale 무결성 확보
  };
}

