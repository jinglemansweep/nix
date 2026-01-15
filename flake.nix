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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nur, sops-nix, nixos-generators, ... }@inputs:
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

      # Shared modules for docker-runner VMs
      dockerRunnerModules = [
        ./hosts/docker-runner
        ./hosts/common
        ./modules/nixos/virtualisation.nix
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
    in
    {
      nixosConfigurations = {
        latitude = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig; };
          modules = [
            ./hosts/latitude
            ./hosts/common
            ./hosts/common/desktop.nix
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
            ./hosts/common/desktop.nix
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
            ./modules/nixos/virtualisation.nix
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

        # docker-runner VMs use cloud-init, rebuild with: nixos-rebuild switch --flake .#docker-runner
        docker-runner = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs userConfig; };
          modules = dockerRunnerModules ++ [
            ./hosts/docker-runner/hardware-configuration.nix
          ];
        };
      };

      # VM images
      packages.${system} = {
        docker-runner = nixos-generators.nixosGenerate {
          inherit system;
          specialArgs = { inherit inputs userConfig; };
          modules = dockerRunnerModules ++ [
            {
              proxmox.qemuConf.bios = "ovmf";
              virtualisation.diskSize = 16 * 1024; # 16GB
            }
          ];
          format = "proxmox";
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
