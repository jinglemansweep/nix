{ config, pkgs, lib, userConfig, ... }:

{
  # SOPS secrets configuration
  # Documentation: https://github.com/Mic92/sops-nix

  sops = {
    # Default secrets file (encrypted with age)
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Use age for decryption
    age = {
      # Key file location (generated with: age-keygen -o ~/.config/sops/age/keys.txt)
      keyFile = "/home/${userConfig.username}/.config/sops/age/keys.txt";
      # Don't generate a new key if missing
      generateKey = false;
    };

    secrets = {
      "example_api_key" = {
        owner = userConfig.username;
        group = "users";
        mode = "0400";
      };
    };
  };

  # Install sops and age CLI tools for managing secrets
  environment.systemPackages = [
    pkgs.sops
    pkgs.age
  ];
}
