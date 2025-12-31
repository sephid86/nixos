{
  description = "sephid86 NixOS and Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    
    # 홈 매니저 (nixpkgs 버전과 일치시킴)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # 'nixos' 부분은 본인의 hostname(기본값 nixos)과 일치해야 합니다.
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        
        # 홈 매니저를 NixOS 모듈로 통합
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          # 본인 계정명으로 수정하세요
          home-manager.users.sephid86 = import ./users/sephid86/home.nix;
        }
      ];
    };
  };
}

