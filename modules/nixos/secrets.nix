# NixOS-level SOPS secrets: user password hash
{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/louis/.config/sops/age/keys.txt";
    secrets.user_password_hash = {
      neededForUsers = true;
    };
  };
}
