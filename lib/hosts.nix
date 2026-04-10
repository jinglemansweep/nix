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
        ../modules/nixos/roles/cloud-server.nix
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
