{
  description = "sephid86 NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # 시스템 레벨에서는 catppuccin이나 home-manager가 이제 필요 없습니다.
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix # 하드웨어 및 기본 시스템 설정
      ];
    };
  };
}
