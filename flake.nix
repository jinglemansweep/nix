{
  description = "NixOS and Home Manager configuration for louis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix User Repository (for Firefox extensions)
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Common user configuration
      userConfig = {
        username = "louis";
        fullName = "Louis King";
        email = "jinglemansweep@gmail.com";
        nfsHost = "ds920p.adm.ptre.es";
      };
    in
    {
      # NixOS configurations
      nixosConfigurations = {
        # Dell Latitude 7420
        latitude = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig; };
          modules = [
            ./hosts/latitude
            ./hosts/common
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs userConfig; hostName = "latitude"; };
                users.${userConfig.username} = import ./home/nixos.nix;
              };
            }
          ];
        };

        # HP EliteDesk 800 G2 Mini (Lounge)
        lounge = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig; };
          modules = [
            ./hosts/lounge
            ./hosts/common
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs userConfig; hostName = "lounge"; };
                users.${userConfig.username} = import ./home/nixos.nix;
              };
            }
          ];
        };
      };

      # Standalone Home Manager configuration (for ChromeOS/WSL)
      homeConfigurations = {
        louis = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs userConfig; };
          modules = [ ./home/standalone.nix ];
        };
      };
    };
}
