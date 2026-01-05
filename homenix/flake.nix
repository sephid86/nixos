{
  description = "sephid86 Standalone Home Manager Flake";

  inputs = {
    # 25.11 Stable 정석 채널
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, catppuccin, home-manager, ... }@inputs: {
    # [핵심] 독립형 설정은 nixosConfigurations가 아니라 homeConfigurations를 사용합니다.
    homeConfigurations.sephid86 = home-manager.lib.homeManagerConfiguration {
      # 사용자님의 시스템에 맞는 패키지 세트 주입
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      
      # home.nix에 필요한 재료(catppuccin 등) 전달
      extraSpecialArgs = { inherit catppuccin; }; 
      
      modules = [ 
        ./home.nix 
        # Discord 등 Unfree 패키지 허용을 위한 설정
        { nixpkgs.config.allowUnfree = true; }
      ];
    };
  };
}
