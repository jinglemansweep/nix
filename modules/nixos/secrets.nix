# NixOS-level SOPS secrets: user password hash
{ config, lib, userConfig, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${userConfig.username}/.config/sops/age/keys.txt";
    secrets.user_password_hash = {
      neededForUsers = true;
    };
  };
}
