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
      projectLib = import ./lib;

      userConfig = {
        username = "louis";
        fullName = "Louis King";
        email = "jinglemansweep@gmail.com";
        githubUsername = "jinglemansweep";
        nfsHost = "ds920p.adm.ptre.es";
      };
      mkDesktopHost = dir:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig projectLib; };
          modules = [
            ./hosts/${dir}
            ./hosts/common
            ./hosts/common/desktop.nix
            { nixpkgs.overlays = [ nur.overlays.default ]; }
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs userConfig projectLib; };
                users.${userConfig.username} = import ./home/nixos.nix;
              };
            }
          ];
        };

      mkCloudHost = dir: fqdn:
        let
          parts = nixpkgs.lib.splitString "." fqdn;
          hostName = builtins.head parts;
          domain = nixpkgs.lib.concatStringsSep "." (builtins.tail parts);
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig projectLib; };
          modules = [
            ./hosts/${dir}
            ./hosts/common
            { networking = { inherit hostName domain; }; }
            ./modules/nixos/roles/cloud-server.nix
            ./modules/nixos/virtualisation.nix
            ./modules/nixos/systemd
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs userConfig projectLib; };
                users.${userConfig.username} = import ./home/cloud.nix;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        latitude = mkDesktopHost "latitude";
        lounge = mkDesktopHost "lounge";

        dev = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig projectLib; };
          modules = [
            ./hosts/dev
            ./hosts/common
            ./modules/nixos/virtualisation.nix
            ./modules/nixos/mounts.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs userConfig projectLib; };
                users.${userConfig.username} = import ./home/server.nix;
              };
            }
          ];
        };
        s1 = mkCloudHost "cloud" "s1.cloud.ptre.es";
      };

      homeConfigurations = {
        louis = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs userConfig projectLib; };
          modules = [ ./home/standalone.nix ];
        };
      };
    };
}
