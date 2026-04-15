{ nixpkgs, inputs, system, userConfig, projectLib, nur, sops-nix, home-manager }:

{
  mkDesktopHost = dir:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs userConfig projectLib; };
      modules = [
        ../hosts/${dir}
        ../hosts/common
        ../hosts/common/desktop.nix
        { nixpkgs.overlays = [ nur.overlays.default ]; }
        { environment.sessionVariables.NIX_INSTANCE_ID = dir; }
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs userConfig projectLib; };
            users.${userConfig.username} = import ../home/nixos.nix;
          };
        }
      ];
    };

  mkDevHost = dir:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs userConfig projectLib; };
      modules = [
        ../hosts/${dir}
        ../hosts/common
        { environment.sessionVariables.NIX_INSTANCE_ID = dir; }
        ../modules/nixos/virtualisation.nix
        ../modules/nixos/mounts.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs userConfig projectLib; };
            users.${userConfig.username} = import ../home/server.nix;
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
        ../hosts/${dir}
        ../hosts/common
        { networking = { inherit hostName domain; }; }
        { environment.sessionVariables.NIX_INSTANCE_ID = dir; }
        ../modules/nixos/virtualisation.nix
        ../modules/nixos/systemd
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs userConfig projectLib; };
            users.${userConfig.username} = import ../home/cloud.nix;
          };
        }
      ];
    };
}
