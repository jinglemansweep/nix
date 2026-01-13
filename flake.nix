# NixOS and Home Manager flake configuration
{
  description = "NixOS and Home Manager configuration for louis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur.url = "github:nix-community/NUR";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nur, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      userConfig = {
        username = "louis";
        fullName = "Louis King";
        email = "jinglemansweep@gmail.com";
        githubUsername = "jinglemansweep";
        nfsHost = "ds920p.adm.ptre.es";
      };
    in
    {
      nixosConfigurations = {
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
                extraSpecialArgs = { inherit inputs userConfig; };
                users.${userConfig.username} = import ./home/nixos.nix;
              };
            }
          ];
        };

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
                extraSpecialArgs = { inherit inputs userConfig; };
                users.${userConfig.username} = import ./home/nixos.nix;
              };
            }
          ];
        };

        dev = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig; };
          modules = [
            ./hosts/dev
            ./hosts/common
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs userConfig; };
                users.${userConfig.username} = import ./home/server.nix;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        louis = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs userConfig; };
          modules = [ ./home/standalone.nix ];
        };
      };
    };
}
