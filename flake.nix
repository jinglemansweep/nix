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

      hostBuilders = projectLib.hosts {
        inherit nixpkgs inputs system userConfig projectLib;
        inherit (inputs) nur sops-nix home-manager;
      };
    in
    {
      nixosConfigurations = {
        latitude = hostBuilders.mkDesktopHost "latitude";
        lounge = hostBuilders.mkDesktopHost "lounge";

        dev = hostBuilders.mkDevHost "dev";
        pt-s1 = hostBuilders.mkCloudHost "pt-s1" "s1.cloud.ptre.es";
        ipnet-s1 = hostBuilders.mkCloudHost "ipnet-s1" "s1.cloud.ipnt.uk";
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
