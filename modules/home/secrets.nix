{ config, pkgs, lib, userConfig, ... }:

{
  # SOPS secrets configuration for Home Manager
  # Documentation: https://github.com/Mic92/sops-nix

  sops = {
    # Default secrets file (encrypted with age)
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Age key location (generated with: age-keygen -o ~/.config/sops/age/keys.txt)
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      # Example secret - decrypts to ~/.config/sops-nix/secrets/example_api_key
      "example_api_key" = { };
    };
  };

  # Install sops and age CLI tools for managing secrets
  home.packages = [
    pkgs.sops
    pkgs.age
  ];
}
